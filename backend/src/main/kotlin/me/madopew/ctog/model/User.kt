package me.madopew.ctog.model

import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Entity
class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id = 0

    @Column(nullable = false)
    lateinit var username: String

    @Column(nullable = false)
    lateinit var passwordHash: String

    @ManyToOne
    @JoinColumn(name = "user_role_id", nullable = false)
    lateinit var userRole: UserRole
}
