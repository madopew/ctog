package me.madopew.ctog

import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.impl.CParserVisitor
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream

//@SpringBootApplication
//class CtogApplication

fun main() {
    val input = """
        int main() {
            get()();
            get();
            print(get());
        }
        
        void other(char* argc) {
            print(argc);
        }
    """

    val lexer = CLexer(CharStreams.fromString(input))
    val tokens = lexer.allTokens.map { it.text }
    lexer.reset()
    val parser = CParser(CommonTokenStream(lexer))
    val tree = parser.compilationUnit()
    val visitor = CParserVisitor(tokens)
    val program = visitor.visitCompilationUnit(tree)
    println(program)
//    runApplication<CtogApplication>(*args)
}
