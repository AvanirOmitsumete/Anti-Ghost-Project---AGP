<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '@/services/auth'

const router = useRouter()
const isOpen = ref(false)
const isLoggedIn = ref(false)

async function checkLoginStatus() {
  try {
    const session = await authService.getSession()
    isLoggedIn.value = !!session
  }
  catch (error) {
    console.error('Error checking login status:', error)
    isLoggedIn.value = false
  }
}

async function handleLogout() {
  try {
    await authService.signOut()
    isLoggedIn.value = false
    router.push('/login')
  }
  catch (error) {
    console.error('Error during logout:', error)
  }
}

onMounted(() => {
  checkLoginStatus()
  // Listen for auth state changes from Supabase
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session
    if (!session && router.currentRoute.value.meta.requiresAuth) {
      // If user logs out or session expires and they are on a protected route
      router.push('/login')
    }
  })
})
</script>

<template>
  <nav class="bg-gray-900 fixed top-0 left-0 right-0 z-50 border-b border-cyan-400">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16">
        <!-- Left Side (Brand) -->
        <div class="flex-shrink-0">
          <a href="/" class="flex items-center space-x-2">
            <!-- Stylized Geometric Shape (Cube) -->
            <svg class="h-8 w-8 text-cyan-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7l8 4" />
            </svg>
            <span class="text-white text-2xl font-bold">BlockTrack</span>
          </a>
        </div>

        <!-- Right Side (Desktop Navigation) -->
        <div class="hidden md:flex md:items-center md:space-x-8">
          <a href="/home" class="text-white hover:text-cyan-400 uppercase font-medium tracking-wider">Home</a>
          <a href="/project-tracker" class="text-white hover:text-cyan-400 uppercase font-medium tracking-wider">Track Projects</a>
          <a href="/about-us" class="text-white hover:text-cyan-400 uppercase font-medium tracking-wider">About Us</a>
          <a v-if="!isLoggedIn" href="/login" class="text-white hover:text-cyan-400 uppercase font-medium tracking-wider">Login</a>
          <a v-else href="#" class="text-white hover:text-cyan-400 uppercase font-medium tracking-wider" @click.prevent="handleLogout">Logout</a>
        </div>
      </div>
    </div>
  </nav>
</template>
