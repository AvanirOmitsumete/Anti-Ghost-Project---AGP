<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

// Dummy data for team members
const teamMembers = [
  { name: 'Alice Johnson', role: 'CEO & Founder', image: 'https://via.placeholder.com/150/FF5733/FFFFFF?text=AJ' },
  { name: 'Bob Williams', role: 'Lead Developer', image: 'https://via.placeholder.com/150/33FF57/FFFFFF?text=BW' },
  { name: 'Charlie Brown', role: 'Marketing Director', image: 'https://via.placeholder.com/150/3357FF/FFFFFF?text=CB' },
  { name: 'Diana Prince', role: 'Product Manager', image: 'https://via.placeholder.com/150/FFFF33/000000?text=DP' },
]

// Dummy data for values
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
    <main class="flex-1 py-16 px-4 bg-gray-50">
      <div class="max-w-6xl mx-auto">
        <h1 class="text-4xl font-bold text-gray-900 text-center mb-12">About BlockTrack</h1>

        <!-- Introduction -->
        <section class="mb-16 text-center">
          <p class="text-lg text-gray-700 leading-relaxed max-w-3xl mx-auto">
            BlockTrack is a pioneering platform dedicated to revolutionizing project management and asset tracking through innovative blockchain technology. We empower businesses with unparalleled transparency, security, and efficiency in their operations.
          </p>
        </section>

        <!-- Our Mission -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">Our Mission</h2>
          <div class="flex flex-col md:flex-row items-center md:space-x-8">
            <div class="md:w-1/2 mb-6 md:mb-0">
              <img src="https://via.placeholder.com/600x400/A0A0A0/FFFFFF?text=Our+Mission" alt="Our Mission" class="rounded-lg shadow-lg">
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
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">What We Do</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h3 class="text-xl font-bold text-gray-900 mb-3">Secure Project Tracking</h3>
              <p class="text-gray-700">
                Utilize blockchain to create an unalterable record of project progress, tasks, and deliverables.
              </p>
            </div>
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h3 class="text-xl font-bold text-gray-900 mb-3">Transparent Asset Management</h3>
              <p class="text-gray-700">
                Track physical and digital assets with complete visibility and an auditable trail.
              </p>
            </div>
            <div class="bg-white p-6 rounded-lg shadow-md">
              <h3 class="text-xl font-bold text-gray-900 mb-3">Decentralized Collaboration</h3>
              <p class="text-gray-700">
                Enable secure and efficient collaboration among multiple parties without intermediaries.
              </p>
            </div>
          </div>
        </section>

        <!-- Our Values -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">Our Values</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <div v-for="value in values" :key="value.title" class="bg-white p-6 rounded-lg shadow-md text-center">
              <h3 class="text-xl font-bold text-gray-900 mb-3">{{ value.title }}</h3>
              <p class="text-gray-700">{{ value.description }}</p>
            </div>
          </div>
        </section>

        <!-- Our Team -->
        <section class="mb-16">
          <h2 class="text-3xl font-semibold text-gray-800 text-center mb-8">Our Team</h2>
          <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-8">
            <div v-for="member in teamMembers" :key="member.name" class="text-center">
              <img :src="member.image" :alt="member.name" class="w-32 h-32 object-cover rounded-full mx-auto mb-4 shadow-md">
              <h3 class="text-xl font-semibold text-gray-900">{{ member.name }}</h3>
              <p class="text-blue-600">{{ member.role }}</p>
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
