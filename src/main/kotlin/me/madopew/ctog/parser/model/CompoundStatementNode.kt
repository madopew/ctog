package me.madopew.ctog.parser.model

internal class CompoundStatementNode: StatementNode() {
    var statements = mutableListOf<StatementNode>()
}
