package me.madopew.ctog.parser.api.model

data class CodeIfSelection(
    val condition: String,
    val ifBody: List<CodeStatement>,
    val elseBody: List<CodeStatement>
) : CodeStatement
