package me.madopew.ctog.repository

import me.madopew.ctog.model.user.UserInfo
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor

interface UserRepository: JpaRepository<UserInfo, Int>, JpaSpecificationExecutor<UserInfo> {
    fun findByUsername(username: String): UserInfo?
}
