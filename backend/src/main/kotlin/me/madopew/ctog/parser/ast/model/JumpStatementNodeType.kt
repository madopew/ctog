package me.madopew.ctog.parser.ast.model

internal enum class JumpStatementNodeType {
    CONTINUE,
    BREAK,
    RETURN;

    override fun toString(): String = when (this) {
        CONTINUE -> "continue"
        BREAK -> "break"
        RETURN -> "return"
    }
}
