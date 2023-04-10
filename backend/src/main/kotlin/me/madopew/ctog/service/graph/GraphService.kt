package me.madopew.ctog.service.graph

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import me.madopew.ctog.exception.ParserException
import me.madopew.ctog.graph.impl.GraphBuilder
import me.madopew.ctog.model.graph.Graph
import me.madopew.ctog.model.graph.GraphRequest
import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.api.impl.BuildCodeVisitor
import me.madopew.ctog.parser.ast.impl.BuildAstVisitor
import me.madopew.ctog.repository.GraphRepository
import me.madopew.ctog.service.model.UserService
import org.antlr.v4.runtime.*
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class GraphService(
        private val userService: UserService,
        private val graphRepository: GraphRepository
) {
    fun build(user: UserDetails, input: String?): List<Graph> {
        val userInfo = userService.findByUsername(user.username)
        val result = build(input)
        val request = GraphRequest().apply {
            this.input = input ?: ""
            this.output = jacksonObjectMapper().writeValueAsString(result)
            this.userInfo = userInfo
        }
        userInfo.requests.add(request)
        userService.save(userInfo)
        return result
    }

    fun filter(user: UserDetails, pageRequest: Pageable): Page<GraphRequest> {
        val userInfo = userService.findByUsername(user.username)
        return graphRepository.findAllByUserInfo(userInfo, pageRequest)
    }

    private fun build(input: String?): List<Graph> {
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
