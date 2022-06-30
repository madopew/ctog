package me.madopew.ctog.parser.api.model

data class CodeFunction(
    val definition: String,
    val statements: List<CodeStatement>
)
