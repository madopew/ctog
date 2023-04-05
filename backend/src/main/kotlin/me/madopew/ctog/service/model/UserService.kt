package me.madopew.ctog.service.model

import me.madopew.ctog.exception.NotFoundException
import me.madopew.ctog.model.UserInfo
import me.madopew.ctog.repository.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
@Transactional
class UserService(
    private val repo: UserRepository
) {
    fun save(user: UserInfo): UserInfo {
        return repo.save(user)
    }

    fun getByUsername(username: String) = repo.findByUsername(username)

    fun findByUsername(username: String) = getByUsername(username)
        ?: throw NotFoundException("User $username not found")

    fun getAll(): List<UserInfo> {
        return repo.findAll()
    }
}
