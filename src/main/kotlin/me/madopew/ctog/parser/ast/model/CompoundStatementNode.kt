package me.madopew.ctog.parser.ast.model

internal class CompoundStatementNode: StatementNode() {
    var statements = mutableListOf<StatementNode>()
}
