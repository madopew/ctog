export interface GraphDto {
  nodes: GraphNodeDto[]
  edges: Record<number, Record<number, string | null>>
}

export interface GraphNodeDto {
  type: NodeType
  text: string
}

export enum NodeType {
  START_END = 'START_END',
  CYCLE_START = 'CYCLE_START',
  CYCLE_END = 'CYCLE_END',
  ACTION = 'ACTION',
  LOCAL_ACTION = 'LOCAL_ACTION',
  CONDITION = 'CONDITION',
  INPUT = 'INPUT',
  OUTPUT = 'OUTPUT'
}

export interface GraphRequest {
  ts: string,
  input: string,
  output: GraphDto[]
}
