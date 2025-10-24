<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{ reportType: string }>()
const emit = defineEmits(['close'])

const modalContent = computed(() => {
  switch (props.reportType) {
    case 'Ghost Project':
      return {
        image: '/images/easter/Ghosty.png',
        alt: 'Ghost',
        title: 'Ghost Project!? Time to Check Its Spirit Level.',
        message: 'Scary! I wonder which reptile made it into a ghost.',
      }
    case 'Fraud Project':
    case 'Not Finished':
    default:
      return {
        image: '/images/easter/croc.png',
        alt: 'Crocodile',
        title: 'Report Received! Now we can poke around the swamp and see which crocodiles blink first.',
        message: 'Ohh! Crocodile spotted!',
      }
  }
})
</script>

<template>
  <div class="fixed z-50 inset-0 overflow-y-auto">
    <!-- Overlay -->
    <div class="fixed inset-0 transition-opacity" aria-hidden="true" @click="emit('close')">
      <div class="absolute inset-0 bg-gray-500 opacity-75" />
    </div>

    <!-- Modal content container -->
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0 relative z-50">
      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

      <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-sm sm:w-full">
        <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
          <div class="flex justify-center mb-4">
            <img :src="modalContent.image" :alt="modalContent.alt" class="h-48 w-48 object-contain">
          </div>
          <div class="sm:flex sm:items-start">
            <div class="mt-3 text-center sm:mt-0 sm:text-left w-full">
              <h3 id="modal-title" class="text-lg leading-6 font-medium text-gray-900 text-center">
                {{ modalContent.title }}
              </h3>
              <div class="mt-2">
                <p class="text-sm text-gray-500 text-center">
                  {{ modalContent.message }}
                </p>
              </div>
            </div>
          </div>
        </div>
        <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
          <button type="button" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-blue-600 text-base font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 sm:ml-3 sm:w-auto sm:text-sm" @click="emit('close')">
            Close
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
