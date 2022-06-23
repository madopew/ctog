package me.madopew.ctog

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.api.impl.BuildCodeVisitor
import me.madopew.ctog.parser.ast.impl.BuildAstVisitor
import me.madopew.ctog.parser.ast.model.ProgramNode
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream

//@SpringBootApplication
//class CtogApplication

fun main() {
    val input = """
        int main() {
            int x = init();
            int temp = 0;
            while (x > 0) {
                temp = get(x);
                if (temp) {
                    puts("Hello");
                }
                x--;
            }
            
            switch (temp) {
                case 0:
                    puts("World");
                    break;
                case 1:
                    puts("you should not see this");
                    break;
            }
            
            return 0;
        }
    """

    val lexer = CLexer(CharStreams.fromString(input))
    val tokens = lexer.allTokens.map { it.text }
    lexer.reset()
    val parser = CParser(CommonTokenStream(lexer))
    val tree = parser.compilationUnit()
    val astVisitor = BuildAstVisitor(tokens)
    val programNode = astVisitor.visitCompilationUnit(tree) as ProgramNode
    val codeVisitor = BuildCodeVisitor()
    val codeProgram = codeVisitor.visitProgramNode(programNode)
    println(jacksonObjectMapper().writeValueAsString(codeProgram))
//    runApplication<CtogApplication>(*args)
}
