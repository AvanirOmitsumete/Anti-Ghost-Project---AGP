<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <Header />
    <main class="flex-1 max-w-4xl mx-auto py-16 px-4">
      <h1 class="text-gray-900 dark:text-white mb-4 text-3xl font-bold">
        About Page
      </h1>
      <p class="text-gray-700 dark:text-gray-300 leading-relaxed">
        This is the about page placeholder. Information about the Lab System will go here.
      </p>
      <!-- About page content will go here -->
    </main>
    <Footer />
  </div>
</template>