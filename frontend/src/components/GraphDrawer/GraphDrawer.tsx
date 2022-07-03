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
  const connectionLength = 50;
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

  useEffect(() => {
    let layers: number[][] = [];
    let indexStack = [getStartIndex()];
    while (indexStack.length !== 0) {
      const toAdd: number[] = [];
      indexStack = indexStack.flatMap(index => {
        if (toAdd.includes(index)) return [];
        toAdd.push(index);
        layers = layers.map(layer => layer.filter(nodeIndex => nodeIndex !== index));
        if (data.edges[index] === undefined) return [];
        return Object.keys(data.edges[index]).map(Number);
      });
      layers.push(toAdd);
    }

    setDrawNodes(layers.flatMap((layer, currentLevel) => {
      const startX = layer.length === 1
        ? canvasWidth / 2
        : canvasWidth / 2 - ((layer.length - 1) * nodeWidth / 2) - nodeWidth / 4;
      return layer.map((nodeIndex, i) => {
        const vector = new Vector2(startX + nodeWidth * 1.5 * i, 30 + currentLevel * connectionLength);
        return {
          id: String(nodeIndex),
          vector,
          isDragging: false,
          isStart: false,
          node: data.nodes[nodeIndex]
        }
      });
    }));
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
            const nodeIndex = data.nodes.indexOf(drawNode.node);
            return connectedTo(nodeIndex)
              .map(connectedIndex => drawNodes.find(node => node.id === String(connectedIndex))!!)
              .map(connectedNode => (
                <Line
                  key={`${drawNode.id}-${connectedNode.id}`}
                  points={[
                    drawNode.vector.x + nodeWidth / 2, drawNode.vector.y + nodeHeight / 2,
                    connectedNode.vector.x + nodeWidth / 2, connectedNode.vector.y + nodeHeight / 2
                  ]}
                  stroke={'#000'}
                  lineCap={'round'}
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
              fill={'#fff'}
              stroke={'#000'}
              scale={node.isDragging ? {x: 1.2, y: 1.2} : {x: 1, y: 1}}
            />
          ))}
          {drawNodes.map(drawNode => (
            <Text
              key={`${drawNode.id}-text`}
              id={drawNode.id}
              x={drawNode.vector.x + nodeWidth / 2 - 10}
              y={drawNode.vector.y + nodeHeight / 2 - 10}
              text={drawNode.node.text}
              fill={'#000'}
            />
          ))}
          <Label/>
        </Layer>
      </Stage>
    </div>
  );
}