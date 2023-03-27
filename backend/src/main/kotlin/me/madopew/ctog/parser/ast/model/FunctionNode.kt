package me.madopew.ctog.parser.ast.model

internal class FunctionNode: CNode() {
    var name: String? = null
    var definition: String? = null
    var body: CompoundStatementNode? = null
}
