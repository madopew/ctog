package me.madopew.ctog.parser.api.model

data class CodeSwitchSelection(
    val condition: String,
    val cases: Map<String, List<CodeStatement>>
) : CodeStatement
