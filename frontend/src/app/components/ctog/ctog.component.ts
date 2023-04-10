import { Component, ElementRef, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core'
import { CtogService } from '../../services/ctog/ctog.service'
import { GraphDto } from '../../domain/graph-domain'
import { GraphViewerComponent } from '../graph-viewer/graph-viewer.component'
import { MatSnackBar } from '@angular/material/snack-bar'

@Component({
  selector: 'app-ctog',
  templateUrl: './ctog.component.html',
  styleUrls: ['./ctog.component.scss']
})
export class CtogComponent {
  @ViewChild('codeInput') codeInput?: ElementRef
  @Input('code') code: string = ""
  @Output('codeChange') codeChange = new EventEmitter<string>()
  @Input('graphs') graphs: GraphDto[] = []
  @Output('graphsChange') graphsChange = new EventEmitter<GraphDto[]>()

  codeCache = this.code

  @ViewChild('graphViewer') graphViewer!: GraphViewerComponent
  @ViewChild('imageCanvas') imageCanvas!: ElementRef

  IF_STATEMENT = 'if () {\n    }'
  IF_ELSE_STATEMENT = 'if () {\n    } else {\n    }'
  SWITCH_STATEMENT = 'switch () {\n        default: {\n        }\n    }'
  WHILE_STATEMENT = 'while () {\n    }'
  DO_WHILE_STATEMENT = 'do {\n    } while ();'
  FOR_STATEMENT = 'for () {\n    }'

  constructor(private ctogService: CtogService,
              private snack: MatSnackBar) {
  }

  parseCode() {
    this.ctogService.parseCode(this.code).subscribe({
      next: res => {
        this.codeCache = this.code
        this.graphs = res
      },
      error: err => {
        this.snack.open(err.error.message, 'Close', {duration: 5000})
      }
    })
  }

  clear() {
    this.graphs = []
  }

  insertStatement(statement: string) {
    const posStart = this.codeInput!.nativeElement.selectionStart
    const posEnd = this.codeInput!.nativeElement.selectionEnd
    this.insertCodeAt(posStart, posEnd, statement)
  }

  insertCodeAt(posStart: number, posEnd: number, value: string) {
    this.code = this.code.substring(0, posStart) + value + this.code.substring(posEnd)
  }

  export() {
    this.graphViewer.export().then(url => {
      const a = document.createElement('a')
      document.body.appendChild(a)
      a.setAttribute('style', 'display: none')
      a.href = url
      a.download = `graph-${new Date().toISOString()}.png`
      a.click()
      window.URL.revokeObjectURL(url)
      a.remove()
    })
  }
}
