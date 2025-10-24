<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 flex p-4 pt-16">
      <!-- Burger Icon -->
      <button v-if="isLoggedIn" @click="toggleSidebar" class="absolute top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
        </svg>
      </button>

      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 flex items-center justify-center">
        <div class="text-center">
          <h1 class="text-4xl font-bold text-gray-800 mb-4">Project Details Page</h1>
          <p class="text-lg text-gray-600">Details for Project ID: {{ $route.params.id }}</p>
          <p class="text-lg text-gray-600">This is a placeholder for the Project Details page.</p>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, onMounted } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import { authService } from '@/services/auth' // Import authService

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const isLoggedIn = ref(false) // Add isLoggedIn state

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

// Check login status on mount and listen for changes
onMounted(() => {
  authService.getSession().then(session => {
    isLoggedIn.value = !!session;
  });
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session;
  });
});
</script>