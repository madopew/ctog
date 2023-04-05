package me.madopew.ctog.mapper

import me.madopew.ctog.dto.graph.GraphDto
import me.madopew.ctog.dto.graph.GraphNodeDto
import me.madopew.ctog.graph.model.Graph
import me.madopew.ctog.graph.model.GraphNode

fun Graph.toDto(): GraphDto {
    val nodes = this.nodes.map { it.toDto() }
    val edges = mutableMapOf<Int, MutableMap<Int, String?>>()
    this.edges.forEach { (fromId, toList) ->
        val fromNode = this.nodes.single { it.id == fromId }
        val fromIndex = this.nodes.indexOf(fromNode)
        edges[fromIndex] = mutableMapOf()
        toList.forEach { (toId, text) ->
            val toNode = this.nodes.single { it.id == toId }
            val toIndex = this.nodes.indexOf(toNode)
            edges[fromIndex]!![toIndex] = text
        }
    }
    return GraphDto(nodes, edges)
}

fun GraphNode.toDto(): GraphNodeDto =
    GraphNodeDto(this.type, this.text)
