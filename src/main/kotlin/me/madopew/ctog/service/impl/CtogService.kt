package me.madopew.ctog.service.impl

import me.madopew.ctog.graph.impl.GraphBuilder
import me.madopew.ctog.graph.model.Graph
import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.api.impl.BuildCodeVisitor
import me.madopew.ctog.parser.ast.impl.BuildAstVisitor
import me.madopew.ctog.service.interfaces.GraphService
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Service

@Service
@Profile("!test")
class CtogService: GraphService {
    override fun build(input: String): List<Graph> {
        val lexer = CLexer(CharStreams.fromString(input))
        val tokens = lexer.allTokens.map { it.text }
        lexer.reset()
        val parser = CParser(CommonTokenStream(lexer))
        val tree = parser.compilationUnit()
        val astVisitor = BuildAstVisitor(tokens)
        val programNode = astVisitor.visitCompilationUnit(tree)
        val codeVisitor = BuildCodeVisitor()
        val codeProgram = codeVisitor.visitProgramNode(programNode)
        val graphBuilder = GraphBuilder()
        return graphBuilder.build(codeProgram)
    }
}