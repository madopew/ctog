package me.madopew.ctog.exception

import org.springframework.web.bind.MethodArgumentNotValidException

class ValidationException(ex: MethodArgumentNotValidException): CtogException(
    ex.allErrors.first().defaultMessage ?: "Provided parameters do not pass validation", 400
)
