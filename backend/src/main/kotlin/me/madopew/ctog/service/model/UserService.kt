package me.madopew.ctog.service.model

import me.madopew.ctog.repository.UserRepository
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.stereotype.Service

@Service
class UserService(
    private val repo: UserRepository
) : UserDetailsService {
    override fun loadUserByUsername(username: String): UserDetails {
        TODO()
    }
}
