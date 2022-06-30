package me.madopew.ctog

import me.madopew.ctog.graph.impl.GraphBuilder
import me.madopew.ctog.parser.CLexer
import me.madopew.ctog.parser.CParser
import me.madopew.ctog.parser.api.impl.BuildCodeVisitor
import me.madopew.ctog.parser.ast.impl.BuildAstVisitor
import me.madopew.ctog.parser.ast.model.ProgramNode
import org.antlr.v4.runtime.CharStreams
import org.antlr.v4.runtime.CommonTokenStream

//@SpringBootApplication
//class CtogApplication

// current version of the program
// doesn't support jump statements
// other than break in switch
fun main() {
    val input = """
        int main() {
            switch (x) {
                case 0:
                    write(0);
                    read();
                    break;
                default:
                    write(1);
                    break;
            }
        }
    """

    val lexer = CLexer(CharStreams.fromString(input))
    val tokens = lexer.allTokens.map { it.text }
    lexer.reset()
    val parser = CParser(CommonTokenStream(lexer))
    val tree = parser.compilationUnit()
    val astVisitor = BuildAstVisitor(tokens)
    val programNode = astVisitor.visitCompilationUnit(tree)
    val codeVisitor = BuildCodeVisitor()
    val codeProgram = codeVisitor.visitProgramNode(programNode)
    val builder = GraphBuilder()
    val graphs = builder.build(codeProgram)
    println(graphs)
//    runApplication<CtogApplication>(*args)
}
