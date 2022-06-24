package me.madopew.ctog.parser.api.impl

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
import me.madopew.ctog.parser.ast.model.CompoundStatementNode
import me.madopew.ctog.parser.ast.model.DeclarationStatementNode
import me.madopew.ctog.parser.ast.model.FunctionCallStatementNode
import me.madopew.ctog.parser.ast.model.FunctionNode
import me.madopew.ctog.parser.ast.model.IfStatementNode
import me.madopew.ctog.parser.ast.model.IterationStatementNode
import me.madopew.ctog.parser.ast.model.IterationStatementNodeType
import me.madopew.ctog.parser.ast.model.JumpStatementNode
import me.madopew.ctog.parser.ast.model.JumpStatementNodeType
import me.madopew.ctog.parser.ast.model.LabeledStatementNode
import me.madopew.ctog.parser.ast.model.LabeledStatementNodeType
import me.madopew.ctog.parser.ast.model.NoOpStatementNode
import me.madopew.ctog.parser.ast.model.OtherExpressionStatementNode
import me.madopew.ctog.parser.ast.model.ProgramNode
import me.madopew.ctog.parser.ast.model.StatementNode
import me.madopew.ctog.parser.ast.model.SwitchStatementNode

internal class BuildCodeVisitor {
    fun visitProgramNode(node: ProgramNode): CodeProgram {
        return CodeProgram(
            node.functions.map { visitFunctionNode(it) }
        )
    }

    private fun visitFunctionNode(node: FunctionNode): CodeFunction {
        return CodeFunction(
            node.name!!,
            node.body!!.statements.flatMap { visitStatementNode(it) }
        )
    }

    private fun visitStatementNode(node: StatementNode): List<CodeStatement> {
        return when (node) {
            is CompoundStatementNode -> node.statements.flatMap { visitStatementNode(it) }
            is DeclarationStatementNode -> listOf(CodeExpression(ExpressionType.DECLARATION, node.name!!))
            is FunctionCallStatementNode -> listOf(CodeCall(node.name!!, node.arguments ?: ""))
            is IfStatementNode -> listOf(
                CodeIfSelection(
                    node.condition!!,
                    visitStatementNode(node.ifBody!!),
                    if (node.elseBody != null) visitStatementNode(node.elseBody!!) else listOf()
                )
            )
            is IterationStatementNode -> listOf(
                CodeIteration(
                    node.type!!.toIterationType(),
                    node.condition!!,
                    visitStatementNode(node.body!!)
                )
            )
            is JumpStatementNode -> listOf(
                CodeExpression(
                    if (node.type == JumpStatementNodeType.RETURN) ExpressionType.RETURN else ExpressionType.OTHER,
                    node.toReadableString()
                )
            )
            is LabeledStatementNode
            -> listOf()
            is NoOpStatementNode -> listOf()
            is OtherExpressionStatementNode -> listOf(CodeExpression(ExpressionType.OTHER, node.body!!))
            is SwitchStatementNode -> {
                val body = node.body!!
                val switchStatements = if (body is CompoundStatementNode) body.statements else listOf(body)
                val cases = mutableMapOf<String, List<CodeStatement>>()

                var currentLabel: String? = null
                val statementList = mutableListOf<CodeStatement>()
                for (statement in switchStatements) {
                    when (statement) {
                        is LabeledStatementNode -> {
                            if (statement.type == LabeledStatementNodeType.CASE) {
                                if (statement.body is LabeledStatementNode) throw IllegalStateException("Case fallthrough is not supported")
                                currentLabel = statement.label!!
                                statementList.addAll(visitStatementNode(statement.body!!))
                            }
                        }
                        is JumpStatementNode -> {
                            if (currentLabel != null) {
                                if (cases.containsKey(currentLabel)) throw IllegalStateException("Ambiguous case label")
                                cases[currentLabel] = statementList.toList()
                                currentLabel = null
                                statementList.clear()
                            }
                        }
                        else -> statementList.addAll(visitStatementNode(statement))
                    }
                }

                listOf(CodeSwitchSelection(node.condition!!, cases))
            }
            else -> throw IllegalArgumentException("Cannot visit $node")
        }
    }

    private fun JumpStatementNode.toReadableString(): String {
        return if (label != null) "$type $label" else type.toString()
    }

    private fun IterationStatementNodeType.toIterationType(): IterationType = when (this) {
        IterationStatementNodeType.FOR -> IterationType.PRE_CONDITION
        IterationStatementNodeType.WHILE -> IterationType.PRE_CONDITION
        IterationStatementNodeType.DO_WHILE -> IterationType.POST_CONDITION
    }
}