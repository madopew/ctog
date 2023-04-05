package me.madopew.ctog.service.security

import me.madopew.ctog.dto.auth.AuthDto
import me.madopew.ctog.dto.auth.RegisterDto
import me.madopew.ctog.exception.BadRequestException
import me.madopew.ctog.mapper.toDetails
import me.madopew.ctog.model.UserInfo
import me.madopew.ctog.service.model.UserService
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class AuthService(
    private val userService: UserService,
    private val jwtService: JwtService,
    private val passwordEncoder: PasswordEncoder,
    private val authenticationManager: AuthenticationManager
) {
    fun register(request: RegisterDto): String {
        if (userService.getByUsername(request.username) != null) {
            throw BadRequestException("User '${request.username}' already exists")
        }

        val user = userService.save(
            UserInfo().apply {
                username = request.username
                passwordHash = passwordEncoder.encode(request.password)
            }
        )

        return jwtService.generateToken(user.toDetails())
    }

    fun login(request: AuthDto): String {
        authenticationManager.authenticate(
            UsernamePasswordAuthenticationToken(request.username, request.password)
        )

        val user = userService.findByUsername(request.username)

        return jwtService.generateToken(user.toDetails())
    }
}
