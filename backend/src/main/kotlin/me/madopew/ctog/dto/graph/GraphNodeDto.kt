package me.madopew.ctog.dto.graph

import me.madopew.ctog.graph.model.NodeType

data class GraphNodeDto(
    val type: NodeType,
    val text: String
)
