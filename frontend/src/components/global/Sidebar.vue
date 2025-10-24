<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '@/services/auth'

const props = defineProps<{ isOpen: boolean }>()
const emit = defineEmits(['close'])
const router = useRouter()

const showMyProjectsDropdown = ref(false)
const showMessagesDropdown = ref(false)
const isLoggedIn = ref(false) // Reactive state for login status

async function checkLoginStatus() {
  try {
    const session = await authService.getSession()
    isLoggedIn.value = !!session
  }
  catch (error) {
    console.error('Error checking login status in sidebar:', error)
    isLoggedIn.value = false
  }
}

function toggleMyProjectsDropdown() {
  showMyProjectsDropdown.value = !showMyProjectsDropdown.value
}

function toggleMessagesDropdown() {
  showMessagesDropdown.value = !showMessagesDropdown.value
}

async function handleLogout() {
  try {
    await authService.signOut()
    isLoggedIn.value = false
    router.push('/login')
    closeSidebar() // Close sidebar after logout
  }
  catch (error) {
    console.error('Error during logout:', error)
  }
}

function closeSidebar() {
  emit('close')
}

onMounted(() => {
  checkLoginStatus()
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session
  })
})
</script>

<template>
  <div :class="isOpen ? 'translate-x-0' : '-translate-x-full'" class="fixed inset-y-0 left-0 w-64 bg-gray-800 text-white p-4 transform transition-transform duration-300 ease-in-out z-40">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-semibold">
        Dashboard Menu
      </h2>
      <button class="text-gray-400 hover:text-white focus:outline-none" @click="closeSidebar">
        <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>
    <nav>
      <ul>
        <li class="mb-2">
          <router-link to="/dashboard" class="block py-2 px-4 rounded hover:bg-gray-700">
            Dashboard
          </router-link>
        </li>
        <li class="mb-2">
          <a href="#" class="block py-2 px-4 rounded hover:bg-gray-700" @click.prevent="toggleMyProjectsDropdown">Projects</a>
          <ul v-if="showMyProjectsDropdown" class="pl-4 mt-1 space-y-1">
            <li>
              <router-link to="/my-projects" class="block py-2 px-4 rounded hover:bg-gray-700">
                My Projects
              </router-link>
            </li>
            <li>
              <router-link to="/create-project" class="block py-2 px-4 rounded hover:bg-gray-700">
                Create Project
              </router-link>
            </li>
          </ul>
        </li>
        <li class="mb-2">
          <router-link to="/user-profile" class="block py-2 px-4 rounded hover:bg-gray-700">
            User Profile
          </router-link>
        </li>
        <li class="mb-2">
          <a href="#" class="block py-2 px-4 rounded hover:bg-gray-700" @click.prevent="toggleMessagesDropdown">Messages</a>
          <ul v-if="showMessagesDropdown" class="pl-4 mt-1 space-y-1">
            <li>
              <router-link to="/authenticate" class="block py-2 px-4 rounded hover:bg-gray-700">
                Authenticate
              </router-link>
            </li>
          </ul>
        </li>

        <li v-if="isLoggedIn" class="mb-2">
          <a href="#" class="block py-2 px-4 rounded hover:bg-gray-700" @click.prevent="handleLogout">
            Logout
          </a>
        </li>
        <li v-else class="mb-2">
          <router-link to="/login" class="block py-2 px-4 rounded hover:bg-gray-700">
            Login
          </router-link>
        </li>
      </ul>
    </nav>
  </div>
</template>
