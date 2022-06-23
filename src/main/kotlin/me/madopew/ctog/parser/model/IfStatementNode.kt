package me.madopew.ctog.parser.model

internal class IfStatementNode : SelectionStatementNode() {
    var ifBody: StatementNode? = null
    var elseBody: StatementNode? = null
}