import { Component, ElementRef, OnInit, ViewChild } from '@angular/core'
import { CtogService } from '../../services/ctog.service'
import { GraphDto, NodeType } from '../../domain/graph-domain'

@Component({
  selector: 'app-ctog',
  templateUrl: './ctog.component.html',
  styleUrls: ['./ctog.component.scss']
})
export class CtogComponent implements OnInit {
  @ViewChild('codeInput') codeInput?: ElementRef
  code: string = 'func main(string[] args) {\n    print(args[0]);\n}'
  codeCache = this.code

  clearTime = 0

  graphs: GraphDto[] = [
    {
      nodes: [
        {
          type: NodeType.START_END,
          text: 'func main ( string [ ] args )'
        },
        {
          type: NodeType.OUTPUT,
          text: 'print(args [ 0 ])'
        },
        {
          type: NodeType.START_END,
          text: 'end.'
        }
      ],
      edges: {
        0: { 1: null },
        1: { 2: null }
      }
    }
  ]

  constructor(private ctogService: CtogService) {
  }

  ngOnInit() {
    setInterval(() => {
      if (this.clearTime <= 0) return
      this.clearTime--
      if (this.clearTime === 0) {
        this.codeInput!.nativeElement.className = 'hidden'
        if (this.codeCache !== this.code) this.parseCode()
      }
    }, 1000)
  }

  onCodeChange() {
    this.codeInput!.nativeElement.className = ''
    this.clearTime = 3
  }

  parseCode() {
    this.ctogService.parseCode(this.code).subscribe(res => {
      this.codeCache = this.code
      this.graphs = res
    })
  }
}
