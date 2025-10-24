<script setup lang="ts">
import { computed, defineAsyncComponent, ref } from 'vue'
import { useRouter } from 'vue-router'
import Toast from '@/components/global/Toast.vue'
import { authService } from '@/services/auth' // Import authService

const router = useRouter()
const toastRef = ref<InstanceType<typeof Toast> | null>(null)

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const email = ref('') // Changed from username to email
const password = ref('')
const rememberMe = ref(false)
const showPassword = ref(false) // Toggle state
const hasTriedSubmit = ref(false)

const formattedEmail = computed({
  get: () => email.value,
  set: (newValue) => {
    email.value = newValue.replace(/\s/g, '').slice(0, 50) // Adjusted length for email
  },
})

const formattedPassword = computed({
  get: () => password.value,
  set: (newValue) => {
    password.value = newValue.replace(/\s/g, '').slice(0, 64)
  },
})

function togglePasswordVisibility() {
  showPassword.value = !showPassword.value
}

// Validation rules/messages for email
const emailErrorMessage = computed<string>(() => {
  if (email.value.length === 0)
    return 'Email is required'
  if (!/^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email.value))
    return 'Please enter a valid email address'
  return ''
})

const passwordErrorMessage = computed<string>(() => {
  if (password.value.length === 0)
    return 'Password is required'
  // Supabase default password policy is 6 characters, but it's good practice to enforce stronger client-side validation
  if (password.value.length < 6)
    return 'Password must be at least 6 characters'
  return ''
})

const isFormValid = computed<boolean>(() => {
  return emailErrorMessage.value === '' && passwordErrorMessage.value === ''
})

// Computed properties for template logic
const shouldShowEmailError = computed<boolean>(() => {
  return (hasTriedSubmit.value && !!emailErrorMessage.value) || (!!email.value && !!emailErrorMessage.value)
})

const shouldShowPasswordError = computed<boolean>(() => {
  return (hasTriedSubmit.value && !!passwordErrorMessage.value) || (!!password.value && !!passwordErrorMessage.value)
})

const emailInputClasses = computed<string>(() => {
  return shouldShowEmailError.value
    ? 'w-full px-3 py-2 rounded focus:outline-none focus:ring-2 border-2 border-red-500 focus:ring-red-500'
    : 'w-full px-3 py-2 rounded focus:outline-none focus:ring-2 border border-gray-300 focus:ring-blue-500'
})

const passwordInputClasses = computed<string>(() => {
  return shouldShowPasswordError.value
    ? 'w-full px-3 py-2 rounded focus:outline-none focus:ring-2 pr-16 border-2 border-red-500 focus:ring-red-500'
    : 'w-full px-3 py-2 rounded focus:outline-none focus:ring-2 pr-16 border border-gray-300 focus:ring-blue-500'
})

async function handleLogin() {
  hasTriedSubmit.value = true
  if (!isFormValid.value) {
    toastRef.value?.triggerToast('Please correct the form errors.', 'error')
    return
  }

  try {
    await authService.signIn(email.value, password.value)
    if (import.meta.env.MODE === 'development') {
      console.warn('Login successful!')
    }
    router.push('/dashboard')
  }
  catch (err: any) {
    console.error('Login error:', err)
    const msg = err.message || 'Login failed. Please check your credentials.'
    toastRef.value?.triggerToast(msg, 'error')
  }
}
</script>

<template>
  <div class="min-h-screen bg-white flex flex-col">
    <!-- Header -->
    <Header />

    <!-- Login Box -->
    <main class="flex-1 flex items-center justify-center p-4 bg-gray-50 pt-16">
      <div class="w-full max-w-md bg-white shadow-[0_0_30px_rgba(0,0,0,0.1)] rounded-md flex flex-col items-center p-6 space-y-6">
        <!-- Logo -->
        <div class="w-40 h-40 flex justify-center items-center">
          <img src="/images/easter/crocs.png" alt="ACLC Shield" class="object-contain h-full w-full">
        </div>

        <!-- Login Form -->
        <div class="w-full space-y-4">
          <!-- Email -->
          <div>
            <input
              v-model="formattedEmail"
              type="email"
              placeholder="Email"
              :class="emailInputClasses"
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

          <!-- Password with toggle -->
          <div>
            <div class="relative">
              <input
                v-model="formattedPassword"
                :type="showPassword ? 'text' : 'password'"
                placeholder="Password"
                :class="passwordInputClasses"
                :aria-invalid="shouldShowPasswordError"
                aria-describedby="password-error"
              >
              <button
                type="button"
                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-sm text-blue-600 hover:underline focus:outline-none"
                @click="togglePasswordVisibility"
              >
                {{ showPassword ? 'Hide' : 'Show' }}
              </button>
            </div>
            <p
              v-if="shouldShowPasswordError"
              id="password-error"
              class="mt-1 text-sm text-red-600"
            >
              {{ passwordErrorMessage }}
            </p>
          </div>

          <!-- Options -->
          <div class="flex items-center justify-between text-sm text-gray-600">
            <label class="flex items-center">
              <input v-model="rememberMe" type="checkbox" class="mr-2">
              Remember me
            </label>
            <router-link to="/forgot-password" class="text-blue-600 hover:underline">
              Forgot password
            </router-link>
          </div>

          <!-- Login Button -->
          <button
            class="w-full bg-blue-700 text-white font-bold py-2 rounded hover:bg-blue-800 transition"
            @click="handleLogin"
          >
            Login
          </button>

          <!-- Don't Have An Account? Register -->
          <div class="text-center text-sm text-gray-600 mt-4">
            Don't have an account?
            <router-link to="/register" class="text-blue-600 hover:underline">
              Register
            </router-link>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <Footer />
    <div>
      <!-- Toast -->
      <Toast ref="toastRef" />
    </div>
  </div>
</template>
