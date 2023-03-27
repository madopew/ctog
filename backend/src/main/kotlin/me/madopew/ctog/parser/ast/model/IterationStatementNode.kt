package me.madopew.ctog.parser.ast.model

internal class IterationStatementNode: StatementNode() {
    var type: IterationStatementNodeType? = null
    var condition: String? = null
    var body: CompoundStatementNode? = null
}
