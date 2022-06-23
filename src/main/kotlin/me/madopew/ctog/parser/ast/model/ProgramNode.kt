package me.madopew.ctog.parser.ast.model

internal class ProgramNode: CNode() {
    var functions = mutableListOf<FunctionNode>()
}