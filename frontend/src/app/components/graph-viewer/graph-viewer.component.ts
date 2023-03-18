import { Component, Input } from '@angular/core'
import { GraphDto } from '../../domain/graph-domain'
import { DragRef, Point } from '@angular/cdk/drag-drop'

@Component({
  selector: 'app-graph-viewer',
  templateUrl: './graph-viewer.component.html',
  styleUrls: ['./graph-viewer.component.scss']
})
export class GraphViewerComponent {
  @Input('graphDtoList') graphDtoList: GraphDto[] = []

  sizeMultiplier = 7
  width = 26 * this.sizeMultiplier
  height = 16 * this.sizeMultiplier

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
}
