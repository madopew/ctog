package me.madopew.ctog.model.user

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.OneToMany

@Entity
class UserRole {
    @Id
    private var id = 0

    @Column(nullable = false)
    lateinit var name: String

    @OneToMany(mappedBy = "userRole")
    private lateinit var users: Set<UserInfo>
}
