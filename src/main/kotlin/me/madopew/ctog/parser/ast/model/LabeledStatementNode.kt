package me.madopew.ctog.parser.ast.model

internal class LabeledStatementNode: StatementNode() {
    var type: LabeledStatementNodeType? = null
    var label: String? = null
    var body: StatementNode? = null
}