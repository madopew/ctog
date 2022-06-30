package me.madopew.ctog.parser.api.model

data class CodeIteration(
    val type: IterationType,
    val condition: String,
    val body: List<CodeStatement>
) : CodeStatement
