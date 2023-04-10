package me.madopew.ctog.model.graph

enum class NodeType {
    START_END,
    CYCLE_START,
    CYCLE_END,
    ACTION,
    LOCAL_ACTION,
    CONDITION,
    INPUT,
    OUTPUT
}
