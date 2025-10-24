<script setup lang="ts">
import { defineEmits, defineProps } from 'vue'

defineProps<{
  projectId: number | null
}>()

defineEmits(['close', 'proceed-to-details'])
</script>

<template>
  <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center">
    <div class="relative p-5 border w-96 shadow-lg rounded-md bg-white">
      <div class="mt-3 text-center">
        <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100">
          <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h3 class="text-lg leading-6 font-medium text-gray-900 mt-4">
          Project Created Successfully!
        </h3>
        <div class="mt-2 px-7 py-3">
          <p class="text-sm text-gray-500">
            Your project with ID: <strong>{{ projectId }}</strong> has been created.
          </p>
        </div>
        <div class="items-center px-4 py-3 space-x-4">
          <button
            class="px-4 py-2 bg-gray-500 text-white text-base font-medium rounded-md shadow-sm hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-300"
            @click="$emit('close')"
          >
            Close
          </button>
          <button
            class="px-4 py-2 bg-blue-600 text-white text-base font-medium rounded-md shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300"
            @click="$emit('proceed-to-details', projectId)"
          >
            View Project Details
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
