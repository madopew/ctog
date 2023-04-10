package me.madopew.ctog.service.security

import me.madopew.ctog.dto.security.AuthDto
import me.madopew.ctog.dto.security.LoginResponseDto
import me.madopew.ctog.dto.security.UserDetailsDto
import me.madopew.ctog.model.user.UserInfo
import me.madopew.ctog.service.model.UserService
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import javax.persistence.EntityManager

@Service
@Transactional
class AuthService(
    private val userService: UserService,
    private val jwtService: JwtService,
    private val passwordEncoder: PasswordEncoder,
    private val authenticationManager: AuthenticationManager,
    private val entityManager: EntityManager
) {
    fun login(request: AuthDto): LoginResponseDto {
        val user = userService.getByUsername(request.username) ?: return register(request)

        authenticationManager.authenticate(
            UsernamePasswordAuthenticationToken(request.username, request.password)
        )

        return LoginResponseDto(jwtService.generateToken(UserDetailsDto(user)))
    }

    private fun register(request: AuthDto): LoginResponseDto {
        val user = userService.save(
            UserInfo().apply {
                username = request.username
                passwordHash = passwordEncoder.encode(request.password)
            }
        )

        entityManager.refresh(user)

        return LoginResponseDto(jwtService.generateToken(UserDetailsDto(user)))
    }
}
