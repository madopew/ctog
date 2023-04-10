package me.madopew.ctog.graph.impl

import me.madopew.ctog.model.graph.Graph
import me.madopew.ctog.model.graph.GraphConfiguration
import me.madopew.ctog.model.graph.GraphNode
import me.madopew.ctog.model.graph.NodeType
import me.madopew.ctog.parser.api.model.CodeCall
import me.madopew.ctog.parser.api.model.CodeExpression
import me.madopew.ctog.parser.api.model.CodeFunction
import me.madopew.ctog.parser.api.model.CodeIfSelection
import me.madopew.ctog.parser.api.model.CodeIteration
import me.madopew.ctog.parser.api.model.CodeProgram
import me.madopew.ctog.parser.api.model.CodeStatement
import me.madopew.ctog.parser.api.model.CodeSwitchSelection
import me.madopew.ctog.parser.api.model.ExpressionType
import me.madopew.ctog.parser.api.model.IterationType

class GraphBuilder(
    private val config: GraphConfiguration = GraphConfiguration.DEFAULT
) {
    fun build(program: CodeProgram): List<Graph> {
        val functionNames = program.functions.map { it.name }
        val isLocal = { name: String ->
            functionNames.any { it == name }
        }

        return program.functions.map { BuildGraphVisitor(config, isLocal).build(it) }
    }

    private class BuildGraphVisitor(
        val config: GraphConfiguration,
        val isLocal: (String) -> Boolean
    ) {
        var cycleDepth = 1
        val nodes = mutableListOf<GraphNode>()
        val edges = mutableMapOf<Int, MutableMap<Int, String?>>()
        var functionContext: GraphNode? = null
        val breakContext: ArrayDeque<GraphNode> = ArrayDeque()
        val continueContext: ArrayDeque<GraphNode> = ArrayDeque()

        fun build(function: CodeFunction): Graph {
            visitCodeFunction(function)
            return Graph(nodes, edges)
        }

        fun addEdge(from: GraphNode, to: GraphNode, label: String?) {
            if (!edges.containsKey(from.id)) edges[from.id] = mutableMapOf()
            edges[from.id]!![to.id] = label
        }

        fun visitCodeFunction(function: CodeFunction) {
            val startNode = GraphNode(type = NodeType.START_END, text = function.definition)
            val endNode = GraphNode(type = NodeType.START_END, text = config.endKeyword)

            functionContext = endNode
            nodes.add(startNode)
            addEdge(startNode, visitStatements(function.statements, endNode), null)
            nodes.add(endNode)
        }

        fun visitStatements(statements: List<CodeStatement>, last: GraphNode): GraphNode {
            if (statements.isEmpty()) return last
            if (statements.size == 1) return visitStatement(statements.first(), last)
            return visitStatement(statements.first(), visitStatements(statements.drop(1), last))
        }

        fun visitStatement(statement: CodeStatement, last: GraphNode): GraphNode = when (statement) {
            is CodeCall -> visitCodeCall(statement, last)
            is CodeExpression -> visitCodeExpression(statement, last)
            is CodeIfSelection -> visitCodeIfSelection(statement, last)
            is CodeIteration -> visitCodeIteration(statement, last)
            is CodeSwitchSelection -> visitCodeSwitchSelection(statement, last)
            else -> throw IllegalArgumentException("Unsupported statement type: ${statement.javaClass.name}")
        }

        fun visitCodeCall(statement: CodeCall, last: GraphNode): GraphNode {
            val type = if (isLocal(statement.functionName)) NodeType.LOCAL_ACTION
            else if (config.isInputFunction(statement.functionName)) NodeType.INPUT
            else if (config.isOutputFunction(statement.functionName)) NodeType.OUTPUT
            else NodeType.ACTION

            val node = GraphNode(type = type, text = statement.toString())
            nodes.add(node)

            addEdge(node, last, null)
            return node
        }

        fun visitCodeExpression(statement: CodeExpression, last: GraphNode): GraphNode {
            val type = when (statement.type) {
                ExpressionType.DECLARATION -> NodeType.INPUT
                else -> NodeType.ACTION
            }

            val node = GraphNode(type = type, text = statement.body)
            nodes.add(node)

            when (statement.type) {
                ExpressionType.RETURN -> {
                    addEdge(node, functionContext!!, null)
                }
                ExpressionType.BREAK -> {
                    if (breakContext.isNotEmpty()) {
                        addEdge(node, breakContext.last(), null)
                    } else {
                        addEdge(node, last, null)
                    }
                }
                ExpressionType.CONTINUE -> {
                    if (continueContext.isNotEmpty()) {
                        addEdge(node, continueContext.last(), null)
                    } else {
                        addEdge(node, last, null)
                    }
                }
                else -> {
                    addEdge(node, last, null)
                }
            }

            return node
        }

        fun visitCodeIfSelection(statement: CodeIfSelection, last: GraphNode): GraphNode {
            val node = GraphNode(type = NodeType.CONDITION, text = statement.condition)
            nodes.add(node)

            addEdge(node, visitStatements(statement.ifBody, last), config.trueKeyword)
            addEdge(node, visitStatements(statement.elseBody, last), config.falseKeyword)
            return node
        }

        fun visitCodeIteration(statement: CodeIteration, last: GraphNode): GraphNode {
            val depthText = "${config.depthKeyword}${cycleDepth++}"

            val startNode = if (statement.type == IterationType.PRE_CONDITION) {
                GraphNode(type = NodeType.CYCLE_START, text = "$depthText\n${statement.condition}")
            } else {
                GraphNode(type = NodeType.CYCLE_START, text = depthText)
            }

            val endNode = if (statement.type == IterationType.PRE_CONDITION) {
                GraphNode(type = NodeType.CYCLE_END, text = depthText)
            } else {
                GraphNode(type = NodeType.CYCLE_END, text = "$depthText\n${statement.condition}")
            }

            breakContext.addLast(last)
            continueContext.addLast(endNode)

            nodes.add(startNode)

            addEdge(startNode, visitStatements(statement.body, endNode), null)
            addEdge(endNode, last, null)
            cycleDepth--

            nodes.add(endNode)

            breakContext.removeLast()
            continueContext.removeLast()

            return startNode
        }

        fun visitCodeSwitchSelection(statement: CodeSwitchSelection, last: GraphNode): GraphNode {
            val startNode = GraphNode(type = NodeType.CONDITION, text = statement.condition)
            nodes.add(startNode)

            statement.cases.forEach { (case, body) ->
                addEdge(startNode, visitStatements(body, last), case)
            }
            return startNode
        }
    }
}
