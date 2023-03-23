import { AfterViewChecked, AfterViewInit, Component, Input, OnChanges, SimpleChanges } from '@angular/core'
import { GraphDto } from '../../domain/graph-domain'
import { DragRef, Point } from '@angular/cdk/drag-drop'

@Component({
  selector: 'app-graph-viewer',
  templateUrl: './graph-viewer.component.html',
  styleUrls: ['./graph-viewer.component.scss']
})
export class GraphViewerComponent implements AfterViewInit {
  @Input('graphDtoList') graphDtoList: GraphDto[] = []

  sizeMultiplier = 7

  width() {
    return 26 * this.sizeMultiplier
  }

  height() {
    return 16 * this.sizeMultiplier
  }

  lines: any[] = []

  constructor() {
  }

  ngAfterViewInit() {
    this.drawLines()
  }

  scaleUp() {
    this.sizeMultiplier++
  }

  scaleDown() {
    this.sizeMultiplier--
  }

  computeDragGrid(pos: Point, dragRef: DragRef) {
    const pickup = dragRef['_pickupPositionInElement']
    const dw = pickup['x']
    const dh = pickup['y']
    const grid = 7
    return {
      x: Math.floor((pos.x - dw) / grid) * grid,
      y: Math.floor((pos.y - dh) / grid) * grid
    }
  }

  drawLines() {
    if (this.lines.length > 0) {
      this.lines.forEach(l => l.remove())
      this.lines = []
    }

    for (let fi = 0; fi < this.graphDtoList.length; fi++) {
      Object.keys(this.graphDtoList[fi].edges).forEach(nisString => {
        const nis = Number(nisString)
        Object.keys(this.graphDtoList[fi].edges[nis]).forEach(nieString => {
          const nie = Number(nieString)
          const start = document.getElementById(`node-${fi}-${nis}`) as Element
          const end = document.getElementById(`node-${fi}-${nie}`) as Element
          const lineText = this.graphDtoList[fi].edges[nis][nie] ?? ''
          // @ts-ignore
          const line = new LeaderLine({
            start,
            end,
            endSocket: 'top',
            color: 'black',
            path: 'fluid',
            size: '2',
            endPlug: 'arrow3',
            // @ts-ignore
            middleLabel: lineText
          })
          this.lines.push(line)
        })
      })
    }
  }
}
