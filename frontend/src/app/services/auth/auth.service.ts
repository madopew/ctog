import {Injectable} from '@angular/core'
import {HttpClient} from '@angular/common/http'
import {Observable} from 'rxjs'

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private authTokenKey = 'auth-token'

  constructor(private http: HttpClient) {
  }

  isAuthenticated(): boolean {
    return !!localStorage.getItem(this.authTokenKey)
  }

  getToken(): string {
    return localStorage.getItem(this.authTokenKey) || ''
  }

  getHeaders(): any {
    return {
      'Authorization': 'Bearer ' + this.getToken()
    }
  }

  isAdmin(): boolean {
    const claims = this.getToken().split('.')[1]
    const decoded = JSON.parse(atob(claims))
    return decoded['role'] && decoded['role'] === 'admin'
  }

  logOut(): void {
    localStorage.clear()
  }

  logIn(username: string, password: string): Observable<void> {
    this.logOut()
    return new Observable<void>(observer => {
      this.http.post<{ token: string }>('auth/login', {username, password}).subscribe({
        next: res => {
          localStorage.setItem(this.authTokenKey, res.token)
          observer.next()
          observer.complete()
        },
        error: (err) => {
          console.log(err)
          observer.error(err.error.message)
        }
      })
    })
  }

  me(): Observable<void> {
    return this.http.get<void>('auth/me', {
      headers: this.getHeaders()
    })
  }
}
