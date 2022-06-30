package me.madopew.ctog.graph.model

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