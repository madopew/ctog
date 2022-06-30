package me.madopew.ctog.graph.model

data class Graph(
    val nodes: List<GraphNode>,
    val edges: Map<Long, Map<Long, String?>>
)
