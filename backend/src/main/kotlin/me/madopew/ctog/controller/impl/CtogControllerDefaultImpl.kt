package me.madopew.ctog.controller.impl

import me.madopew.ctog.controller.interfaces.CtogController
import me.madopew.ctog.dto.GraphDto
import me.madopew.ctog.mapper.toDto
import me.madopew.ctog.service.interfaces.GraphService
import org.springframework.context.annotation.Profile
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.HttpClientErrorException.BadRequest
import org.springframework.web.server.ResponseStatusException

@RestController
@RequestMapping("/api/v1/graph")
class CtogControllerDefaultImpl(
    private val graphService: GraphService
) : CtogController {
    @PostMapping("/")
    @CrossOrigin(origins = ["http://localhost:3000"])
    override fun getGraph(@RequestBody(required = false) source: String?): List<GraphDto> {
        return graphService.build(source).map { it.toDto() }
    }
}