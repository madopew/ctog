package me.madopew.ctog.parser.ast.model

internal class SwitchStatementNode : SelectionStatementNode() {
    var body = mutableListOf<LabeledStatementNode>()
}
