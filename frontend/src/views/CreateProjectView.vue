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

      <div class="flex-1 p-8">
        <div class="max-w-3xl mx-auto bg-white p-8 rounded-lg shadow-md">
          <h1 class="text-3xl font-bold text-gray-800 mb-6 text-center">Create New Project</h1>
          
          <!-- Progress Indicator -->
          <div class="flex justify-between items-center mb-8">
            <div v-for="stepNum in totalSteps" :key="stepNum" class="flex-1 text-center">
              <div :class="[stepNum <= currentStep ? 'bg-blue-600' : 'bg-gray-300']" class="w-8 h-8 mx-auto rounded-full flex items-center justify-center text-white font-bold">
                {{ stepNum }}
              </div>
              <p :class="[stepNum <= currentStep ? 'text-blue-600' : 'text-gray-500']" class="text-sm mt-1">
                {{ getStepName(stepNum) }}
              </p>
            </div>
          </div>

          <form @submit.prevent="handleSubmit" class="space-y-6">
            <!-- Step 1: Basic Info -->
            <div v-if="currentStep === 1" class="space-y-4 min-h-[200px]">
              <div>
                <label for="project_name" class="block text-sm font-medium text-gray-700">Project Name</label>
                <input type="text" id="project_name" v-model="project_name" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
              <div>
                <label for="project_description" class="block text-sm font-medium text-gray-700">Project Description</label>
                <textarea id="project_description" v-model="project_description" rows="4" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
              </div>
            </div>

            <!-- Step 2: Financials -->
            <div v-if="currentStep === 2" class="space-y-4 min-h-[200px]">
              <div>
                <label for="project_budgetmoney" class="block text-sm font-medium text-gray-700">Budget Money</label>
                <input type="number" id="project_budgetmoney" v-model.number="project_budgetmoney" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
            </div>

            <!-- Step 3: Timeline -->
            <div v-if="currentStep === 3" class="space-y-4 min-h-[200px]">
              <div>
                <label for="project_starting_date" class="block text-sm font-medium text-gray-700">Starting Date</label>
                <input type="date" id="project_starting_date" v-model="project_starting_date" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
              <div>
                <label for="project_estimated_end_date" class="block text-sm font-medium text-gray-700">Estimated End Date</label>
                <input type="date" id="project_estimated_end_date" v-model="project_estimated_end_date" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
            </div>

            <!-- Step 4: Attachments & Importance -->
            <div v-if="currentStep === 4" class="space-y-4 min-h-[200px]">
              <div>
                <label for="project_document" class="block text-sm font-medium text-gray-700">Project Document</label>
                <input type="file" id="project_document" @change="handleFileUpload" class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
              </div>
              <div>
                <label for="importance_level" class="block text-sm font-medium text-gray-700">Importance Level</label>
                <select id="importance_level" v-model="importance_level" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
                  <option value="Low">Low</option>
                  <option value="Medium">Medium</option>
                  <option value="High">High</option>
                  <option value="Critical">Critical</option>
                </select>
              </div>
            </div>

            <!-- Navigation Buttons -->
            <div class="flex justify-between mt-6">
              <button type="button" v-if="currentStep > 1" @click="prevStep" class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                Previous
              </button>
              <button type="button" v-if="currentStep < totalSteps" @click="nextStep" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 ml-auto">
                Next
              </button>
              <button type="submit" v-if="currentStep === totalSteps" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 ml-auto">
                Create Project
              </button>
            </div>
          </form>
        </div>
      </div>
    </main>
    <Footer />
    <ProjectCreatedSuccessModal v-if="showSuccessModal" :project-id="createdProjectId" @close="showSuccessModal = false" @proceed-to-details="handleProjectCreated" />
  </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, onMounted } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import { useRouter } from 'vue-router'
import ProjectCreatedSuccessModal from '@/components/modals/ProjectCreatedSuccessModal.vue'
import { authService } from '@/services/auth' // Import authService

const router = useRouter()
const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const showSuccessModal = ref(false)
const createdProjectId = ref<number | null>(null)
const isLoggedIn = ref(false) // Add isLoggedIn state

// Form fields
const project_name = ref('')
const project_description = ref('')
const project_budgetmoney = ref(0)
const project_starting_date = ref('')
const project_estimated_end_date = ref('')
const project_document = ref<File | null>(null)
const importance_level = ref('Medium')

// Multi-step form logic
const currentStep = ref(1)
const totalSteps = 4

const stepNames = [
  'Basic Info',
  'Financials',
  'Timeline',
  'Attachments & Importance',
]

function getStepName(stepNum: number) {
  return stepNames[stepNum - 1]
}

function nextStep() {
  if (currentStep.value < totalSteps) {
    currentStep.value++
  }
}

function prevStep() {
  if (currentStep.value > 1) {
    currentStep.value--
  }
}

function handleFileUpload(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    project_document.value = target.files[0]
  }
}

function handleSubmit() {
  // Simulate project creation and getting an ID
  const dummyProjectId = Math.floor(Math.random() * 1000) + 100
  createdProjectId.value = dummyProjectId

  // In a real application, you would send this data to a backend API
  showSuccessModal.value = true
  // In a real application, you would send this data to a backend API
}

function handleProjectCreated(projectId: number) {
  showSuccessModal.value = false
  router.push({ name: 'ProjectDetails', params: { id: projectId } })
}

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