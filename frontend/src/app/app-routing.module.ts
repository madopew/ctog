import { inject, NgModule } from '@angular/core'
import { Router, RouterModule, Routes } from '@angular/router'
import { LoginComponent } from './components/login/login.component'
import { AuthService } from './services/auth/auth.service'
import {MainComponent} from "./components/main/main.component";

function authGuard(): Promise<boolean> | boolean {
  const router = inject(Router)
  const authService = inject(AuthService)

  if (!authService.isAuthenticated()) {
    authService.logOut()
    return router.navigate(['/login']).then(() => false)
  }

  return true
}

const routes: Routes = [
  { path: '', redirectTo: '/main', pathMatch: 'full' },
  { path: 'main', canActivate: [authGuard], component: MainComponent, title: 'Main' },
  { path: 'login', component: LoginComponent, title: 'Login' },
  { path: 'logout', component: LoginComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
