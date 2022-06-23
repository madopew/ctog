package me.madopew.ctog.parser.model

internal class LabeledStatementNode: StatementNode() {
    var type: LabeledStatementNodeType? = null
    var label: String? = null
    var body: StatementNode? = null
}