import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import LoginView from '@/views/LoginView.vue'
import RegisterView from '@/views/RegisterView.vue'
import AboutUsView from '@/views/AboutUsView.vue'
import ProjectTrackerView from '@/views/ProjectTrackerView.vue' // Import ProjectTrackerView
import { isLoading } from '@/utils/loadingState' // Import isLoading

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
    },
    {
      path: '/login',
      name: 'Login',
      component: LoginView,
    },
    {
      path: '/register',
      name: 'Register',
      component: RegisterView,
    },
    {
      path: '/about-us',
      name: 'AboutUs',
      component: AboutUsView,
    },
    {
      path: '/project-tracker',
      name: 'ProjectTracker',
      component: ProjectTrackerView,
    },
    {
      path: '/forgot-password',
      name: 'forgot-password',
      component: () => import('../views/ForgotPasswordView.vue'),
    },
    {
      path: '/ChangePassword',
      name: 'ChangePassword',
      component: () => import('../views/ChangePasswordView.vue'),
    },
  ],
})

// Navigation guards
router.beforeEach(() => {
  isLoading.value = true
})

router.afterEach(() => {
  // Add a small delay to ensure the spinner is visible for a minimum duration
  setTimeout(() => {
    isLoading.value = false
  }, 300) // Keep spinner for at least 300ms
})

export default router