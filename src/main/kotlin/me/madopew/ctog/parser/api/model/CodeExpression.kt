package me.madopew.ctog.parser.api.model

data class CodeExpression(
    val type: ExpressionType,
    val body: String
) : CodeStatement
