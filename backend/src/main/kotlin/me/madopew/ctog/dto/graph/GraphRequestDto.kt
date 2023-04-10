package me.madopew.ctog.dto.graph

import java.time.Instant

data class GraphRequestDto(
        val ts: Instant,
        val input: String,
        val output: List<GraphDto>
)
