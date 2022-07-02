import {useEffect, useState} from "react";
import './GraphDrawer.css';
import {Label, Layer, Line, Rect, Stage, Text} from "react-konva";
import Vector2 from "../../util/Vector2";

export interface GraphNode {
  type: string;
  text: string;
}

type GraphEdges = Record<number, Record<number, string>>;

export interface Graph {
  nodes: GraphNode[];
  edges: GraphEdges;
}

interface GraphProps {
  data: Graph;
}

interface DrawableGraphNode {
  id: string;
  vector: Vector2;
  isDragging: boolean;
  isStart: boolean;
  node: GraphNode;
}

export default function GraphDrawer({data}: GraphProps) {
  const canvasWidth = window.innerWidth;
  const canvasHeight = window.innerHeight * 2;
  const connectionLength = 100;
  const gVector = Vector2.G.multiply(connectionLength / 20);
  const connectionConstant = connectionLength / 10;
  const repulsionConstant = connectionLength / 3;
  const nodeWidth = 100;
  const nodeHeight = 30;

  const [drawNodes, setDrawNodes] = useState<DrawableGraphNode[]>([]);

  const connectedTo = (nodeIndex: number): number[] => {
    const connected: number[] = [];
    for (const [fromIndex, toList] of Object.entries(data.edges)) {
      for (const [toIndex] of Object.entries(toList)) {
        if (Number(toIndex) === nodeIndex) {
          connected.push(Number(fromIndex));
        }
      }
    }
    return connected;
  }

  const getStartIndex = (): number => {
    const startIndexes: number[] = [];
    data.nodes.forEach((node, index) => {
      if (connectedTo(index).length === 0) {
        startIndexes.push(index);
      }
    });

    if (startIndexes.length === 0) {
      throw new Error("No start node found");
    } else if (startIndexes.length > 1) {
      throw new Error("Multiple start nodes found");
    } else {
      return startIndexes[0];
    }
  }

  const updateForces = (nodes: DrawableGraphNode[]): DrawableGraphNode[] => {
    return nodes.map(node => {
      if (!node.isStart) {
        const nodeIndex = Number(node.id);

        let resultantVector = gVector;

        connectedTo(nodeIndex)
          .map(connectedIndex => {
            return Vector2.fromVectors(node.vector, nodes[connectedIndex].vector);
          })
          .forEach(vector => {
            if (vector.length >= connectionLength) {
              resultantVector = resultantVector.add(vector.normalize().multiply(connectionConstant));
            }
          });

        nodes.filter(otherNode => otherNode.id !== node.id)
          .filter(otherNode => {
            if (node.vector.x < otherNode.vector.x + nodeWidth && node.vector.x > otherNode.vector.x - nodeWidth) {
              if (node.vector.y < otherNode.vector.y + nodeHeight && node.vector.y > otherNode.vector.y - nodeHeight) {
                return true;
              }
            }
            return false;
          })
          .map(otherNode => {
            return Vector2.fromVectors(otherNode.vector, node.vector);
          })
          .forEach(vector => {
            resultantVector = resultantVector.add(vector.normalize().multiply(repulsionConstant));
          })

        return {
          ...node,
          vector: node.vector.add(resultantVector)
        }
      } else {
        return node;
      }
    });
  }

  useEffect(() => {
    let positionVector = new Vector2(canvasWidth / 2, 30);
    let prev = data.nodes.map((node, index) => {
      const isStart = index === getStartIndex();
      positionVector = positionVector.add(new Vector2(1, nodeHeight + 20));
      return {
        id: index.toString(),
        vector: isStart ? new Vector2(canvasWidth / 2, 30) : positionVector,
        isDragging: false,
        isStart: isStart,
        node: node
      }
    });
    for (let i = 0; i < 1000; i++) {
      prev = updateForces(prev);
    }

    setDrawNodes(prev);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleDragStart = (e: any) => {
    const id = e.target.id();
    setDrawNodes(drawNodes.map(node => {
      if (node.id === id) {
        node.isDragging = true;
      }
      return node;
    }));
  }

  const handleDragEnd = (e: any) => {
    const id = e.target.id();
    setDrawNodes(drawNodes.map(node => {
      if (node.id === id) {
        node.isDragging = false;
      }
      return node;
    }));
  }

  const handleDragMove = (e: any) => {
    const id = e.target.id();
    const newX = e.target.x();
    const newY = e.target.y();
    setDrawNodes(drawNodes.map(node => {
      if (node.id === id) {
        node.vector = new Vector2(newX, newY);
      }
      return node;
    }));
  }

  return (
    <div className="GraphDrawer">
      <Stage width={canvasWidth} height={canvasHeight}>
        <Layer>
          {drawNodes.map(drawNode => {
            const nodeIndex = Number(drawNode.id);
            return connectedTo(nodeIndex)
              .map(connectedIndex => drawNodes[connectedIndex])
              .map(connectedNode => (
                <Line
                  key={`${drawNode.id}-${connectedNode.id}`}
                  points={[
                    drawNode.vector.x + nodeWidth / 2, drawNode.vector.y + nodeHeight / 2,
                    connectedNode.vector.x + nodeWidth / 2, connectedNode.vector.y + nodeHeight / 2
                  ]}
                  stroke={'#000'}
                />
              ))
          })}
          {drawNodes.map(node => (
            <Rect
              key={node.id}
              id={node.id}
              x={node.vector.x}
              y={node.vector.y}
              width={nodeWidth}
              height={nodeHeight}
              draggable
              onDragStart={handleDragStart}
              onDragEnd={handleDragEnd}
              onDragMove={handleDragMove}
              fill={'#666'}
              stroke={'#000'}
              scale={node.isDragging ? {x: 1.2, y: 1.2} : {x: 1, y: 1}}
            />
          ))}
          {drawNodes.map(drawNode => (
            <Text
              key={`${drawNode.id}-text`}
              id={drawNode.id}
              x={drawNode.vector.x}
              y={drawNode.vector.y}
              text={drawNode.node.text}
              fill={'#fff'}
            />
          ))}
          <Label/>
        </Layer>
      </Stage>
    </div>
  );
}