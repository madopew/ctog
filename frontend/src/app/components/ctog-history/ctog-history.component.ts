import { AfterViewInit, Component, ElementRef, EventEmitter, Output, ViewChild } from '@angular/core'
import { PageEvent } from '@angular/material/paginator'
import { CtogService } from '../../services/ctog/ctog.service'
import { GraphDto, GraphRequest } from '../../domain/graph-domain'

@Component({
  selector: 'app-ctog-history',
  templateUrl: './ctog-history.component.html',
  styleUrls: ['./ctog-history.component.scss']
})
export class CtogHistoryComponent implements AfterViewInit {
  @Output('viewClick') viewClick = new EventEmitter<{ input: string, output: GraphDto[] }>()

  content: GraphRequest[] = []
  totalElements: number = 0
  size = 5

  @ViewChild('scrollableContent') scrollableContent!: ElementRef

  constructor(private ctogService: CtogService) {
  }

  ngAfterViewInit() {
    this.sendPageRequest(null, this.size)
  }

  onPage(event: PageEvent) {
    this.sendPageRequest(event.pageIndex, event.pageSize)
  }

  sendPageRequest(page: number | null, size: number | null) {
    this.scrollableContent.nativeElement.scroll(0, 0)
    this.ctogService.filter(page, size).subscribe(res => {
      this.content = res.content
      this.totalElements = res.totalElements
    })
  }

  shortGraph(graphs: GraphDto[]): string {
    const numberOfFunctions = graphs.length
    const numberOfElements = graphs.map(g => g.nodes.length).reduce((a, b) => a + b, 0)
    const functionsPrefix = numberOfFunctions > 1 ? 'functions' : 'function'
    return `${numberOfFunctions} ${functionsPrefix}, ${numberOfElements} nodes`
  }

  onViewClick(req: GraphRequest) {
    if(this.viewClick) this.viewClick.emit({ ...req })
  }
}
