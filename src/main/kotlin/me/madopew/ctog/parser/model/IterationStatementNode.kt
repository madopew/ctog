package me.madopew.ctog.parser.model

internal class IterationStatementNode: StatementNode() {
    var type: IterationStatementNodeType? = null
    var condition: String? = null
    var body: StatementNode? = null
}