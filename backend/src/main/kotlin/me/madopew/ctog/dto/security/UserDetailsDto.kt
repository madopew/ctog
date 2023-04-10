package me.madopew.ctog.dto.security

import me.madopew.ctog.model.user.UserInfo
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

class UserDetailsDto(
        private val username: String,
        private val password: String,
        role: String
) : UserDetails {
    private val authorities = listOf(SimpleGrantedAuthority(role))

    constructor(user: UserInfo) : this(
            user.username,
            user.passwordHash,
            user.userRole.name
    )

    override fun getAuthorities() = authorities

    override fun getPassword() = password

    override fun getUsername() = username

    override fun isAccountNonExpired() = true

    override fun isAccountNonLocked() = true

    override fun isCredentialsNonExpired() = true

    override fun isEnabled() = true
}
