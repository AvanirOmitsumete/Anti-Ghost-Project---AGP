<script setup lang="ts">
import { computed, defineProps, onMounted, onUnmounted, ref } from 'vue'
import { useRouter } from 'vue-router' // Import useRouter

const props = defineProps({
  images: {
    type: Array as () => string[],
    required: true,
  },
})

const router = useRouter() // Initialize router

const currentIndex = ref(0)
const isTransitioning = ref(true) // Control CSS transition
let carouselInterval: number | undefined

// Create a display array with the first image duplicated at the end for smooth looping
const displayImages = computed(() => {
  if (props.images.length > 0) {
    return [...props.images, props.images[0]]
  }
  return []
})

function nextImage() {
  currentIndex.value++

  if (currentIndex.value === displayImages.value.length - 1) {
    // If we are at the duplicated first image
    isTransitioning.value = true // Ensure transition is on for the last slide
    setTimeout(() => {
      isTransitioning.value = false // Disable transition for instant jump
      currentIndex.value = 0 // Jump to the real first image
      // Re-enable transition after a very short delay to ensure it's off for the jump
      setTimeout(() => {
        isTransitioning.value = true
      }, 50)
    }, 700) // Match this with the CSS transition duration
  }
  else if (currentIndex.value >= displayImages.value.length) {
    // This case should ideally not be hit with the above logic, but as a fallback
    currentIndex.value = 0
  }
}

onMounted(() => {
  carouselInterval = setInterval(nextImage, 5000) // Change image every 5 seconds
})

onUnmounted(() => {
  if (carouselInterval) {
    clearInterval(carouselInterval)
  }
})

function handleRegisterClick() {
  router.push('/register') // Redirect immediately
}
</script>

<template>
  <div class="relative w-full overflow-hidden h-[calc(100vh-2rem)]">
    <!-- "Register" text without animation -->
    <div class="absolute inset-y-0 left-0 w-1/3 flex flex-col items-center justify-center z-10">
      <!-- Top Rectangle -->
      <div class="w-full h-8 bg-transparent mb-2" />

      <!-- Central Rectangle (Register Button) -->
      <button
        class="relative w-full h-16 bg-transparent flex items-center justify-start pl-4 text-gray-800 text-3xl font-bold focus:outline-none"
        style="clip-path: polygon(0 0, 100% 50%, 0 100%);"
        @click="handleRegisterClick"
      >
        <span>Register</span>
      </button>

      <!-- Bottom Rectangle -->
      <div class="w-full h-8 bg-transparent mt-2" />
    </div>

    <div
      :class="{ 'transition-transform duration-700 ease-in-out': isTransitioning, 'transition-none': !isTransitioning }"
      class="flex h-full"
      :style="{ transform: `translateX(-${currentIndex * 100}%)` }"
    >
      <img
        v-for="(image, index) in displayImages"
        :key="index"
        :src="image"
        alt="Carousel Image"
        class="w-full flex-shrink-0 object-cover"
      >
    </div>
  </div>
</template>
