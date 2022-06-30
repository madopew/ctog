package me.madopew.ctog.parser.ast.model

internal class JumpStatementNode: StatementNode() {
    var type: JumpStatementNodeType? = null
    var label: String? = null
}