package me.madopew.ctog.model.graph

data class Graph(
        val nodes: List<GraphNode>,
        val edges: Map<Int, Map<Int, String?>>
)
