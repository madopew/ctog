package me.madopew.ctog.dto

data class GraphDto(
    val nodes: List<GraphNodeDto>,
    val edges: Map<Int, Map<Int, String?>>
)
