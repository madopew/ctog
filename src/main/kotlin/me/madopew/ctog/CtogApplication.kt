package me.madopew.ctog

import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.CParserVisitor
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream

//@SpringBootApplication
//class CtogApplication

fun main() {
    val input = "inline int main(int hello, char* world) { return 0; return 0; }"
    val lexer = CLexer(CharStreams.fromString(input))
    val tokens = lexer.allTokens.map { it.text }
    lexer.reset()
    val parser = CParser(CommonTokenStream(lexer))
    val tree = parser.compilationUnit()
    val visitor = CParserVisitor(tokens)
    visitor.visitCompilationUnit(tree)
    val program = visitor.program
    println(program)
//    runApplication<CtogApplication>(*args)
}
