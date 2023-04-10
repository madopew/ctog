import {Component, Input, OnChanges, SimpleChanges} from '@angular/core'
import {GraphDto} from '../../domain/graph-domain'
import {DagreLayout, Edge, Node, Orientation} from "@swimlane/ngx-graph";
import * as htmlToImage from 'html-to-image';

@Component({
  selector: 'app-graph-viewer',
  templateUrl: './graph-viewer.component.html',
  styleUrls: ['./graph-viewer.component.scss']
})
export class GraphViewerComponent implements OnChanges {
  @Input('graphDtoList') graphDtoList: GraphDto[] = []

  nodes: Node[] = []
  links: Edge[] = []
  layout = new DagreLayout()

  constructor() {
    this.layout.defaultSettings.orientation = Orientation.TOP_TO_BOTTOM
    this.layout.defaultSettings.rankPadding = 50
  }

  ngOnChanges(changes: SimpleChanges) {
    if (changes['graphDtoList']) this.drawGraph()
  }

  drawGraph() {
    this.nodes = []
    this.links = []

    this.graphDtoList.forEach((func, fi) => {
      func.nodes.forEach((node, ni) => {
        this.nodes.push({
          id: `node${fi}${ni}`,
          label: node.text,
          data: node
        })
      })

      Object.keys(func.edges).forEach(inis => {
        const ini = Number(inis)
        Object.keys(func.edges[ini]).forEach(onis => {
          const oni = Number(onis)
          this.links.push({
            id: `edge${fi}${inis}${onis}`,
            source: `node${fi}${inis}`,
            target: `node${fi}${onis}`,
            label: func.edges[ini][oni] ?? ''
          })
        })
      })
    })
  }

  export(): Promise<string> {
    return htmlToImage.toPng(document.getElementsByClassName("ngx-charts")[0] as any, {
      skipFonts: true
    })
  }

  textTransform(link: any): string {
    if (link.midPoint) return `translate(${link.midPoint.x}, ${link.midPoint.y})`
    return "translate(0, 0)"
  }
}
