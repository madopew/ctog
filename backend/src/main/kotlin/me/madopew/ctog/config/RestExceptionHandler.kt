package me.madopew.ctog.config

import me.madopew.ctog.dto.HttpErrorDto
import me.madopew.ctog.exception.CtogException
import me.madopew.ctog.mapper.toHttpError
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler

@RestControllerAdvice
class RestExceptionHandler : ResponseEntityExceptionHandler() {
    @ExceptionHandler(CtogException::class)
    fun handleBusinessException(exception: CtogException): ResponseEntity<HttpErrorDto> {
        val error = exception.toHttpError()
        return ResponseEntity(error, error.httpStatus)
    }
}
