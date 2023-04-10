package me.madopew.ctog.controller

import me.madopew.ctog.constant.API_AUTH
import me.madopew.ctog.dto.security.AuthDto
import me.madopew.ctog.dto.security.LoginResponseDto
import me.madopew.ctog.service.security.AuthService
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@RestController
@RequestMapping(API_AUTH)
class AuthController(
        private val authService: AuthService
) {
    @PostMapping("/login")
    fun login(@Valid @RequestBody request: AuthDto): LoginResponseDto {
        return authService.login(request)
    }

    @GetMapping("/me")
    fun me() {
    }
}
