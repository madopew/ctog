package me.madopew.ctog.dto

import org.springframework.http.HttpStatus

data class HttpErrorDto(
    val message: String,
    val httpStatusCode: Int
) {
    val httpStatus = HttpStatus.valueOf(httpStatusCode)
}
