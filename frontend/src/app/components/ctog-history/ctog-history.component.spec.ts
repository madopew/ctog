import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CtogHistoryComponent } from './ctog-history.component';

describe('CtogHistoryComponent', () => {
  let component: CtogHistoryComponent;
  let fixture: ComponentFixture<CtogHistoryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CtogHistoryComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CtogHistoryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
