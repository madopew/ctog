package me.madopew.ctog.repository

import me.madopew.ctog.model.graph.GraphRequest
import me.madopew.ctog.model.user.UserInfo
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.JpaSpecificationExecutor

interface GraphRepository : JpaRepository<GraphRequest, Int>, JpaSpecificationExecutor<GraphRequest> {
    fun findAllByUserInfo(userInfo: UserInfo, pageable: Pageable): Page<GraphRequest>
}
