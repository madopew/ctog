import {AfterViewInit, Component} from '@angular/core';
import {PageEvent} from "@angular/material/paginator";
import {CtogService} from "../../services/ctog/ctog.service";

@Component({
  selector: 'app-ctog-history',
  templateUrl: './ctog-history.component.html',
  styleUrls: ['./ctog-history.component.scss']
})
export class CtogHistoryComponent implements AfterViewInit {
  totalElements = 0

  constructor(private ctogService: CtogService) {
  }

  ngAfterViewInit() {
    this.sendPageRequest(null)
  }

  onPage(event: PageEvent) {
    this.sendPageRequest(event.pageIndex)
  }

  sendPageRequest(page: number | null) {
    this.ctogService.filter(page, null).subscribe(res => {
      this.totalElements = res.totalElements
    })
  }
}
