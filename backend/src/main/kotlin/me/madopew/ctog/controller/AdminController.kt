package me.madopew.ctog.controller

import me.madopew.ctog.constant.API_ADMIN
import me.madopew.ctog.service.model.UserService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping(API_ADMIN)
class AdminController(
    private val userService: UserService
) {
    @GetMapping("/users")
    fun getAllUsers() = userService.getAll()
}
