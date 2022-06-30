package me.madopew.ctog.graph.model

import kotlin.random.Random

data class GraphNode(
    val id: Long = Random.nextLong(),
    val type: NodeType,
    val text: String
)
