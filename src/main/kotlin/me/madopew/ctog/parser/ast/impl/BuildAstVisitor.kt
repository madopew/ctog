package me.madopew.ctog.parser.ast.impl

import me.madopew.ctog.parser.CBaseVisitor
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.ast.model.CNode
import me.madopew.ctog.parser.ast.model.CompoundStatementNode
import me.madopew.ctog.parser.ast.model.DeclarationStatementNode
import me.madopew.ctog.parser.ast.model.ExpressionStatementNode
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
import me.madopew.ctog.parser.ast.model.SelectionStatementNode
import me.madopew.ctog.parser.ast.model.StatementNode
import me.madopew.ctog.parser.ast.model.SwitchStatementNode
import org.antlr.v4.runtime.ParserRuleContext
import org.antlr.v4.runtime.tree.TerminalNode

internal class BuildAstVisitor(
    private val tokens: List<String>
) : CBaseVisitor<CNode?>() {
    override fun visitCompilationUnit(ctx: CParser.CompilationUnitContext): ProgramNode {
        return if (ctx.translationUnit() != null) {
            visitTranslationUnit(ctx.translationUnit())
        } else {
            ProgramNode()
        }
    }

    override fun visitTranslationUnit(ctx: CParser.TranslationUnitContext): ProgramNode {
        return ProgramNode().apply {
            functions = ctx.externalDeclaration()
                .mapNotNull { visitExternalDeclaration(it) }
                .map { it as FunctionNode }
                .toMutableList()
        }
    }

    override fun visitExternalDeclaration(ctx: CParser.ExternalDeclarationContext): CNode? {
        return if (ctx.functionDefinition() != null) {
            visitFunctionDefinition(ctx.functionDefinition())
        } else {
            null
        }
    }

    override fun visitFunctionDefinition(ctx: CParser.FunctionDefinitionContext): CNode {
        val functionName = buildList {
            if (ctx.declarationSpecifiers() != null) add(ctx.declarationSpecifiers().fullText)
            add(ctx.declarator().fullText)
        }.joinToString(" ")

        return FunctionNode().apply {
            name = functionName
            body = visitCompoundStatement(ctx.compoundStatement())
        }
    }

    override fun visitCompoundStatement(ctx: CParser.CompoundStatementContext): CompoundStatementNode {
        return if (ctx.blockItemList() != null) {
            visitBlockItemList(ctx.blockItemList())
        } else {
            CompoundStatementNode()
        }
    }

    override fun visitBlockItemList(ctx: CParser.BlockItemListContext): CompoundStatementNode {
        return CompoundStatementNode().apply {
            statements = ctx.blockItem()
                .mapNotNull { visitBlockItem(it) }
                .toMutableList()
        }
    }

    override fun visitBlockItem(ctx: CParser.BlockItemContext): StatementNode {
        return super.visitBlockItem(ctx) as StatementNode
    }

    override fun visitStatement(ctx: CParser.StatementContext): StatementNode {
        return super.visitStatement(ctx) as StatementNode
    }

    override fun visitDeclaration(ctx: CParser.DeclarationContext): DeclarationStatementNode {
        return DeclarationStatementNode().apply {
            name = ctx.fullText
        }
    }

    override fun visitLabeledStatement(ctx: CParser.LabeledStatementContext): LabeledStatementNode {
        return LabeledStatementNode().apply {
            body = visitStatement(ctx.statement())
            if (ctx.Identifier() != null) {
                type = LabeledStatementNodeType.IDENTIFIER
                label = ctx.Identifier().text
            } else if (ctx.Case() != null) {
                type = LabeledStatementNodeType.CASE
                label = ctx.constantExpression().fullText
            } else if (ctx.Default() != null) {
                type = LabeledStatementNodeType.DEFAULT
            }
        }
    }

    override fun visitSelectionStatement(ctx: CParser.SelectionStatementContext): SelectionStatementNode {
        return if (ctx.If() != null) {
            IfStatementNode().apply {
                condition = ctx.expression().fullText
                ifBody = visitStatement(ctx.statement(0))
                if (ctx.statement(1) != null) elseBody = visitStatement(ctx.statement(1))
            }
        } else {
            SwitchStatementNode().apply {
                condition = ctx.expression().fullText
                body = visitStatement(ctx.statement(0))
            }
        }
    }

    override fun visitIterationStatement(ctx: CParser.IterationStatementContext): IterationStatementNode {
        val iterationType = if (ctx.Do() != null) IterationStatementNodeType.DO_WHILE
        else if (ctx.For() != null) IterationStatementNodeType.FOR
        else IterationStatementNodeType.WHILE

        return IterationStatementNode().apply {
            type = iterationType
            condition = if (ctx.forCondition() != null) ctx.forCondition().fullText else ctx.expression().fullText
            body = visitStatement(ctx.statement())
        }
    }

    override fun visitJumpStatement(ctx: CParser.JumpStatementContext): JumpStatementNode {
        return JumpStatementNode().apply {
            if (ctx.Goto() != null) {
                type = JumpStatementNodeType.GOTO
                label = if (ctx.Identifier() != null) ctx.Identifier().text else ctx.unaryExpression().fullText
            } else if (ctx.Continue() != null) {
                type = JumpStatementNodeType.CONTINUE
            } else if (ctx.Break() != null) {
                type = JumpStatementNodeType.BREAK
            } else {
                type = JumpStatementNodeType.RETURN
                if (ctx.expression() != null) label = ctx.expression().fullText
            }
        }
    }

    override fun visitExpressionStatement(ctx: CParser.ExpressionStatementContext): ExpressionStatementNode {
        return if (ctx.expression() == null) {
            NoOpStatementNode()
        } else {
            visitExpression(ctx.expression())
        }
    }

    override fun visitExpression(ctx: CParser.ExpressionContext): ExpressionStatementNode {
        return if (ctx.assignmentExpression().size > 1) {
            OtherExpressionStatementNode().apply {
                body = ctx.fullText
            }
        } else {
            visitAssignmentExpression(ctx.assignmentExpression(0))
        }
    }

    override fun visitAssignmentExpression(ctx: CParser.AssignmentExpressionContext): ExpressionStatementNode {
        return if (ctx.conditionalExpression() != null) {
            visitConditionalExpression(ctx.conditionalExpression()) as FunctionCallStatementNode?
                ?: OtherExpressionStatementNode().apply {
                    body = ctx.fullText
                }
        } else {
            OtherExpressionStatementNode().apply {
                body = ctx.fullText
            }
        }
    }

    override fun visitPostfixExpression(ctx: CParser.PostfixExpressionContext): FunctionCallStatementNode? {
        val isFunctionCall = ctx.children.filterIsInstance<TerminalNode>().singleOrNull { it.text == "(" } != null
        return if (isFunctionCall) {
            FunctionCallStatementNode().apply {
                name = ctx.primaryExpression().fullText
                if (ctx.argumentExpressionList(0) != null) arguments = ctx.argumentExpressionList(0).fullText
            }
        } else {
            null
        }
    }

    private val ParserRuleContext.fullText: String
        get() = tokens.subList(start.tokenIndex, stop.tokenIndex + 1).joinToString(" ")
}