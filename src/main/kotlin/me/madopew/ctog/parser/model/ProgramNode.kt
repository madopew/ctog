package me.madopew.ctog.parser.model

internal class ProgramNode: CNode() {
    var functions = mutableListOf<FunctionNode>()
}