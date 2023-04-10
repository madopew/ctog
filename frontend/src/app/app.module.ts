import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CtogComponent } from './components/ctog/ctog.component';
import { HIGHLIGHT_OPTIONS, HighlightModule } from 'ngx-highlightjs'
import { FormsModule } from '@angular/forms'
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http'
import { GraphViewerComponent } from './components/graph-viewer/graph-viewer.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations'
import { DragDropModule } from '@angular/cdk/drag-drop';
import { LoginComponent } from './components/login/login.component'
import { UrlInterceptor } from './interceptors/url/url.interceptor';
import { MainComponent } from './components/main/main.component'
import {MatIconModule} from "@angular/material/icon";
import {MatTooltipModule} from "@angular/material/tooltip";
import {GraphModule} from "@swimlane/ngx-graph";
import { CtogHistoryComponent } from './components/ctog-history/ctog-history.component';
import {MatPaginatorModule} from "@angular/material/paginator";

@NgModule({
  declarations: [
    AppComponent,
    CtogComponent,
    GraphViewerComponent,
    LoginComponent,
    MainComponent,
    CtogHistoryComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HighlightModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    DragDropModule,
    MatIconModule,
    MatTooltipModule,
    GraphModule,
    MatPaginatorModule
  ],
  providers: [
    {
      provide: HIGHLIGHT_OPTIONS,
      useValue: {
        fullLibraryLoader: () => import('highlight.js'),
      }
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: UrlInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
