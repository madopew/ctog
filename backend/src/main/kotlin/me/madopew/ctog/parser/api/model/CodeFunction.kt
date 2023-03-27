package me.madopew.ctog.parser.api.model

data class CodeFunction(
    val name: String,
    val definition: String,
    val statements: List<CodeStatement>
)
