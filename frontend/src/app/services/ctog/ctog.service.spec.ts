import { TestBed } from '@angular/core/testing';

import { CtogService } from './ctog.service';

describe('CtogService', () => {
  let service: CtogService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CtogService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
