<script setup lang="ts">
import { ref } from 'vue'

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
  // In a real application, you would upload the file and report details to a server.
  // For now, we'll just log the data to the console.
  alert('Report submitted successfully!')
}
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex flex-col items-center justify-center">
    <div class="max-w-2xl w-full bg-white p-8 rounded-xl shadow-lg">
      <h1 class="text-4xl font-extrabold text-gray-900 mb-4 text-center">
        Report a Project
      </h1>
      <p class="text-lg text-gray-600 mb-6 text-center">
        You are reporting on project: <strong>{{ $route.query.projectName }}</strong> (ID: <strong>{{ $route.query.projectId }}</strong>)
      </p>
      <form @submit.prevent="submitReport">
        <div class="mb-6">
          <label for="report-type" class="block text-lg font-medium text-gray-800 mb-2">Type of Report:</label>
          <select id="report-type" v-model="reportType" class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            <option>Fraud Project</option>
            <option>Ghost Project</option>
            <option>Not Finished</option>
          </select>
        </div>
        <div class="mb-6">
          <label for="report-details" class="block text-lg font-medium text-gray-800 mb-2">Report Details:</label>
          <textarea id="report-details" v-model="reportDetails" rows="6" class="w-full p-4 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Please provide a detailed description of the issue..." />
        </div>
        <div class="mb-6">
          <label for="file-upload" class="block text-lg font-medium text-gray-800 mb-2">Upload Image or Video:</label>
          <input id="file-upload" type="file" accept="image/*,video/*" class="w-full p-2 border border-gray-300 rounded-lg" @change="handleFileUpload">
        </div>
        <div v-if="filePreview" class="mb-6">
          <h3 class="text-lg font-medium text-gray-800 mb-2">
            Preview:
          </h3>
          <img v-if="file?.type.startsWith('image')" :src="filePreview" alt="Image preview" class="max-w-full h-auto rounded-lg shadow-md">
          <video v-else-if="file?.type.startsWith('video')" :src="filePreview" controls class="max-w-full h-auto rounded-lg shadow-md" />
        </div>
        <div class="flex justify-end">
          <router-link to="/project-tracker" class="text-gray-600 hover:text-gray-800 font-medium mr-6 py-3">
            Cancel
          </router-link>
          <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded-lg transition duration-300">
            Submit Report
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
