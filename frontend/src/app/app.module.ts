import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CtogComponent } from './components/ctog/ctog.component';
import { HIGHLIGHT_OPTIONS, HighlightModule } from 'ngx-highlightjs'
import { FormsModule } from '@angular/forms'
import { HttpClientModule } from '@angular/common/http';
import { GraphViewerComponent } from './components/graph-viewer/graph-viewer.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations'
import { DragDropModule } from '@angular/cdk/drag-drop'

@NgModule({
  declarations: [
    AppComponent,
    CtogComponent,
    GraphViewerComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HighlightModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    DragDropModule
  ],
  providers: [
    {
      provide: HIGHLIGHT_OPTIONS,
      useValue: {
        fullLibraryLoader: () => import('highlight.js'),
      }
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
