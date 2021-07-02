import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FiniComponent } from './fini.component';

describe('FiniComponent', () => {
  let component: FiniComponent;
  let fixture: ComponentFixture<FiniComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FiniComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(FiniComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
