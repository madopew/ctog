package me.madopew.ctog.service.model

import me.madopew.ctog.dto.security.UserDetailsDto
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional

@Component
@Transactional
class UserDetailsService(
        private val userService: UserService
) : UserDetailsService {
    override fun loadUserByUsername(username: String): UserDetails {
        return UserDetailsDto(userService.findByUsername(username))
    }
}
