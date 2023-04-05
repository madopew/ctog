package me.madopew.ctog.service.security

import io.jsonwebtoken.Claims
import io.jsonwebtoken.JwtParser
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import me.madopew.ctog.exception.UnauthenticatedException
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.stereotype.Service
import java.security.Key
import java.util.Date


@Service
class JwtService(
    private val jwtParser: JwtParser,

    private val jwtKey: Key,

    @Value("\${custom.security.expire.millis}")
    private val expireTimeMillis: Long
) {
    fun generateToken(userDetails: UserDetails): String {
        val currentTime = System.currentTimeMillis()
        return Jwts
            .builder()
            .setClaims(mapOf("role" to userDetails.authorities.first().authority.lowercase()))
            .setSubject(userDetails.username)
            .setIssuedAt(Date(currentTime))
            .setExpiration(Date(currentTime + expireTimeMillis))
            .signWith(jwtKey, SignatureAlgorithm.HS256)
            .compact()
    }

    fun extractUsername(jwt: String): String {
        return extractClaim(jwt, Claims::getSubject)
    }

    fun isTokenExpired(token: String): Boolean {
        return extractExpiration(token).before(Date())
    }

    private fun extractExpiration(jwt: String): Date {
        return extractClaim(jwt, Claims::getExpiration)
    }

    private fun <T> extractClaim(jwt: String, resolver: (Claims) -> T): T {
        val claims = extractAllClaims(jwt)
        return resolver(claims)
    }

    private fun extractAllClaims(jwt: String): Claims {
        return try {
            jwtParser.parseClaimsJws(jwt).body
        } catch (e: Exception) {
            throw UnauthenticatedException()
        }
    }
}
