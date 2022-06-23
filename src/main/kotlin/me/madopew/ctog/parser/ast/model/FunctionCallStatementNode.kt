package me.madopew.ctog.parser.ast.model

internal class FunctionCallStatementNode: ExpressionStatementNode() {
    var name: String? = null
    var arguments: String? = null
}