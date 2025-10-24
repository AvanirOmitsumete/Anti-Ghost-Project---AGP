<script setup lang="ts">
import { defineAsyncComponent, ref, onMounted } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import { authService } from '@/services/auth'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const isLoggedIn = ref(false)

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

onMounted(() => {
  authService.getSession().then(session => {
    isLoggedIn.value = !!session;
  });
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session;
  });
});

// Dummy data for team members
const teamMembers = [
  { name: 'Kent Jay D. Otadoy', role: 'The Architect', image: 'images/about/ken.png' },
  { name: 'Manuel M. Cando', role: 'BlockChain Developer', image: 'images/about/man.png' },
  { name: 'Melecio Andre S. Cabahug', role: 'Backend Developer', image: 'images/about/mel.png' },
  { name: 'Rodnel Quilantang', role: 'Frontend Developer', image: 'images/about/rod.png' },
]

const values = [
  { title: 'Innovation', description: 'Continuously pushing boundaries with cutting-edge technology.' },
  { title: 'Integrity', description: 'Upholding the highest standards of honesty and ethical conduct.' },
  { title: 'Collaboration', description: 'Fostering teamwork and open communication to achieve shared goals.' },
  { title: 'Excellence', description: 'Committed to delivering superior quality and exceptional results.' },
]
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <Header />
    <main class="flex-1 py-16 px-4 bg-gray-50 pt-16">
      <button v-if="isLoggedIn" class="absolute top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />
      <div class="max-w-6xl mx-auto">
        <h1 class="text-4xl font-bold text-gray-900 text-center mb-12">
          About BlockTrack
        </h1>

        <!-- Introduction -->
        <section class="mb-16 text-center">
          <p class="text-lg text-gray-700 leading-relaxed max-w-3xl mx-auto">
            BlockTrack is a pioneering platform dedicated to revolutionizing project management and asset tracking through innovative blockchain technology. We empower businesses with unparalleled transparency, security, and efficiency in their operations.
          </p>
        </section>

        <!-- Our Mission -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">
            Our Mission
          </h2>
          <div class="flex flex-col md:flex-row items-center md:space-x-8">
            <div class="md:w-1/2 mb-6 md:mb-0">
              <img src="/images/about/four.jpg" alt="Our Mission" class="rounded-lg shadow-lg">
            </div>
            <div class="md:w-1/2 text-lg text-gray-700 leading-relaxed">
              <p class="mb-4">
                Our mission is to provide a robust, decentralized solution for tracking projects and managing assets, ensuring every transaction and milestone is immutably recorded and verifiable. We aim to eliminate inefficiencies, reduce fraud, and build trust across complex supply chains and project lifecycles.
              </p>
              <p>
                By leveraging the power of blockchain, we offer a secure and transparent ecosystem where all stakeholders can access real-time, accurate information, fostering accountability and driving operational excellence.
              </p>
            </div>
          </div>
        </section>

        <!-- What We Do -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">
            What We Do
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h3 class="text-xl font-bold text-gray-900 mb-3">
                Secure Project Tracking
              </h3>
              <p class="text-gray-700">
                Utilize blockchain to create an unalterable record of project progress, tasks, and deliverables.
              </p>
            </div>
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h3 class="text-xl font-bold text-gray-900 mb-3">
                Transparent Asset Management
              </h3>
              <p class="text-gray-700">
                Track physical and digital assets with complete visibility and an auditable trail.
              </p>
            </div>
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h3 class="text-xl font-bold text-gray-900 mb-3">
                Decentralized Collaboration
              </h3>
              <p class="text-gray-700">
                Enable secure and efficient collaboration among multiple parties without intermediaries.
              </p>
            </div>
          </div>
        </section>

        <!-- Our Values -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">
            Our Values
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <div v-for="value in values" :key="value.title" class="bg-white p-6 rounded-lg shadow-md text-center">
              <h3 class="text-xl font-bold text-gray-900 mb-3">
                {{ value.title }}
              </h3>
              <p class="text-gray-700">
                {{ value.description }}
              </p>
            </div>
          </div>
        </section>

        <!-- Our Team -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">
            Our Team
          </h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-8">
            <div v-for="member in teamMembers" :key="member.name" class="text-center">
              <img :src="member.image" :alt="member.name" class="w-32 h-32 object-cover rounded-full mx-auto mb-4 shadow-md">
              <h3 class="text-xl font-semibold text-gray-900">
                {{ member.name }}
              </h3>
              <p class="text-blue-600">
                {{ member.role }}
              </p>
            </div>
          </div>
        </section>

        <!-- Call to Action -->
        <section class="text-center">
          <p class="text-xl text-gray-700 mb-6">
            Join us in building the future of transparent and secure project management.
          </p>
          <router-link to="/register" class="inline-block bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-lg transition duration-300 text-xl">
            Get Started Today
          </router-link>
        </section>
      </div>
    </main>
    <Footer />
  </div>
</template>
