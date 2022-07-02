package me.madopew.ctog.controller.interfaces

import me.madopew.ctog.dto.GraphDto

interface CtogController {
    fun getGraph(source: String?): List<GraphDto>
}