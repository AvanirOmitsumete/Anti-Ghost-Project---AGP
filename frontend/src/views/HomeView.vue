<script setup lang="ts">
import { defineAsyncComponent, onMounted, ref } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import ImageCarousel from '@/components/ImageCarousel.vue'
import { authService } from '@/services/auth'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const isLoggedIn = ref(false)

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

onMounted(() => {
  authService.getSession().then((session) => {
    isLoggedIn.value = !!session
  })
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session
  })
})

const carouselImages = [
  '/images/cordovab.png',
  '/images/Cavite.png',
  '/images/image.png',
  '/images/airport.png',
  '/images/lrt.jpg',

]
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <Header />
    <main class="flex-1">
      <button v-if="isLoggedIn" class="absolute top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />
      <div class="relative w-full h-screen">
        <ImageCarousel :images="carouselImages" />

        <div class="absolute left-0 top-0 bottom-0 flex items-center z-10">
          <div class="bg-cyan-500 bg-opacity-75 py-8 px-4 sm:py-16 sm:px-8 text-white max-w-full sm:max-w-sm h-full flex flex-col justify-center items-center rounded-r-lg">
            <h2 class="text-2xl sm:text-4xl font-bold mb-2 sm:mb-4 text-center">
              Authenticity and Tracking is here
            </h2>
            <router-link to="/register" class="inline-block bg-white text-cyan-700 font-bold py-2 px-6 sm:py-3 sm:px-12 rounded-full shadow-lg hover:bg-gray-100 transition duration-300 text-base sm:text-xl">
              Sign up now!
            </router-link>
          </div>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>
