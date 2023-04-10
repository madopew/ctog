import { Component } from '@angular/core';
import { Router } from '@angular/router'
import { AuthService } from '../../services/auth/auth.service'

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent {

  username!: string
  password!: string
  isError: boolean = false
  errorMessage!: string

  constructor(private router: Router, private authService: AuthService) {
    if (this.router.url === '/logout') {
      this.authService.logOut()
      this.router.navigate(['/login'], { replaceUrl: true })
    }
  }

  displayError(message: string) {
    this.isError = true
    this.errorMessage = message
  }

  hideError() {
    this.isError = false
  }

  onSignIn() {
    if (!this.username || !this.password) {
      this.displayError('Please enter username and password')
      return
    }

    this.authService.logIn(this.username, this.password).subscribe({
      next: () => {
        this.hideError()
        this.router.navigate(['/'], { replaceUrl: true })
      },
      error: err =>  {
        this.displayError(err)
      }
    })
  }
}
