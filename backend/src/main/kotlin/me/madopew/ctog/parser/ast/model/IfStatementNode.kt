package me.madopew.ctog.parser.ast.model

internal class IfStatementNode : SelectionStatementNode() {
    var ifBody: CompoundStatementNode? = null
    var elseBody: CompoundStatementNode? = null
}
