package me.madopew.ctog.service.security

import me.madopew.ctog.constant.FRONTEND_URL
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Component
class CorsFilter : OncePerRequestFilter() {
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        response.setHeader("Access-Control-Allow-Origin", FRONTEND_URL)
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        response.setHeader("Access-Control-Allow-Headers", "Authorization, Content-Type")
        filterChain.doFilter(request, response)
    }
}
