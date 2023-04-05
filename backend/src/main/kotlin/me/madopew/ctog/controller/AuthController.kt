package me.madopew.ctog.controller

import me.madopew.ctog.constant.API_AUTH
import me.madopew.ctog.dto.auth.AuthDto
import me.madopew.ctog.dto.auth.RegisterDto
import me.madopew.ctog.service.security.AuthService
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import javax.validation.Valid

@RestController
@RequestMapping(API_AUTH)
class AuthController(
    private val authService: AuthService
) {
    @PostMapping("/register")
    fun register(@Valid @RequestBody request: RegisterDto): String {
        return authService.register(request)
    }

    @PostMapping("/login")
    fun login(@RequestBody request: AuthDto): String {
        return authService.login(request)
    }
}
