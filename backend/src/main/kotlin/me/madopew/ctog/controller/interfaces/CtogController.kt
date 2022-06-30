package me.madopew.ctog.controller.interfaces

import me.madopew.ctog.graph.model.Graph

interface CtogController {
    fun getGraph(source: String): List<Graph>
}