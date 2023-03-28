package me.madopew.ctog.controller

import me.madopew.ctog.dto.GraphDto
import me.madopew.ctog.mapper.toDto
import me.madopew.ctog.service.GraphService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/graph")
class GraphController(
    private val graphService: GraphService
) {
    @PostMapping
    fun getGraph(@RequestBody(required = false) source: String?): List<GraphDto> {
        return graphService.build(source).map { it.toDto() }
    }
}
