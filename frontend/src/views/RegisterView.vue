<script setup lang="ts">
import { computed, defineAsyncComponent, ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const hasTriedSubmit = ref(false)

// Validation
const emailErrorMessage = computed(() => {
  if (email.value.length === 0)
    return 'Email is required'
  const emailRegex = /^[^S@]+@[^S@][^S@.]*\.[^S@]+$/
  if (!emailRegex.test(email.value))
    return 'Please enter a valid email address'
  return ''
})

const passwordErrorMessage = computed(() => {
  if (!password.value)
    return 'Password is required'
  if (password.value.length < 8)
    return 'Password must be at least 8 characters'
  if (!/\d/.test(password.value))
    return 'Password must contain at least 1 number'
  if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>/?]/.test(password.value))
    return 'Password must contain at least 1 special character'
  return ''
})

const confirmPasswordErrorMessage = computed(() => {
  if (!confirmPassword.value)
    return 'Confirm password is required'
  if (confirmPassword.value !== password.value)
    return 'Passwords do not match'
  return ''
})

const shouldShowEmailError = computed(() => hasTriedSubmit.value && !!emailErrorMessage.value)
const shouldShowPasswordError = computed(() => hasTriedSubmit.value && !!passwordErrorMessage.value)
const shouldShowConfirmPasswordError = computed(() => hasTriedSubmit.value && !!confirmPasswordErrorMessage.value)

// Input classes
function inputClass(hasError: boolean) {
  return hasError
    ? 'w-full px-3 py-2 pr-16 rounded focus:outline-none focus:ring-2 border-2 border-red-500 focus:ring-500'
    : 'w-full px-3 py-2 pr-16 rounded focus:outline-none focus:ring-2 border border-gray-300 focus:ring-blue-500'
}

async function handleRegister() {
  hasTriedSubmit.value = true
  if (emailErrorMessage.value || passwordErrorMessage.value || confirmPasswordErrorMessage.value) {
    return // just show validation errors
  }

  // Mock registration success
  alert('Registration successful! Redirecting to login.')
  router.push('/login')
}

function handleGoogleRegister() {
  alert('Google registration initiated (placeholder).')
  // In a real app, this would initiate Google OAuth flow
}
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <!-- Header -->
    <Header />

    <!-- Main Content -->
    <main class="flex-1 flex items-center justify-center p-4 bg-gray-50 pt-16">
      <div
        class="w-full max-w-md bg-white shadow-[0_0_30px_rgba(0,0,0,0.1)] rounded-md flex flex-col items-center p-6 space-y-6"
      >
        <!-- Logo -->
        <div class="w-24 h-24 flex justify-center items-center">
          <img src="/images/logo2.jpg" alt="ACLC Shield" class="object-contain h-full w-full">
        </div>

        <!-- Form -->
        <div class="w-full space-y-4">
          <h2 class="text-lg font-semibold text-gray-800 text-center">
            Register
          </h2>
          <p class="text-sm text-gray-600 text-center">
            Create your account.
          </p>

          <!-- Email -->
          <div>
            <input
              v-model="email"
              type="email"
              placeholder="Enter your email"
              :class="inputClass(shouldShowEmailError)"
              :aria-invalid="shouldShowEmailError"
              aria-describedby="email-error"
            >
            <p
              v-if="shouldShowEmailError"
              id="email-error"
              class="mt-1 text-sm text-red-600"
            >
              {{ emailErrorMessage }}
            </p>
          </div>

          <!-- Password -->
          <div class="relative">
            <input
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              placeholder="Enter password"
              :class="inputClass(shouldShowPasswordError)"
              :aria-invalid="shouldShowPasswordError"
              aria-describedby="password-error"
            >
            <button
              type="button"
              class="absolute right-3 top-1/2 transform -translate-y-1/2 text-sm text-blue-600 hover:underline"
              @click="showPassword = !showPassword"
            >
              {{ showPassword ? 'Hide' : 'Show' }}
            </button>
            <p v-if="shouldShowPasswordError" id="password-error" class="mt-1 text-sm text-red-600">
              {{ passwordErrorMessage }}
            </p>
          </div>

          <!-- Confirm Password -->
          <div class="relative">
            <input
              v-model="confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              placeholder="Confirm password"
              :class="inputClass(shouldShowConfirmPasswordError)"
              :aria-invalid="shouldShowConfirmPasswordError"
              aria-describedby="confirm-password-error"
            >
            <button
              type="button"
              class="absolute right-3 top-1/2 transform -translate-y-1/2 text-sm text-blue-600 hover:underline"
              @click="showConfirmPassword = !showConfirmPassword"
            >
              {{ showConfirmPassword ? 'Hide' : 'Show' }}
            </button>
            <p
              v-if="shouldShowConfirmPasswordError"
              id="confirm-password-error"
              class="mt-1 text-sm text-red-600"
            >
              {{ confirmPasswordErrorMessage }}
            </p>
          </div>

          <!-- Register Button -->
          <button
            class="w-full bg-blue-700 text-white font-bold py-2 rounded hover:bg-blue-800 transition"
            @click="handleRegister"
          >
            Register
          </button>

          <!-- Google Button -->
          <button
            class="w-full flex items-center justify-center bg-red-600 text-white font-bold py-2 rounded hover:bg-red-700 transition"
            @click="handleGoogleRegister"
          >
            <img src="/images/google_logo.png" alt="Google Logo" class="h-5 w-5 mr-2">
            Register with Google
          </button>

          <!-- Back to Login -->
          <div class="text-center">
            <router-link to="/login" class="text-blue-600 hover:underline">
              Already have an account? Login
            </router-link>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <Footer />
  </div>
</template>
