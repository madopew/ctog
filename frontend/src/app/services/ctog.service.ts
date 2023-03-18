import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { GraphDto, GraphNodeDto } from '../domain/graph-domain'
import { Observable } from 'rxjs'

@Injectable({
  providedIn: 'root'
})
export class CtogService {

  constructor(private http: HttpClient) { }

  parseCode(code: string): Observable<GraphDto[]> {
    return this.http.post<GraphDto[]>('http://localhost:8080/api/v1/graph', code)
  }
}
