package me.madopew.ctog.mapper

import me.madopew.ctog.model.UserInfo
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails

fun UserInfo.toDetails() = object : UserDetails {
    override fun getAuthorities() = listOf(SimpleGrantedAuthority(userRole.name))

    override fun getPassword() = passwordHash

    override fun getUsername() = this@toDetails.username

    override fun isAccountNonExpired() = true

    override fun isAccountNonLocked() = true

    override fun isCredentialsNonExpired() = true

    override fun isEnabled() = true
}
