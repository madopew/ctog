package me.madopew.ctog.parser.ast.model

internal open class SelectionStatementNode: StatementNode() {
    var condition: String? = null
}