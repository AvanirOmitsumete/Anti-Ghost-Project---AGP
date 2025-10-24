<script setup lang="ts">
import { ref } from 'vue'

const props = defineProps<{ project: { id: number, name: string } | null }>()
const emit = defineEmits(['close'])

const reportType = ref('Fraud Project')
const reportDetails = ref('')
const file = ref<File | null>(null)
const filePreview = ref<string | null>(null)

function handleFileUpload(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    const selectedFile = target.files[0]
    if (selectedFile.size > 24 * 1024 * 1024) { // 24MB in bytes
      alert('File size exceeds 24MB. Please choose a smaller file.')
      target.value = '' // Reset the file input
      return
    }
    file.value = selectedFile
    const reader = new FileReader()
    reader.onload = (e) => {
      filePreview.value = e.target?.result as string
    }
    reader.readAsDataURL(file.value)
  }
}

function submitReport() {
  if (!reportDetails.value.trim() && !file.value) {
    alert('Please provide report details or upload a file.')
    return
  }
  // In a real application, you would upload the file and report details to a server.
  // For now, we'll just log the data to the console.
  console.log('Project ID:', props.project?.id)
  console.log('Project Name:', props.project?.name)
  console.log('Report Type:', reportType.value)
  console.log('Report Details:', reportDetails.value)
  console.log('File:', file.value)
  emit('reportSubmitted', reportType.value)
  emit('close')
}
</script>

<template>
  <div class="fixed z-50 inset-0 overflow-y-auto">
    <!-- Overlay -->
    <div class="fixed inset-0 transition-opacity" aria-hidden="true" @click="emit('close')">
      <div class="absolute inset-0 bg-gray-500 opacity-75" />
    </div>

    <!-- Modal content container -->
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0 relative z-50">
      <!-- This element is to trick the browser into centering the modal contents. -->
      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

      <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
        <form @submit.prevent="submitReport">
          <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <h1 class="text-2xl font-bold text-gray-900 mb-4">
              Report a Project
            </h1>
            <p class="text-sm text-gray-600 mb-6">
              You are reporting on project: <strong>{{ project?.name }}</strong> (ID: <strong>{{ project?.id }}</strong>)
            </p>
            <div class="mb-4">
              <label for="report-type" class="block text-sm font-medium text-gray-700 mb-1">Type of Report:</label>
              <select id="report-type" v-model="reportType" class="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option>Fraud Project</option>
                <option>Ghost Project</option>
              </select>
            </div>
            <div class="mb-4">
              <label for="report-details" class="block text-sm font-medium text-gray-700 mb-1">Report Details:</label>
              <textarea id="report-details" v-model="reportDetails" rows="4" class="w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Please provide a detailed description of the issue..." />
            </div>
            <div class="mb-4">
              <label for="file-upload" class="block text-sm font-medium text-gray-700 mb-1">Upload Image or Video:</label>
              <input id="file-upload" type="file" accept="image/*,video/*" class="w-full p-1 border border-gray-300 rounded-md" @change="handleFileUpload">
            </div>
            <div v-if="filePreview" class="mb-4">
              <h3 class="text-sm font-medium text-gray-700 mb-1">
                Preview:
              </h3>
              <img v-if="file?.type.startsWith('image')" :src="filePreview" alt="Image preview" class="max-w-full h-auto rounded-md shadow-sm">
              <video v-else-if="file?.type.startsWith('video')" :src="filePreview" controls class="max-w-full h-auto rounded-md shadow-sm" />
            </div>
          </div>
          <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
            <button type="submit" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm">
              Submit Report
            </button>
            <button type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm" @click="emit('close')">
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
