// Representative Angular component excerpt — NOT wired into the running portal.
// Included because Angular 8/14/18 is on the author's resume (Angular 18 at
// Centene, Angular 14 at Frontiers). It shows the same design-system thinking
// in Angular terms: inputs, semantic template, and accessible markup.
// Fictional sample data only.
import { Component, Input } from '@angular/core';

export interface SampleService {
  id: number;
  name: string;
  description: string;
}

@Component({
  selector: 'app-service-card',
  // Semantic <article>, heading level passed in so heading order stays
  // correct wherever the card is used — never hard-code an h2 inside a
  // reusable component that might sit under an h1 or an h3.
  template: `
    <article class="card">
      <h2 *ngIf="headingLevel === 2">{{ service.name }}</h2>
      <h3 *ngIf="headingLevel === 3">{{ service.name }}</h3>
      <p>{{ service.description }}</p>
      <a [routerLink]="['/apply']" [queryParams]="{ program: service.id }">
        Apply for {{ service.name }}
      </a>
    </article>
  `,
})
export class ServiceCardComponent {
  @Input({ required: true }) service!: SampleService;
  @Input() headingLevel: 2 | 3 = 2;
}
