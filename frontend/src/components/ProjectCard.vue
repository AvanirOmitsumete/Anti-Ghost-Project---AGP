<script setup lang="ts">
import { defineProps } from 'vue'

const props = defineProps({
  project: {
    type: Object,
    required: true,
    validator: (value: any) => {
      return (
        typeof value.id === 'number'
        && typeof value.name === 'string'
        && typeof value.percentage === 'number'
        && typeof value.status === 'string' // Added status validation
      )
    },
  },
})

// Emit event for reporting
const emit = defineEmits(['report'])

function handleReportClick() {
  emit('report', props.project.id, props.project.name)
}

// Computed property for status icon
function statusIcon(status: string) {
  if (status.toLowerCase().includes('ongoing') || status.toLowerCase().includes('active')) {
    return 'https://via.placeholder.com/24/00FF00/FFFFFF?text=ON' // Green for ongoing/active
  }
  else if (status.toLowerCase().includes('inactive') || status.toLowerCase().includes('planning')) {
    return 'https://via.placeholder.com/24/FF0000/FFFFFF?text=IN' // Red for inactive/planning
  }
  else {
    return 'https://via.placeholder.com/24/CCCCCC/000000?text=?' // Default/unknown
  }
}
</script>

<template>
  <div
    class="bg-white p-7 rounded-xl shadow-lg transition-all duration-300 ease-in-out transform hover:shadow-xl hover:bg-blue-50 hover:scale-110 hover:-translate-y-4 cursor-pointer relative" <!-- Added relative --
  >
    >
    <h3 class="text-xl font-semibold text-gray-900 mb-3">
      {{ project.name }}
    </h3>
    <div class="flex items-center justify-between mb-4 text-lg">
      <span class="text-gray-700">Progress:</span>
      <span class="font-bold text-blue-700">{{ project.percentage }}% Complete</span>
    </div>
    <div class="w-full bg-gray-200 rounded-full h-3 mb-5">
      <div
        class="bg-blue-600 h-3 rounded-full transition-all duration-500 ease-out"
        :style="{ width: `${project.percentage}%` }"
      />
    </div>
    <div class="flex justify-end">
      <button
        class="bg-red-600 hover:bg-red-700 text-white font-bold py-2.5 px-5 rounded-lg transition duration-300 text-base"
        @click="handleReportClick"
      >
        Report
      </button>
    </div>

    <!-- Status Icon -->
    <img
      :src="statusIcon(project.status)"
      :alt="project.status"
      class="absolute bottom-3 left-3 w-6 h-6" <!-- Positioned bottom-left --
    >
    >
  </div>
</template>
