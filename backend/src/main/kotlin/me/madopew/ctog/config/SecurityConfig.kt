package me.madopew.ctog.config

import io.jsonwebtoken.JwtParser
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.io.Decoders
import io.jsonwebtoken.security.Keys
import me.madopew.ctog.constant.*
import me.madopew.ctog.exception.ForbiddenException
import me.madopew.ctog.exception.UnauthenticatedException
import me.madopew.ctog.service.security.CorsFilter
import me.madopew.ctog.service.security.ExceptionFilter
import me.madopew.ctog.service.security.JwtFilter
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.http.HttpMethod
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.AuthenticationProvider
import org.springframework.security.authentication.dao.DaoAuthenticationProvider
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import org.springframework.security.web.context.request.async.WebAsyncManagerIntegrationFilter
import java.security.Key

@Configuration
class SecurityConfig {
    @Bean
    fun passwordEncoder(): PasswordEncoder = BCryptPasswordEncoder()

    @Bean
    fun filterChain(
            http: HttpSecurity,
            authenticationProvider: AuthenticationProvider,
            jwtFilter: JwtFilter,
            exceptionFilter: ExceptionFilter,
            corsFilter: CorsFilter
    ): SecurityFilterChain {
        return http.csrf().disable()
                .authorizeHttpRequests()
                .antMatchers(HttpMethod.OPTIONS).permitAll()
                .antMatchers("$API_AUTH/login").permitAll()
                .antMatchers("$API_AUTH/me").authenticated()
                .antMatchers("$API_GRAPH/**").hasAnyAuthority(ROLE_DEFAULT, ROLE_ADMIN)
                .antMatchers("$API_ADMIN/**").hasAuthority(ROLE_ADMIN)
                .anyRequest().authenticated()
                .and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter::class.java)
                .addFilterBefore(exceptionFilter, WebAsyncManagerIntegrationFilter::class.java)
                .addFilterBefore(corsFilter, ExceptionFilter::class.java)
                .exceptionHandling()
                .authenticationEntryPoint { _, _, _ -> throw UnauthenticatedException() }
                .accessDeniedHandler { _, _, _ -> throw ForbiddenException() }
                .and()
                .build()
    }

    @Bean
    fun authenticationProvider(
            userDetailsService: UserDetailsService,
            passwordEncoder: PasswordEncoder
    ): AuthenticationProvider {
        val provider = DaoAuthenticationProvider()
        provider.setUserDetailsService(userDetailsService)
        provider.setPasswordEncoder(passwordEncoder)
        return provider
    }

    @Bean
    fun authenticationManager(config: AuthenticationConfiguration): AuthenticationManager {
        return config.authenticationManager
    }

    @Bean
    fun jwtSecretKey(@Value("\${custom.security.key.secret}") secretKey: String): Key {
        return Keys.hmacShaKeyFor(Decoders.BASE64.decode(secretKey))
    }

    @Bean
    fun jwtParser(key: Key): JwtParser =
            Jwts.parserBuilder().setSigningKey(key).build()
}
