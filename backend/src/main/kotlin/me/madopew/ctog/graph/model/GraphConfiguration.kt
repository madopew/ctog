package me.madopew.ctog.graph.model

data class GraphConfiguration(
    val endKeyword: String,
    val trueKeyword: String,
    val falseKeyword: String,
    val depthKeyword: String,
    val inputFunctions: List<String>,
    val outputFunctions: List<String>
) {
    fun isInputFunction(function: String) = inputFunctions.contains(function)
    fun isOutputFunction(function: String) = outputFunctions.contains(function)

    companion object {
        val DEFAULT = GraphConfiguration(
            endKeyword = "end.",
            trueKeyword = "true",
            falseKeyword = "false",
            depthKeyword = "A",
            inputFunctions = listOf("read"),
            outputFunctions = listOf("write")
        )
    }
}