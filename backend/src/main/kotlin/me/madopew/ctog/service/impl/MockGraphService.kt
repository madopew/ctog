package me.madopew.ctog.service.impl

import me.madopew.ctog.graph.model.Graph
import me.madopew.ctog.graph.model.GraphNode
import me.madopew.ctog.graph.model.NodeType
import me.madopew.ctog.service.interfaces.GraphService
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Service

@Service
@Profile("test")
class MockGraphService : GraphService {
    override fun build(input: String?): List<Graph> {
        return listOf(
            Graph(
                listOf(
                    GraphNode(0, NodeType.START_END, "start"),
                    GraphNode(1, NodeType.INPUT, "int x"),
                    GraphNode(2, NodeType.CYCLE_START, "a1 for i"),
                    GraphNode(3, NodeType.ACTION, "x++"),
                    GraphNode(4, NodeType.LOCAL_ACTION, "test()"),
                    GraphNode(5, NodeType.CYCLE_END, "a1"),
                    GraphNode(6, NodeType.CONDITION, "x < 10"),
                    GraphNode(7, NodeType.OUTPUT, "see"),
                    GraphNode(8, NodeType.OUTPUT, "no see"),
                    GraphNode(9, NodeType.ACTION, "return"),
                    GraphNode(10, NodeType.START_END, "end")
                ),
                mapOf(
                    0L to (mapOf(1L to null)),
                    1L to (mapOf(2L to null)),
                    2L to (mapOf(3L to null)),
                    3L to (mapOf(4L to null)),
                    4L to (mapOf(5L to null)),
                    5L to (mapOf(6L to null)),
                    6L to (mapOf(7L to "true", 8L to "false")),
                    7L to (mapOf(9L to null)),
                    8L to (mapOf(9L to null)),
                    9L to (mapOf(10L to null))
                )
            )
        )
    }
}