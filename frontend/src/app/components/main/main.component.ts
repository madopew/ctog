import { AfterViewInit, Component } from '@angular/core'
import { Router } from '@angular/router'
import { AuthService } from '../../services/auth/auth.service'
import { GraphDto } from '../../domain/graph-domain'

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements AfterViewInit {
  selectedTab = 'code'

  code: string = 'func main(string[] args) {\n    print(args[0]);\n}'
  graphs: GraphDto[] = []

  constructor(private router: Router,
              private authService: AuthService) {
  }

  ngAfterViewInit() {
    this.authService.me().subscribe({
      error: err => {
        console.log(err)
      }
    })
  }

  onViewClick(event: { input: string, output: GraphDto[] }) {
    this.code = event.input
    this.graphs = event.output
    this.selectCode()
  }

  isAdmin(): boolean {
    return this.authService.isAdmin()
  }

  selectCode() {
    this.selectedTab = 'code'
  }

  selectHistory() {
    this.selectedTab = 'history'
  }

  selectLogout() {
    this.router.navigate(['/logout'], { replaceUrl: true })
  }
}
