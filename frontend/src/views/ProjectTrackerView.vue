<script setup lang="ts">
import { computed, defineAsyncComponent, ref } from 'vue'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

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

function handleReport(projectId: number, projectName: string) {
  alert(`Reporting on project: ${projectName} (ID: ${projectId})`)
  // In a real application, this would open a report modal or navigate to a report page
}
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <Header />
    <main class="flex-1 py-16 px-4 bg-gray-50">
      <div class="max-w-6xl mx-auto">
        <h1 class="text-4xl font-bold text-gray-900 text-center mb-12">
          Project Tracker
        </h1>

        <!-- Search Bar -->
        <div class="mb-8">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search projects..."
            class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
        </div>

        <!-- Project Categories -->
        <div v-if="filteredProjects.length > 0" class="space-y-10">
          <div v-for="category in filteredProjects" :key="category.category">
            <h2 class="text-2xl font-semibold text-gray-800 mb-6 border-b pb-2">
              {{ category.category }}
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <div v-for="project in category.items" :key="project.id" class="bg-white p-6 rounded-lg shadow-md">
                <h3 class="text-xl font-bold text-gray-900 mb-2">
                  {{ project.name }}
                </h3>
                <div class="flex items-center justify-between mb-4">
                  <span class="text-gray-600">Progress:</span>
                  <span class="font-semibold text-blue-600">{{ project.percentage }}% Complete</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2.5 mb-4">
                  <div
                    class="bg-blue-600 h-2.5 rounded-full"
                    :style="{ width: `${project.percentage}%` }"
                  />
                </div>
                <div class="flex justify-end">
                  <button
                    class="bg-red-500 hover:bg-red-600 text-white font-bold py-2 px-4 rounded-md transition duration-300"
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
  </div>
</template>
