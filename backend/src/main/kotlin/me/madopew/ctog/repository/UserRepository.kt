package me.madopew.ctog.repository

import me.madopew.ctog.model.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor

interface UserRepository: JpaRepository<User, Int>, JpaSpecificationExecutor<User>
