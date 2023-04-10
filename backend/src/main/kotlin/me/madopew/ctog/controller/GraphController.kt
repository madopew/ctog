package me.madopew.ctog.controller

import me.madopew.ctog.constant.API_GRAPH
import me.madopew.ctog.dto.graph.GraphDto
import me.madopew.ctog.dto.graph.GraphRequestDto
import me.madopew.ctog.mapper.toDto
import me.madopew.ctog.model.graph.GraphRequest
import me.madopew.ctog.service.graph.GraphService
import org.springframework.boot.autoconfigure.data.web.SpringDataWebProperties
import org.springframework.data.domain.Page
import org.springframework.data.domain.PageRequest
import org.springframework.data.domain.Pageable
import org.springframework.data.web.PageableDefault
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(API_GRAPH)
class GraphController(
        private val graphService: GraphService
) {
    @PostMapping
    fun getGraph(@RequestBody(required = false) source: String?): List<GraphDto> {
        val user = SecurityContextHolder.getContext().authentication.principal as UserDetails
        return graphService.build(user, source).map { it.toDto() }
    }

    @PostMapping("/filter")
    fun filterRequests(@PageableDefault pageRequest: Pageable): Page<GraphRequestDto> {
        val user = SecurityContextHolder.getContext().authentication.principal as UserDetails
        return graphService.filter(user, pageRequest).map { it.toDto() }
    }
}
