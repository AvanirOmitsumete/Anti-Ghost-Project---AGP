<script setup lang="ts">
import { defineAsyncComponent } from 'vue'
import ImageCarousel from '@/components/ImageCarousel.vue'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const carouselImages = [
  '/images/image.png',
  '/images/Cavite.png',
  '/images/airport.png',
  '/images/lrt.jpg',
  '/images/Project5.png',
]
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <Header />
    <main class="flex-1">
      <ImageCarousel :images="carouselImages" />

      <div class="max-w-4xl mx-auto py-8 px-4">
        <p class="text-gray-700 dark:text-gray-300 leading-relaxed">
          This is the home page, featuring a dynamic image carousel.
        </p>
      </div>
    </main>
    <Footer />
  </div>
</template>
