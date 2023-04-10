package me.madopew.ctog.dto.graph

import me.madopew.ctog.model.graph.NodeType

data class GraphNodeDto(
        val type: NodeType,
        val text: String
)
