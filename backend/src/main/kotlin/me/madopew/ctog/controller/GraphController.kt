package me.madopew.ctog.controller

import me.madopew.ctog.constant.API_GRAPH
import me.madopew.ctog.dto.graph.GraphDto
import me.madopew.ctog.mapper.toDto
import me.madopew.ctog.service.graph.GraphService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(API_GRAPH)
class GraphController(
    private val graphService: GraphService
) {
    @PostMapping
    fun getGraph(@RequestBody(required = false) source: String?): List<GraphDto> {
        return graphService.build(source).map { it.toDto() }
    }
}
