package me.madopew.ctog.parser.api.impl

import me.madopew.ctog.parser.api.model.*
import me.madopew.ctog.parser.ast.model.*

internal class BuildCodeVisitor {
    fun visitProgramNode(node: ProgramNode): CodeProgram {
        return CodeProgram(
            functions = node.functions.map { visitFunctionNode(it) }
        )
    }

    private fun visitFunctionNode(node: FunctionNode): CodeFunction {
        return CodeFunction(
            name = node.name!!,
            definition = node.definition!!,
            statements = node.body!!.statements.flatMap { visitStatementNode(it) }
        )
    }

    private fun visitStatementNode(node: StatementNode): List<CodeStatement> = when (node) {
        is CompoundStatementNode -> node.statements.flatMap { visitStatementNode(it) }
        is DeclarationStatementNode -> listOf(visitDeclarationStatementNode(node))
        is FunctionCallStatementNode -> listOf(visitFunctionCallStatementNode(node))
        is IfStatementNode -> listOf(visitIfStatementNode(node))
        is IterationStatementNode -> listOf(visitIterationStatementNode(node))
        is JumpStatementNode -> listOf(visitJumpStatementNode(node))
        is LabeledStatementNode -> listOf()
        is NoOpStatementNode -> listOf()
        is OtherExpressionStatementNode -> listOf(visitOtherExpressionStatementNode(node))
        is SwitchStatementNode -> listOf(visitSwitchStatementNode(node))
        else -> throw IllegalArgumentException("Cannot visit $node")
    }

    private fun visitDeclarationStatementNode(node: DeclarationStatementNode) =
        CodeExpression(ExpressionType.DECLARATION, node.name!!)

    private fun visitFunctionCallStatementNode(node: FunctionCallStatementNode) =
        CodeCall(node.name!!, node.arguments ?: "")

    private fun visitIfStatementNode(node: IfStatementNode) =
        CodeIfSelection(
            node.condition!!,
            visitStatementNode(node.ifBody!!),
            if (node.elseBody != null) visitStatementNode(node.elseBody!!) else listOf()
        )

    private fun visitIterationStatementNode(node: IterationStatementNode): CodeIteration {
        val type = when (node.type!!) {
            IterationStatementNodeType.FOR -> IterationType.PRE_CONDITION
            IterationStatementNodeType.WHILE -> IterationType.PRE_CONDITION
            IterationStatementNodeType.DO_WHILE -> IterationType.POST_CONDITION
        }

        return CodeIteration(type, node.condition!!, visitStatementNode(node.body!!))
    }

    private fun visitJumpStatementNode(node: JumpStatementNode) =
        CodeExpression(
            when (node.type) {
                JumpStatementNodeType.RETURN -> ExpressionType.RETURN
                JumpStatementNodeType.BREAK -> ExpressionType.BREAK
                JumpStatementNodeType.CONTINUE -> ExpressionType.CONTINUE
                else -> ExpressionType.OTHER
            },
            node.toReadableString()
        )

    private fun visitOtherExpressionStatementNode(node: OtherExpressionStatementNode) =
        CodeExpression(type = ExpressionType.OTHER, body = node.body!!)

    private fun visitSwitchStatementNode(node: SwitchStatementNode) =
        CodeSwitchSelection(
            node.condition!!,
            node.body.associate { labeledStatement ->
                val label = labeledStatement.label ?: "default"
                val statements = labeledStatement.body!!.statements.flatMap { visitStatementNode(it) }
                label to statements
            }
        )

    private fun JumpStatementNode.toReadableString(): String {
        return if (label != null) "$type $label" else type.toString()
    }
}
