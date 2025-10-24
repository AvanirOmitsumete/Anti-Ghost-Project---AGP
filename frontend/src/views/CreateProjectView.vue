<script setup lang="ts">
import axios from 'axios'
import { User } from 'lucide-vue-next'
import { defineAsyncComponent, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '@/components/global/Sidebar.vue'
import ProjectCreatedSuccessModal from '@/components/modals/ProjectCreatedSuccessModal.vue'
import ValidationModal from '@/components/modals/ValidationModal.vue'
import { authService } from '@/services/auth'

const router = useRouter()
const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const isLoggedIn = ref(false)
const currentStep = ref(1)

// Form fields
const project_name = ref('')
const project_description = ref('')
const project_money = ref(0)
const starting_date = ref('')
const estimated_end_date = ref('')
const project_document = ref<File | null>(null)
const importance_level = ref('Medium')
const created_by = ref('')
const createdProjectId = ref<number | null>(null)

// Modal states
const showValidationModal = ref(false)
const isValidating = ref(false)
const validationTitle = ref('')
const validationMessage = ref('')
const validationResponse = ref<any>(null)
const showSuccessModal = ref(false)

function handleFileUpload(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    project_document.value = target.files[0]
  }
}

async function handlePhase1Submit() {
  const user = await authService.getUser()
  if (user) {
    created_by.value = user.id
  }
  else {
    console.error('User not logged in')
    // Optionally, show an error to the user
    return
  }

  const projectData = {
    project_name: project_name.value,
    project_description: project_description.value,
    project_money: project_money.value,
    starting_date: starting_date.value,
    estimated_end_date: estimated_end_date.value,
    importance_level: importance_level.value,
    user_uuid: created_by.value,
  }

  console.log('Submitting Project Data:', projectData)

  try {
    const response = await axios.post('http://13.229.247.66/webhook/create-project-data', projectData)
    console.log('Project created successfully:', response.data)
    if (response.data && response.data.project_id) {
      createdProjectId.value = response.data.project_id
      currentStep.value = 2 // Move to Phase 2
    }
    else {
      console.error('Project ID not found in response')
    }
  }
  catch (error) {
    console.error('Error creating project:', error.response ? error.response.data : error.message)
  }
}

async function handlePhase2Submit() {
  if (!project_document.value || !createdProjectId.value) {
    console.error('File or Project ID is missing.')
    return
  }

  isValidating.value = true
  showValidationModal.value = true
  validationTitle.value = 'Validating File'
  validationMessage.value = 'Please wait while we validate your file...'
  validationResponse.value = null

  const formData = new FormData()
  formData.append('File', project_document.value)
  formData.append('project_id', createdProjectId.value.toString())

  try {
    const response = await axios.post('http://13.229.247.66/webhook/ai-file-validator', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    })

    validationResponse.value = response.data
    const validationScore = response.data.validation_score // Adjust based on actual API response

    if (validationScore >= 96 && validationScore <= 100) {
      validationTitle.value = 'Validation Successful'
      validationMessage.value = 'Your project has been created successfully!'
      showSuccessModal.value = true // Show success modal
    }
    else {
      validationTitle.value = 'Validation Failed'
      validationMessage.value = 'File validation failed. Please try again with a different file.'
      // User remains on Phase 2 to upload another file
    }
  }
  catch (error) {
    console.error('Error validating file:', error)
    validationTitle.value = 'Validation Error'
    validationMessage.value = 'An error occurred during file validation.'
    validationResponse.value = error
  }
  finally {
    isValidating.value = false
  }
}

function handleProjectCreated() {
  showSuccessModal.value = false
  router.push({ name: 'ProjectDetails', params: { id: createdProjectId.value } })
}

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

onMounted(async () => {
  const session = await authService.getSession()
  isLoggedIn.value = !!session
  authService.onAuthStateChange((_event, session) => {
    isLoggedIn.value = !!session
  })
})
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 flex p-4 pt-16">
      <button v-if="isLoggedIn" class="absolute top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 p-8">
        <div class="max-w-3xl mx-auto bg-white p-8 rounded-lg shadow-md">
          <h1 class="text-3xl font-bold text-gray-800 mb-6 text-center">
            Create New Project
          </h1>

          <!-- Phase 1: Project Details -->
          <form v-if="currentStep === 1" class="space-y-6" @submit.prevent="handlePhase1Submit">
            <div class="space-y-4">
              <div>
                <label for="project_name" class="block text-sm font-medium text-gray-700">Project Name</label>
                <input id="project_name" v-model="project_name" type="text" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
              <div>
                <label for="project_description" class="block text-sm font-medium text-gray-700">Project Description</label>
                <textarea id="project_description" v-model="project_description" rows="4" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500" />
              </div>
              <div>
                <label for="project_money" class="block text-sm font-medium text-gray-700">Budget Money</label>
                <input id="project_money" v-model.number="project_money" type="number" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
              <div>
                <label for="starting_date" class="block text-sm font-medium text-gray-700">Starting Date</label>
                <input id="starting_date" v-model="starting_date" type="date" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
              <div>
                <label for="estimated_end_date" class="block text-sm font-medium text-gray-700">Estimated End Date</label>
                <input id="estimated_end_date" v-model="estimated_end_date" type="date" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
              </div>
              <div>
                <label for="importance_level" class="block text-sm font-medium text-gray-700">Importance Level</label>
                <select id="importance_level" v-model="importance_level" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
                  <option value="Low">
                    Low
                  </option>
                  <option value="Medium">
                    Medium
                  </option>
                  <option value="High">
                    High
                  </option>
                  <option value="Critical">
                    Critical
                  </option>
                </select>
              </div>
            </div>
            <div class="flex justify-end mt-6">
              <button type="submit" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                Next: Upload File
              </button>
            </div>
          </form>

          <!-- Phase 2: File Upload -->
          <form v-if="currentStep === 2" class="space-y-6" @submit.prevent="handlePhase2Submit">
            <div>
              <label for="project_document" class="block text-sm font-medium text-gray-700">Project Document</label>
              <input id="project_document" type="file" class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100" @change="handleFileUpload">
            </div>
            <div class="flex justify-between mt-6">
              <button type="button" class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500" @click="currentStep = 1">
                Back
              </button>
              <button type="submit" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                Submit and Validate
              </button>
            </div>
          </form>
        </div>
      </div>
    </main>
    <Footer />
    <ValidationModal
      v-if="showValidationModal"
      :title="validationTitle"
      :message="validationMessage"
      :validation-response="validationResponse"
      :show-close-button="!isValidating"
      @close="showValidationModal = false"
    />
    <ProjectCreatedSuccessModal v-if="showSuccessModal" :project-id="createdProjectId" @close="showSuccessModal = false" @proceed-to-details="handleProjectCreated" />
  </div>
</template>
