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
  code: string = 'int main() {\n    printf("Hello World!");\n    return 0;\n}'

  clearTime = 0

  graphs: GraphDto[] = [
    {
      nodes: [
        {
          type: NodeType.START_END,
          text: 'int main ( )'
        },
        {
          type: NodeType.START_END,
          text: 'end.'
        },
        {
          type: NodeType.ACTION,
          text: 'return 0'
        },
        {
          type: NodeType.OUTPUT,
          text: 'printf("Hello World!")'
        }
      ],
      edges: {
        0: { 3: null },
        2: { 1: null },
        3: { 2: null }
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
        this.parseCode()
      }
    }, 1000)
  }

  onCodeChange() {
    this.codeInput!.nativeElement.className = ''
    this.clearTime = 3
  }

  parseCode() {
    this.ctogService.parseCode(this.code).subscribe(res => {
      this.graphs = res
    })
  }
}
