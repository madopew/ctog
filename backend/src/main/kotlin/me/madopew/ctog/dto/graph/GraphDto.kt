package me.madopew.ctog.dto.graph

data class GraphDto(
    val nodes: List<GraphNodeDto>,
    val edges: Map<Int, Map<Int, String?>>
)
