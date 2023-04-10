package me.madopew.ctog.model.user

import me.madopew.ctog.model.graph.GraphRequest
import org.hibernate.annotations.LazyCollection
import org.hibernate.annotations.LazyCollectionOption
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.OneToMany

@Entity
class UserInfo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    var id = 0

    @Column(nullable = false)
    lateinit var username: String

    @Column(nullable = false)
    lateinit var passwordHash: String

    @ManyToOne
    @JoinColumn(name = "user_role_id", nullable = false, insertable = false, updatable = false)
    @LazyCollection(LazyCollectionOption.FALSE)
    lateinit var userRole: UserRole

    @OneToMany(mappedBy = "userInfo", cascade = [CascadeType.ALL])
    lateinit var requests: MutableList<GraphRequest>
}
