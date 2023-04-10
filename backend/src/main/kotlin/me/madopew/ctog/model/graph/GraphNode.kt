package me.madopew.ctog.model.graph

import kotlin.random.Random

data class GraphNode(
        val id: Int = Random.nextInt(),
        val type: NodeType,
        val text: String
)
