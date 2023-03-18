import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CtogComponent } from './ctog.component';

describe('CtogComponent', () => {
  let component: CtogComponent;
  let fixture: ComponentFixture<CtogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CtogComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CtogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
