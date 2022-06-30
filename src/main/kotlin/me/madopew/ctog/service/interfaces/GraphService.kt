package me.madopew.ctog.service.interfaces

import me.madopew.ctog.graph.model.Graph

interface GraphService {
    fun build(input: String): List<Graph>
}