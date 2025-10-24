<script setup lang="ts">
import { computed, defineAsyncComponent, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '@/components/global/Sidebar.vue'
import { authService } from '@/services/auth' // Import authService

const router = useRouter()

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const searchQuery = ref('')
const isLoggedIn = ref(false) // Add isLoggedIn state

// Dummy project data for the current user
const myProjects = ref([
  { id: 1, name: 'New Centennial Source - Kaliwa Dam Project', percentage: 75, status: 'Ongoing' },
  { id: 4, name: 'Metro Manila Subway Project', percentage: 30, status: 'Ongoing' },
  { id: 7, name: 'Bataan Nuclear Power Plant Rehabilitation', percentage: 5, status: 'Planning' },
  { id: 9, name: 'Rural Electrification Project', percentage: 20, status: 'No Update' },
])

const filteredProjects = computed(() => {
  if (!searchQuery.value) {
    return myProjects.value
  }
  const query = searchQuery.value.toLowerCase()
  return myProjects.value.filter(project =>
    project.name.toLowerCase().includes(query)
    || project.status.toLowerCase().includes(query),
  )
})

function getStatusClass(status: string) {
  switch (status) {
    case 'Completed':
      return 'bg-green-600'
    case 'Ongoing':
      return 'bg-yellow-600'
    case 'Planning':
      return 'bg-gray-600'
    case 'Near Completion':
      return 'bg-blue-600'
    case 'No Update':
      return 'bg-red-600'
    default:
      return 'bg-gray-500'
  }
}

function getStatusImage(status: string) {
  switch (status) {
    case 'Completed':
      return '/images/doneIcon.png'
    case 'Ongoing':
    case 'Near Completion':
      return '/images/ongoingProject.png'
    case 'Planning':
      return '/images/easter/croc.png'
    case 'No Update':
      return '/images/easter/Ghosty.png'
    default:
      return ''
  }
}

function handleReport(projectId: number, projectName: string) {
  alert(`Reporting on project: ${projectName} (ID: ${projectId})`)
  // In a real application, this would open a report modal or navigate to a report page
}

function viewProjectDetails(projectId: number) {
  router.push({ name: 'ProjectDetails', params: { id: projectId } })
}

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

// Check login status on mount and listen for changes
onMounted(() => {
  authService.getSession().then((session) => {
    isLoggedIn.value = !!session
  })
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session
  })
})
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 flex p-4 pt-16">
      <!-- Burger Icon -->
      <button v-if="isLoggedIn" class="fixed top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 p-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">
          My Projects
        </h1>

        <!-- Search Bar -->
        <div class="mb-8">
          <div class="relative">
            <span class="absolute inset-y-0 left-0 flex items-center pl-4">
              <svg class="w-6 h-6 text-gray-400" viewBox="0 0 24 24" fill="none">
                <path
                  d="M21 21L15 15M17 10C17 13.866 13.866 17 10 17C6.13401 17 3 13.866 3 10C3 6.13401 6.13401 3 10 3C13.866 3 17 6.13401 17 10Z"
                  stroke="currentColor"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </span>
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search your projects..."
              class="w-full py-3 pl-12 pr-4 text-gray-700 bg-white border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm"
            >
          </div>
        </div>

        <!-- Project List -->
        <div v-if="filteredProjects.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div v-for="project in filteredProjects" :key="project.id" class="bg-white p-6 rounded-xl shadow-lg transition-transform duration-300 transform hover:-translate-y-2 hover:shadow-2xl cursor-pointer" @click="viewProjectDetails(project.id)">
            <h3 class="text-lg font-semibold text-gray-900 mb-3">
              {{ project.name }}
            </h3>
            <div class="flex items-center justify-between mb-4">
              <span
                :class="getStatusClass(project.status)"
                class="px-3 py-1 text-xs font-bold text-white rounded-full shadow-md"
              >
                {{ project.status }}
              </span>
              <span class="font-bold text-blue-600 text-lg">{{ project.percentage }}% <span class="text-sm font-normal text-gray-500">Complete</span></span>
            </div>
            <div class="w-full bg-gray-200 rounded-full h-3 mb-4">
              <div
                class="bg-blue-600 h-3 rounded-full"
                :style="{ width: `${project.percentage}%` }"
              />
            </div>
            <div class="flex items-center justify-between mt-4">
              <img v-if="getStatusImage(project.status)" :src="getStatusImage(project.status)" :alt="project.status" class="h-16 w-16 object-contain mr-4">
              <button
                class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-5 rounded-lg transition duration-300 ease-in-out transform hover:scale-105"
                @click.stop="viewProjectDetails(project.id)"
              >
                Details
              </button>
            </div>
          </div>
        </div>
        <div v-else class="text-center text-gray-600 text-lg">
          No projects found matching your search.
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>
