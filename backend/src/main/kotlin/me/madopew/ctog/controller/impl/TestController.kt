package me.madopew.ctog.controller.impl

import me.madopew.ctog.controller.interfaces.CtogController
import me.madopew.ctog.graph.model.Graph
import me.madopew.ctog.service.interfaces.GraphService
import org.springframework.context.annotation.Profile
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/graph")
@Profile("test")
class TestController(
    private val graphService: GraphService
) : CtogController {
    @GetMapping("/")
    override fun getGraph(@RequestBody source: String): List<Graph> {
        return graphService.build(source)
    }
}