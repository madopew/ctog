package me.madopew.ctog.parser.model

internal class FunctionNode: CNode() {
    var name: String? = null
    var body: CompoundStatementNode? = null
}