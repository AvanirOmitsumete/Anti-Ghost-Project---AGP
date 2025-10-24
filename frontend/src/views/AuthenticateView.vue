<script setup lang="ts">
import { computed, defineAsyncComponent, onMounted, ref, watch } from 'vue'
import LoadingSpinner from '@/components/global/LoadingSpinner.vue'
import Sidebar from '@/components/global/Sidebar.vue'

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const allUpdates = ref<UpdateForAuthentication[]>([]) // Store all fetched updates
const currentUpdateIndex = ref(0) // This will now track the index in filteredAndSortedUpdates
const isLoading = ref(true)
const error = ref<string | null>(null)

const showConfirmationModal = ref(false)
const modalAction = ref<'authentic' | 'fraud' | null>(null)
const searchQuery = ref<string>('')
const dateFilter = ref<string>('all') // 'all', 'today', 'lastWeek', 'lastMonth'
const selectedUpdateId = ref<number | null>(null) // New: Tracks the ID of the expanded update

// Predefined Tailwind colors for project cards
const projectColors = [
  'bg-blue-100',
  'bg-green-100',
  'bg-yellow-100',
  'bg-purple-100',
  'bg-pink-100',
  'bg-indigo-100',
  'bg-red-100',
  'bg-teal-100',
  'bg-orange-100',
  'bg-cyan-100',
]

// Map to store project name to color mapping
const projectColorMap = new Map<string, string>()
let colorIndex = 0

function getProjectColor(projectName: string): string {
  if (!projectColorMap.has(projectName)) {
    projectColorMap.set(projectName, projectColors[colorIndex % projectColors.length])
    colorIndex++
  }
  return projectColorMap.get(projectName) || 'bg-gray-100' // Fallback
}

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

interface UpdateForAuthentication {
  id: number
  projectId: number
  projectName: string
  submitterName: string
  submissionDate: string
  message: string
  category: string // Added category
  media?: { type: 'image' | 'video' | 'file', url: string, filename?: string }[]
}

const filteredAndSortedUpdates = computed(() => {
  let filtered = allUpdates.value

  // Apply date filter
  const now = new Date()
  now.setHours(0, 0, 0, 0) // Normalize 'now' to start of today

  if (dateFilter.value === 'today') {
    filtered = filtered.filter((update) => {
      const updateDate = new Date(update.submissionDate)
      updateDate.setHours(0, 0, 0, 0)
      return updateDate.getTime() === now.getTime()
    })
  }
  else if (dateFilter.value === 'lastWeek') {
    const lastWeek = new Date(now)
    lastWeek.setDate(now.getDate() - 7)
    filtered = filtered.filter((update) => {
      const updateDate = new Date(update.submissionDate)
      return updateDate >= lastWeek && updateDate <= now
    })
  }
  else if (dateFilter.value === 'lastMonth') {
    const lastMonth = new Date(now)
    lastMonth.setMonth(now.getMonth() - 1)
    filtered = filtered.filter((update) => {
      const updateDate = new Date(update.submissionDate)
      return updateDate >= lastMonth && updateDate <= now
    })
  }

  // Apply search query filter
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(update =>
      update.projectName.toLowerCase().includes(query)
      || update.category.toLowerCase().includes(query)
      || update.message.toLowerCase().includes(query),
    )
  }

  // Sort by category, then project name, then submission date (latest first)
  return filtered.sort((a, b) => {
    const categoryCompare = a.category.localeCompare(b.category)
    if (categoryCompare !== 0)
      return categoryCompare

    const projectCompare = a.projectName.localeCompare(b.projectName)
    if (projectCompare !== 0)
      return projectCompare

    return new Date(b.submissionDate).getTime() - new Date(a.submissionDate).getTime()
  })
})

// New computed property to group updates by project name
const groupedUpdatesByProject = computed(() => {
  const grouped: { [key: string]: UpdateForAuthentication[] } = {}
  filteredAndSortedUpdates.value.forEach((update) => {
    if (!grouped[update.projectName]) {
      grouped[update.projectName] = []
    }
    grouped[update.projectName].push(update)
  })
  return grouped
})

const selectedUpdate = computed(() => {
  if (selectedUpdateId.value === null)
    return null
  // Find the selected update within the entire allUpdates array, not just filtered
  return allUpdates.value.find(update => update.id === selectedUpdateId.value)
})

async function fetchUpdatesForAuthentication() {
  isLoading.value = true
  error.value = null
  try {
    await new Promise(resolve => setTimeout(resolve, 1000))
    const today = new Date()
    const yesterday = new Date(today)
    yesterday.setDate(today.getDate() - 1)
    const twoDaysAgo = new Date(today)
    twoDaysAgo.setDate(today.getDate() - 2)
    const lastWeek = new Date(today)
    lastWeek.setDate(today.getDate() - 6)
    const twoWeeksAgo = new Date(today)
    twoWeeksAgo.setDate(today.getDate() - 14)
    const lastMonth = new Date(today)
    lastMonth.setDate(today.getDate() - 25)

    allUpdates.value = [
      {
        id: 1,
        projectId: 101,
        projectName: 'Coastal Defense System',
        submitterName: 'Alice Smith',
        submissionDate: today.toISOString(),
        message: 'Submitted progress photos for Phase 2 construction. All according to plan.',
        category: 'Infrastructure',
        media: [
          { type: 'image', url: '/images/airport.png' },
          { type: 'image', url: '/images/Cavite.png' },
        ],
      },
      {
        id: 2,
        projectId: 102,
        projectName: 'Urban Renewal Initiative',
        submitterName: 'Bob Johnson',
        submissionDate: yesterday.toISOString(),
        message: 'Video footage of the new park area. Looks like some unauthorized construction is happening.',
        category: 'Urban Development',
        media: [
          { type: 'video', url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4' },
        ],
      },
      {
        id: 3,
        projectId: 103,
        projectName: 'Public Transport Upgrade',
        submitterName: 'Charlie Brown',
        submissionDate: twoDaysAgo.toISOString(),
        message: 'Attached financial report for Q3. Everything seems in order.',
        category: 'Infrastructure',
        media: [
          { type: 'file', url: 'https://www.africau.edu/images/default/sample.pdf', filename: 'Q3_Financial_Report.pdf' },
        ],
      },
      {
        id: 4,
        projectId: 104,
        projectName: 'Water Security Pipeline',
        submitterName: 'Diana Prince',
        submissionDate: lastWeek.toISOString(),
        message: 'New images of the pipeline installation. Progress is slow due to unforeseen ground conditions.',
        category: 'Utilities',
        media: [
          { type: 'image', url: '/images/cordovab.png' },
        ],
      },
      {
        id: 5,
        projectId: 101,
        projectName: 'Coastal Defense System',
        submitterName: 'Alice Smith',
        submissionDate: twoWeeksAgo.toISOString(),
        message: 'Initial site survey completed for Phase 3. No major issues identified.',
        category: 'Infrastructure',
        media: [],
      },
      {
        id: 6,
        projectId: 105,
        projectName: 'Green Space Development',
        submitterName: 'Eve Adams',
        submissionDate: today.toISOString(),
        message: 'New planting schedule submitted. Expecting delivery of saplings next week.',
        category: 'Urban Development',
        media: [
          { type: 'image', url: '/images/image.png' },
        ],
      },
      {
        id: 7,
        projectId: 106,
        projectName: 'Community Health Program',
        submitterName: 'Frank Green',
        submissionDate: lastMonth.toISOString(),
        message: 'Report on community outreach activities for the past month.',
        category: 'Social Services',
        media: [],
      },
    ]
  }
  catch (err) {
    console.error('Failed to fetch updates for authentication:', err)
    error.value = 'Failed to load updates. Please try again later.'
  }
  finally {
    isLoading.value = false
  }
}

function selectUpdate(id: number) {
  selectedUpdateId.value = id
}

function prepareConfirmation(action: 'authentic' | 'fraud') {
  modalAction.value = action
  showConfirmationModal.value = true
}

async function confirmAction() {
  if (!selectedUpdate.value || !modalAction.value)
    return

  const updateId = selectedUpdate.value.id
  const action = modalAction.value

  // Simulate API call to mark update
  await new Promise(resolve => setTimeout(resolve, 500))

  // Remove the authenticated/fraudulent update from the allUpdates list
  allUpdates.value = allUpdates.value.filter(update => update.id !== updateId)

  // After confirming, close the expanded view
  selectedUpdateId.value = null

  showConfirmationModal.value = false
  modalAction.value = null

  // Reset currentUpdateIndex if it's out of bounds after removal
  if (currentUpdateIndex.value >= filteredAndSortedUpdates.value.length && filteredAndSortedUpdates.value.length > 0) {
    currentUpdateIndex.value = filteredAndSortedUpdates.value.length - 1
  }
  else if (filteredAndSortedUpdates.value.length === 0) {
    currentUpdateIndex.value = 0 // No updates left
  }
}

function cancelAction() {
  showConfirmationModal.value = false
  modalAction.value = null
}

// Watch for changes in filteredAndSortedUpdates to reset currentUpdateIndex and selectedUpdateId
watch(filteredAndSortedUpdates, (newVal) => {
  // If the currently selected update is filtered out, reset selection
  if (selectedUpdateId.value !== null && !newVal.some(update => update.id === selectedUpdateId.value)) {
    selectedUpdateId.value = null
  }
  // Do NOT automatically select the first update
}, { immediate: true }) // immediate: true to run on initial load

onMounted(() => {
  fetchUpdatesForAuthentication()
})
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 flex p-4 pt-16">
      <!-- Burger Icon -->
      <button class="fixed top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

      <Sidebar :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 p-8 bg-gray-100 text-gray-900 transition-colors duration-300">
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold">
            Authenticate Project Updates
          </h1>
        </div>

        <!-- Search Input -->
        <div class="mb-4">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search by project name or category..."
            class="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 ease-in-out"
          >
        </div>

        <!-- Date Filter Buttons -->
        <div class="flex space-x-2 mb-8">
          <button
            :class="{ 'bg-blue-600 text-white': dateFilter === 'all', 'bg-gray-200 text-gray-800': dateFilter !== 'all' }"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
            @click="dateFilter = 'all'"
          >
            All Updates
          </button>
          <button
            :class="{ 'bg-blue-600 text-white': dateFilter === 'today', 'bg-gray-200 text-gray-800': dateFilter !== 'today' }"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
            @click="dateFilter = 'today'"
          >
            Today Only
          </button>
          <button
            :class="{ 'bg-blue-600 text-white': dateFilter === 'lastWeek', 'bg-gray-200 text-gray-800': dateFilter !== 'lastWeek' }"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
            @click="dateFilter = 'lastWeek'"
          >
            Last Week
          </button>
          <button
            :class="{ 'bg-blue-600 text-white': dateFilter === 'lastMonth', 'bg-gray-200 text-gray-800': dateFilter !== 'lastMonth' }"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
            @click="dateFilter = 'lastMonth'"
          >
            Last Month
          </button>
        </div>

        <div v-if="isLoading" class="flex justify-center items-center h-64">
          <LoadingSpinner />
        </div>

        <div v-else-if="error" class="text-red-600 text-center text-lg">
          {{ error }}
        </div>

        <div v-else-if="Object.keys(groupedUpdatesByProject).length === 0" class="text-gray-600 text-center text-lg py-10">
          No updates awaiting authentication matching "<span class="font-semibold">{{ searchQuery }}</span>" with the selected filter.
        </div>

        <div v-else class="space-y-8">
          <div
            v-for="(projectUpdates, projectName) in groupedUpdatesByProject" :key="projectName"
            class="p-6 rounded-lg shadow-lg border border-gray-200" :class="[getProjectColor(projectName)]"
          >
            <h2 class="text-2xl font-bold text-gray-800 mb-5 border-b pb-3 border-gray-200">
              {{ projectName }}
            </h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Summary Cards -->
              <div
                v-for="update in projectUpdates" :key="update.id"
                :class="{
                  'ring-2 ring-blue-500 ring-offset-2': selectedUpdateId === update.id,
                  'bg-gray-50 shadow-md hover:shadow-lg': selectedUpdateId !== update.id,
                }"
                class="p-5 rounded-lg border border-gray-200 cursor-pointer transition-all duration-300 ease-in-out transform hover:scale-102"
                @click="selectUpdate(update.id)"
              >
                <p class="text-sm text-gray-700 mb-1">
                  {{ update.category }}
                </p>
                <h3 class="text-lg font-semibold text-gray-900 mb-1">
                  {{ update.projectName }}
                </h3>
                <p class="text-gray-800 text-sm line-clamp-2">
                  {{ update.message }}
                </p>
                <p class="text-xs text-gray-600 mt-2">
                  Submitted by: {{ update.submitterName }} on {{ new Date(update.submissionDate).toLocaleDateString() }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Expanded Update View (Modal-like or inline expansion) -->
        <Transition name="fade">
          <div v-if="selectedUpdate" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-40 p-4">
            <div class="bg-white p-8 rounded-lg shadow-xl max-w-3xl w-full relative overflow-y-auto max-h-[90vh]">
              <button class="absolute top-4 right-4 text-gray-600 hover:text-gray-900 text-2xl font-bold" @click="selectedUpdateId = null">
                &times;
              </button>
              <p class="text-sm text-gray-500 mb-2">
                Category: <span class="font-semibold">{{ selectedUpdate.category }}</span>
              </p>
              <h2 class="text-2xl font-bold text-gray-800 mb-4">
                Project: {{ selectedUpdate.projectName }}
              </h2>
              <p class="text-gray-700 mb-2">
                Submitted by: <span class="font-semibold">{{ selectedUpdate.submitterName }}</span> on {{ new Date(selectedUpdate.submissionDate).toLocaleString() }}
              </p>
              <p class="text-gray-800 mb-4">
                {{ selectedUpdate.message }}
              </p>

              <div v-if="selectedUpdate.media && selectedUpdate.media.length" class="mb-4 grid grid-cols-1 md:grid-cols-2 gap-4">
                <div v-for="(mediaItem, index) in selectedUpdate.media" :key="index" class="border p-2 rounded-md bg-gray-50">
                  <img v-if="mediaItem.type === 'image'" :src="mediaItem.url" alt="Update media" class="max-w-full h-auto rounded-md">
                  <video v-else-if="mediaItem.type === 'video'" :src="mediaItem.url" controls class="max-w-full h-auto rounded-md" />
                  <a v-else :href="mediaItem.url" target="_blank" class="text-blue-600 hover:underline">
                    Download: {{ mediaItem.filename || 'File' }}
                  </a>
                </div>
              </div>

              <div class="flex justify-center space-x-4 mt-6">
                <button
                  class="px-6 py-3 bg-green-600 text-white font-bold rounded-md shadow-md hover:bg-green-700 transition duration-200 ease-in-out"
                  @click="prepareConfirmation('authentic')"
                >
                  Authentic
                </button>
                <button
                  class="px-6 py-3 bg-red-600 text-white font-bold rounded-md shadow-md hover:bg-red-700 transition duration-200 ease-in-out"
                  @click="prepareConfirmation('fraud')"
                >
                  Fraud
                </button>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </main>
    <Footer />

    <!-- Confirmation Modal -->
    <div v-if="showConfirmationModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white p-8 rounded-lg shadow-xl max-w-sm w-full text-center">
        <img src="/public/images/easter/Ghosty.png" alt="Ghosty" class="mx-auto mb-4 w-24 h-24">
        <p class="text-lg font-semibold mb-4 text-gray-900">
          Are you sure? Ohh I see scales on you, ehh nevermind.
        </p>
        <div class="flex justify-center space-x-4">
          <button
            :class="modalAction === 'authentic' ? 'bg-green-600 hover:bg-green-700' : 'bg-red-600 hover:bg-red-700'"
            class="px-5 py-2 text-white rounded-md font-medium transition duration-200 ease-in-out"
            @click="confirmAction"
          >
            Yes, I'm sure
          </button>
          <button
            class="px-5 py-2 bg-gray-300 text-gray-800 rounded-md font-medium hover:bg-gray-400 transition duration-200 ease-in-out"
            @click="cancelAction"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
