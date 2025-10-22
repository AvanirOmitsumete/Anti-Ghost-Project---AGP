<script setup lang="ts">
import { computed, defineAsyncComponent } from 'vue'
import { RouterView, useRoute } from 'vue-router'
import LoadingSpinner from '@/components/global/LoadingSpinner.vue' // Import LoadingSpinner
import { isLoading } from '@/utils/loadingState' // Import isLoading

const route = useRoute()

const isAdminPage = computed(() => route.path.startsWith('/admin'))

// The isLoading ref is now imported from loadingState.ts
</script>

<template>
  <div id="app" class="">
    <!-- Loading Spinner -->
    <LoadingSpinner v-if="isLoading" />

    <!-- Router View -->
    <RouterView />
  </div>
</template>
