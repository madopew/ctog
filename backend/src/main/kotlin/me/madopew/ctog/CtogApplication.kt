package me.madopew.ctog

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class CtogApplication

fun main(args: Array<String>) {
    runApplication<CtogApplication>(*args)
}
