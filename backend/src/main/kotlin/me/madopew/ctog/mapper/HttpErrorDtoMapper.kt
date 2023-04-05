package me.madopew.ctog.mapper

import me.madopew.ctog.dto.util.HttpErrorDto
import me.madopew.ctog.exception.CtogException

fun CtogException.toHttpError() = HttpErrorDto(this.message, this.httpCode)
