import { createRouter, createWebHistory } from 'vue-router'
import { authService } from '@/services/auth' // Import authService
import { isLoading } from '@/utils/loadingState' // Import isLoading
import AboutUsView from '@/views/AboutUsView.vue'
import AuthenticateView from '@/views/AuthenticateView.vue'
import CreateProjectView from '@/views/CreateProjectView.vue'
import DashboardView from '@/views/DashboardView.vue'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import MyProjectsView from '@/views/MyProjectsView.vue'
import ProjectDetailsView from '@/views/ProjectDetailsView.vue'
import ProjectTrackerView from '@/views/ProjectTrackerView.vue'
import RegisterView from '@/views/RegisterView.vue'
import SettingsView from '@/views/SettingsView.vue'
import UserProfileView from '@/views/UserProfileView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/home',
    },
    {
      path: '/home',
      name: 'home',
      component: HomeView,
      meta: { requiresAuth: false }, // Home does not require auth
    },
    {
      path: '/login',
      name: 'Login',
      component: LoginView,
      meta: { requiresAuth: false }, // Explicitly mark as not requiring auth
    },
    {
      path: '/register',
      name: 'Register',
      component: RegisterView,
      meta: { requiresAuth: false }, // Explicitly mark as not requiring auth
    },
    {
      path: '/about-us',
      name: 'AboutUs',
      component: AboutUsView,
      meta: { requiresAuth: false }, // About Us does not require auth
    },
    {
      path: '/project-tracker',
      name: 'ProjectTracker',
      component: ProjectTrackerView,
      meta: { requiresAuth: false }, // Project Tracker does not require auth
    },
    {
      path: '/forgot-password',
      name: 'forgot-password',
      component: () => import('../views/ForgotPasswordView.vue'),
      meta: { requiresAuth: false },
    },
    {
      path: '/ChangePassword',
      name: 'ChangePassword',
      component: () => import('../views/ChangePasswordView.vue'),
      meta: { requiresAuth: true },
    },
    {
      path: '/dashboard',
      name: 'Dashboard',
      component: DashboardView,
      meta: { requiresAuth: true },
    },
    {
      path: '/create-project',
      name: 'CreateProject',
      component: CreateProjectView,
      meta: { requiresAuth: true },
    },
    {
      path: '/my-projects',
      name: 'MyProjects',
      component: MyProjectsView,
      meta: { requiresAuth: true },
    },
    {
      path: '/user-profile',
      name: 'UserProfile',
      component: UserProfileView,
      meta: { requiresAuth: true },
    },
    {
      path: '/settings',
      name: 'Settings',
      component: SettingsView,
      meta: { requiresAuth: true },
    },
    {
      path: '/projects/:id',
      name: 'ProjectDetails',
      component: ProjectDetailsView,
      props: true,
      meta: { requiresAuth: true },
    },
    {
      path: '/authenticate',
      name: 'Authenticate',
      component: AuthenticateView,
      meta: { requiresAuth: true },
    },
  ],
})

router.beforeEach(async (to, from, next) => {
  isLoading.value = true // Start loading indicator

  const requiresAuth = to.matched.some(record => record.meta.requiresAuth)
  const currentSession = await authService.getSession()

  if (requiresAuth && !currentSession) {
    // If route requires auth and user is NOT logged in
    next({ name: 'Login' })
  }
  else if ((to.name === 'Login' || to.name === 'Register') && currentSession) {
    // If user IS logged in and trying to access login/register page
    next({ name: 'Dashboard' })
  }
  else {
    next()
  }

  isLoading.value = false // Stop loading indicator
})

export default router
