package me.madopew.ctog.parser.model

internal open class SelectionStatementNode: StatementNode() {
    var condition: String? = null
}