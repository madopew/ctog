package me.madopew.ctog.extension

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import me.madopew.ctog.exception.CtogException
import me.madopew.ctog.exception.ServerException
import me.madopew.ctog.mapper.toHttpError
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType
import javax.servlet.http.HttpServletResponse

private val logger = LoggerFactory.getLogger("ServletExtension")

fun HttpServletResponse.handleException(e: Exception) {
    logger.warn("Handling response exception", e)
    if (e is CtogException) {
        this.handleBusinessException(e)
    } else {
        this.handleBusinessException(ServerException())
    }
}

private fun HttpServletResponse.handleBusinessException(e: CtogException) {
    val error = e.toHttpError()
    this.contentType = MediaType.APPLICATION_JSON_VALUE
    this.status = error.httpStatusCode
    jacksonObjectMapper().writeValue(this.outputStream, error)
    this.outputStream.flush()
}
