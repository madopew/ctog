package me.madopew.ctog.config

import me.madopew.ctog.exception.ValidationException
import me.madopew.ctog.extension.handleException
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import javax.servlet.http.HttpServletResponse

@ControllerAdvice
class RestExceptionConfig {
    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handlerExceptionResolver(ex: MethodArgumentNotValidException, response: HttpServletResponse) {
        response.handleException(ValidationException(ex))
    }
}
