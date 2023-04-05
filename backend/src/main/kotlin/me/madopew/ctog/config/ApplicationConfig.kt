package me.madopew.ctog.config

import io.jsonwebtoken.JwtParser
import io.jsonwebtoken.Jwts
import me.madopew.ctog.mapper.toDetails
import me.madopew.ctog.service.model.UserService
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.core.userdetails.UserDetailsService
import java.security.Key

@Configuration
class ApplicationConfig {
    @Bean
    fun userDetailsService(userService: UserService) = UserDetailsService { username ->
        userService.findByUsername(username).toDetails()
    }

    @Bean
    fun jwtParser(key: Key): JwtParser =
        Jwts.parserBuilder().setSigningKey(key).build()
}
