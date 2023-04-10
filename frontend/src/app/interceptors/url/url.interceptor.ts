import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor
} from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable()
export class UrlInterceptor implements HttpInterceptor {
  constructor() {}

  build(url: string): string {
    if (url.startsWith('http')) {
      return url
    }
    const optionalSlash = url.startsWith('/') ? '' : '/'
    return "http://localhost:8080/api/v1" + optionalSlash + url
  }
  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    request = request.clone({
      url: this.build(request.url)
    })
    return next.handle(request)
  }
}
