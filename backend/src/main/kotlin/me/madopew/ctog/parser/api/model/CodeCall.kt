package me.madopew.ctog.parser.api.model

data class CodeCall(
    val functionName: String,
    val argumentList: String
) : CodeStatement {
    override fun toString(): String {
        return "$functionName($argumentList)"
    }
}