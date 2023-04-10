package me.madopew.ctog.mapper

import com.fasterxml.jackson.core.type.TypeReference
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import me.madopew.ctog.dto.graph.GraphDto
import me.madopew.ctog.dto.graph.GraphNodeDto
import me.madopew.ctog.dto.graph.GraphRequestDto
import me.madopew.ctog.model.graph.Graph
import me.madopew.ctog.model.graph.GraphNode
import me.madopew.ctog.model.graph.GraphRequest

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

fun GraphRequest.toDto() = GraphRequestDto(
        ts,
        input,
        jacksonObjectMapper().readValue(output, object : TypeReference<List<Graph>>() {}).map { it.toDto() }
)
