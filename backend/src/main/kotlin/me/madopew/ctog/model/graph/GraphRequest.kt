package me.madopew.ctog.model.graph

import me.madopew.ctog.model.user.UserInfo
import me.madopew.ctog.model.user.UserRole
import java.time.Instant
import javax.persistence.*

@Entity
class GraphRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id = 0

    @Column(nullable = false)
    lateinit var input: String

    @Column(nullable = false)
    lateinit var output: String

    @Column(nullable = false)
    var ts: Instant = Instant.now()

    @ManyToOne
    @JoinColumn(name = "user_info_id", nullable = false)
    lateinit var userInfo: UserInfo
}
