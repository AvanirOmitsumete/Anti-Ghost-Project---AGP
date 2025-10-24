<script setup lang="ts">
import { computed, defineAsyncComponent, ref, onMounted } from 'vue'
import ReportModal from '@/components/modals/ReportModal.vue'
import SubmissionSuccessModal from '@/components/modals/SubmissionSuccessModal.vue'
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

const showReportModal = ref(false)
const showSuccessModal = ref(false)
const submittedReportType = ref('')
const selectedProject = ref<{ id: number, name: string } | null>(null)

const searchQuery = ref('')

// Dummy project data
const projects = ref([
  {
    category: 'Water Resources & Flood Control',
    items: [
      { id: 1, name: 'New Centennial Source - Kaliwa Dam Project', percentage: 75, status: 'Ongoing' },
      { id: 2, name: 'Pasig-Marikina River Flood Control Project', percentage: 90, status: 'Near Completion' },
      { id: 3, name: 'Angat Dam Rehabilitation', percentage: 50, status: 'Ongoing' },
    ],
  },
  {
    category: 'Transportation Infrastructure',
    items: [
      { id: 4, name: 'Metro Manila Subway Project', percentage: 30, status: 'Ongoing' },
      { id: 5, name: 'North-South Commuter Railway', percentage: 60, status: 'Ongoing' },
      { id: 6, name: 'Cebu-Cordova Link Expressway', percentage: 100, status: 'Completed' },
    ],
  },
  {
    category: 'Energy Development',
    items: [
      { id: 7, name: 'Bataan Nuclear Power Plant Rehabilitation', percentage: 5, status: 'Planning' },
      { id: 8, name: 'Solar Farm Expansion Project', percentage: 40, status: 'Ongoing' },
      { id: 9, name: 'Rural Electrification Project', percentage: 20, status: 'No Update' },
    ],
  },
])

const filteredProjects = computed(() => {
  if (!searchQuery.value) {
    return projects.value
  }
  const query = searchQuery.value.toLowerCase()
  return projects.value
    .map(category => ({
      ...category,
      items: category.items.filter(project =>
        project.name.toLowerCase().includes(query)
        || project.status.toLowerCase().includes(query)
        || category.category.toLowerCase().includes(query),
      ),
    }))
    .filter(category => category.items.length > 0)
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
      return '/images/easter/croc.png' // Assuming 'image.png' is a suitable placeholder for planning
    case 'No Update':
      return '/images/easter/Ghosty.png' // Placeholder for No Update
    default:
      return '' // No image for unknown status
  }
}

function handleReport(projectId: number, projectName: string) {
  selectedProject.value = { id: projectId, name: projectName }
  showReportModal.value = true
}

function handleReportSubmitted(reportType: string) {
  showReportModal.value = false
  submittedReportType.value = reportType
  showSuccessModal.value = true
}
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 py-16 px-4 bg-gray-100 pt-16">
      <button v-if="isLoggedIn" class="absolute top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />
      <div class="max-w-6xl mx-auto">
        <h1 class="text-5xl font-extrabold text-gray-900 text-center mb-4 tracking-tight">
          Project Tracker
        </h1>
        <p class="text-center text-lg text-gray-600 mb-12">
          Monitor the progress of various government projects.
        </p>

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
              placeholder="Search projects..."
              class="w-full py-3 pl-12 pr-4 text-gray-700 bg-white border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500 shadow-sm"
            >
          </div>
        </div>

        <!-- Project Categories -->
        <div v-if="filteredProjects.length > 0" class="space-y-10">
          <div v-for="category in filteredProjects" :key="category.category">
            <h2 class="text-3xl font-bold text-gray-800 mb-6">
              {{ category.category }}
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <div v-for="project in category.items" :key="project.id" class="bg-white p-6 rounded-xl shadow-lg transition-transform duration-300 transform hover:-translate-y-2 hover:shadow-2xl">
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
                    @click="handleReport(project.id, project.name)"
                  >
                    Report
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div v-else class="text-center text-gray-600 text-lg">
          No projects found matching your search.
        </div>
      </div>
    </main>
    <Footer />
    <ReportModal v-if="showReportModal" :project="selectedProject" @close="showReportModal = false" @report-submitted="handleReportSubmitted" />
    <SubmissionSuccessModal v-if="showSuccessModal" :report-type="submittedReportType" @close="showSuccessModal = false" />
  </div>
</template>
