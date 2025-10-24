<template>
  <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center">
    <div class="relative p-5 border w-96 shadow-lg rounded-md bg-white">
      <div class="mt-3 text-center">
        <h3 class="text-lg leading-6 font-medium text-gray-900">{{ title }}</h3>
        <div class="mt-2 px-7 py-3">
          <p class="text-sm text-gray-500">{{ message }}</p>
        </div>
        <div v-if="validationResponse" class="mt-4">
          <h4 class="text-md font-semibold text-gray-800">Validation Response:</h4>
          <pre class="text-left text-sm bg-gray-100 p-2 rounded-md">{{ validationResponse }}</pre>
        </div>
        <div class="items-center px-4 py-3">
          <button
            v-if="showCloseButton"
            @click="$emit('close')"
            class="px-4 py-2 bg-gray-500 text-white text-base font-medium rounded-md w-full shadow-sm hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-300"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';

defineProps<{
  title: string;
  message: string;
  validationResponse: any;
  showCloseButton: boolean;
}>();

defineEmits(['close']);
</script>