package me.madopew.ctog.controller.impl

import me.madopew.ctog.controller.interfaces.CtogController
import me.madopew.ctog.dto.GraphDto
import me.madopew.ctog.dto.HttpErrorDto
import me.madopew.ctog.exception.CtogException
import me.madopew.ctog.mapper.toDto
import me.madopew.ctog.mapper.toHttpError
import me.madopew.ctog.service.interfaces.GraphService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/v1/graph")
class CtogControllerDefaultImpl(
    private val graphService: GraphService
) : CtogController {
    @PostMapping
    @CrossOrigin(origins = ["http://localhost:4200"])
    override fun getGraph(@RequestBody(required = false) source: String?): List<GraphDto> {
        return graphService.build(source).map { it.toDto() }
    }

    @ExceptionHandler(CtogException::class)
    fun handleBusinessException(exception: CtogException): ResponseEntity<HttpErrorDto> {
        val error = exception.toHttpError()
        return ResponseEntity(error, error.httpStatus)
    }
}
