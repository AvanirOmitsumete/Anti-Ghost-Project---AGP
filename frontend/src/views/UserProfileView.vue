<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 flex p-4 pt-16">
      <!-- Burger Icon -->
      <button v-if="isLoggedIn" class="absolute top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 p-8">
        <div class="max-w-2xl mx-auto bg-white p-8 rounded-lg shadow-md">
          <h1 class="text-3xl font-bold text-gray-800 mb-6 text-center">User Profile</h1>

          <div class="space-y-6">
            <!-- Name -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Name</label>
              <p v-if="!isEditing" class="mt-1 text-lg text-gray-900">{{ name }}</p>
              <input v-else type="text" v-model="editableName" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <!-- Email -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Email</label>
              <p v-if="!isEditing" class="mt-1 text-lg text-gray-900">{{ email }}</p>
              <input v-else type="email" v-model="editableEmail" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <!-- Contact Number -->
            <div>
              <label class="block text-sm font-medium text-gray-700">Contact Number</label>
              <p v-if="!isEditing" class="mt-1 text-lg text-gray-900">{{ contactNumber }}</p>
              <input v-else type="tel" v-model="editableContactNumber" class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
            </div>

            <!-- Action Buttons -->
            <div class="flex justify-end space-x-4 mt-6">
              <button v-if="!isEditing" @click="startEditing" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                Edit Profile
              </button>
              <template v-else>
                <button @click="cancelEditing" class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500">
                  Cancel
                </button>
                <button @click="saveChanges" class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                  Save Changes
                </button>
              </template>
            </div>
          </div>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, onMounted } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import { authService } from '@/services/auth' // Import authService

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const isEditing = ref(false)
const isLoggedIn = ref(false) // Add isLoggedIn state

// Dummy User Data
const name = ref('John Doe')
const email = ref('john.doe@example.com')
const contactNumber = ref('123-456-7890')

// Editable fields (for when in editing mode)
const editableName = ref('')
const editableEmail = ref('')
const editableContactNumber = ref('')

function startEditing() {
  editableName.value = name.value
  editableEmail.value = email.value
  editableContactNumber.value = contactNumber.value
  isEditing.value = true
}

function saveChanges() {
  // In a real application, you would send these changes to a backend API
  name.value = editableName.value
  email.value = editableEmail.value
  contactNumber.value = editableContactNumber.value
  isEditing.value = false
  alert('Profile updated successfully!')
}

function cancelEditing() {
  isEditing.value = false
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