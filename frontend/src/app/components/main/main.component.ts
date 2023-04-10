import {AfterViewInit, Component} from '@angular/core';
import {Router} from "@angular/router";
import {AuthService} from "../../services/auth/auth.service";

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements AfterViewInit {
  selectedTab = 'code'

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
    this.router.navigate(['/logout'], {replaceUrl: true})
  }
}
