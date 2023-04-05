package me.madopew.ctog.service.graph

import me.madopew.ctog.exception.ParserException
import me.madopew.ctog.graph.impl.GraphBuilder
import me.madopew.ctog.graph.model.Graph
import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.api.impl.BuildCodeVisitor
import me.madopew.ctog.parser.ast.impl.BuildAstVisitor
import org.antlr.v4.runtime.BaseErrorListener
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.antlr.v4.runtime.RecognitionException
import org.antlr.v4.runtime.Recognizer
import org.springframework.stereotype.Service

@Service
class GraphService {
    fun build(input: String?): List<Graph> {
        if (input == null) return emptyList()
        val lexer = CLexer(CharStreams.fromString(input))
        val tokens = lexer.allTokens.map { it.text }
        lexer.reset()
        val parser = CParser(CommonTokenStream(lexer)).apply {
            addErrorListener(object : BaseErrorListener() {
                override fun syntaxError(
                    recognizer: Recognizer<*, *>?,
                    offendingSymbol: Any?,
                    line: Int,
                    charPositionInLine: Int,
                    msg: String?,
                    e: RecognitionException?
                ) {
                    throw ParserException("Syntax error at line $line position $charPositionInLine")
                }
            })
        }
        val tree = parser.compilationUnit()
        val astVisitor = BuildAstVisitor(tokens)
        val programNode = astVisitor.visitCompilationUnit(tree)
        val codeVisitor = BuildCodeVisitor()
        val codeProgram = codeVisitor.visitProgramNode(programNode)
        val graphBuilder = GraphBuilder()
        return graphBuilder.build(codeProgram)
    }
}
