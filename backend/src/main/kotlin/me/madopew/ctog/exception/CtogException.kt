package me.madopew.ctog.exception

open class CtogException(
    override val message: String,
    val httpCode: Int
): Exception()

