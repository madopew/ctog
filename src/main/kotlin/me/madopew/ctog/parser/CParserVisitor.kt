package me.madopew.ctog.parser

import me.madopew.ctog.model.code.CodeFunction
import me.madopew.ctog.model.code.CodeProgram
import org.antlr.v4.runtime.ParserRuleContext
import org.slf4j.LoggerFactory

class CParserVisitor(
    private val tokens: List<String>
) : CBaseVisitor<Unit>() {
    private val logger = LoggerFactory.getLogger(CParserVisitor::class.java)

    private var _program: CodeProgram? = null
    var program: CodeProgram
        get() = _program ?: throw IllegalStateException("Program not initialized")
        private set(value) {
            _program = value
        }

    private val functions = mutableListOf<CodeFunction>()

    override fun visitCompilationUnit(ctx: CParser.CompilationUnitContext) {
        super.visitCompilationUnit(ctx)
        program = CodeProgram(functions)
    }

    override fun visitFunctionDefinition(ctx: CParser.FunctionDefinitionContext) {
        val definition = buildList {
            if (ctx.declarationSpecifiers() != null) add(ctx.declarationSpecifiers().fullText)
            add(ctx.declarator().fullText)
        }.joinToString(" ")
        functions.add(CodeFunction(definition))
        super.visitFunctionDefinition(ctx)
    }

    private val ParserRuleContext.fullText: String
        get() = tokens.subList(start.tokenIndex, stop.tokenIndex + 1).joinToString(" ")
}