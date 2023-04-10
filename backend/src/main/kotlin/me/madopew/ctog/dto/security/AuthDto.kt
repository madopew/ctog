package me.madopew.ctog.dto.security

import javax.validation.constraints.NotEmpty
import javax.validation.constraints.NotNull
import javax.validation.constraints.Pattern
import javax.validation.constraints.Size

class AuthDto {
    @NotNull
    @Size(min = 5, message = "Username should be at least 5 characters long")
    @Pattern(regexp = "^[a-z]+\$", message = "Username should contain only lowercase english letters")
    lateinit var username: String

    @NotNull
    @NotEmpty
    @Size(min = 7, message = "Password should be at least 7 characters long")
    lateinit var password: String
}
