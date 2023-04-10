import { Injectable } from '@angular/core'
import { HttpClient, HttpParams } from '@angular/common/http'
import { GraphDto, GraphRequest } from '../../domain/graph-domain'
import { Observable } from 'rxjs'
import { AuthService } from '../auth/auth.service'
import { Page } from '../../domain/page-domain'

@Injectable({
  providedIn: 'root'
})
export class CtogService {

  constructor(private http: HttpClient,
              private authService: AuthService) {
  }

  parseCode(code: string): Observable<GraphDto[]> {
    return this.http.post<GraphDto[]>('graph', code, {
      headers: this.authService.getHeaders()
    })
  }

  filter(page: number | null, size: number | null): Observable<Page<GraphRequest>> {
    return this.http.post<Page<GraphRequest>>('graph/filter', {}, {
      headers: this.authService.getHeaders(),
      params: {
        page: String(page),
        size: String(size)
      }
    })
  }
}
