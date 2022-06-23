package me.madopew.ctog.parser.ast.model

internal enum class JumpStatementNodeType {
    GOTO,
    CONTINUE,
    BREAK,
    RETURN;

    override fun toString(): String = when (this) {
        GOTO -> "goto"
        CONTINUE -> "continue"
        BREAK -> "break"
        RETURN -> "return"
    }
}