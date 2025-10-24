<script setup lang="ts">
import { defineAsyncComponent, onMounted, ref } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import { authService } from '@/services/auth' // Import authService

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const isLoggedIn = ref(false) // Add isLoggedIn state

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

// Dummy Data for Dashboard
const projectsInvolved = ref(12)
const pointsEarned = ref(2500)
const rewardsPoints = ref(1500)
const totalBudget = ref('$1,200,000')
const projectsCompletedQuarter = ref(5)
const urgentAlerts = ref([
  'Project Alpha deadline in 2 days.',
  'Budget review for Project Beta overdue.',
  'New task assigned in Project Gamma.',
])

const notifications = ref([
  { id: 1, message: 'Your report for Project X has been reviewed.', read: false },
  { id: 2, message: 'New message from admin regarding Project Y.', read: true },
  { id: 3, message: 'Project Z milestone achieved!', read: false },
])

// New Dummy Data for Urgent Alerts and Integrity Focus
const integrityReviewQueue = ref(3) // Example: 3 new fraud/ghost reports
const projectsAtRisk = ref(2) // Example: 2 projects at risk
const criticalMilestonesMissed = ref(1) // Example: 1 missed milestone
const upcomingDeadlines = ref([
  { id: 1, project: 'Project Delta', date: '2025-11-01' },
  { id: 2, project: 'Project Epsilon', date: '2025-11-05' },
  { id: 3, project: 'Project Zeta', date: '2025-11-07' },
])

// New Dummy Data for Global Project Health & Key Financials
const totalBudgetAllocated = ref('$5,000,000')
const budgetBurnRate = ref({ spent: 70, remaining: 30 }) // Percentage
const budgetVariance = ref('-$50,000') // Negative means overspent
const totalProjectsCompleted = ref(25)
const totalProjectsCompletedLastQuarterChange = ref('+10%')
const averageCompletionPercentage = ref(65)
const projectStatusDistribution = ref({
  'Completed': 40,
  'Ongoing': 30,
  'Planning': 15,
  'At Risk': 10,
  'Under Investigation': 5,
})

// New Dummy Data for User-Specific Activity & Focus
const myAssignedProjects = ref([
  { id: 101, name: 'Coastal Defense System', progress: 70 },
  { id: 102, name: 'Urban Renewal Initiative', progress: 45 },
  { id: 103, name: 'Public Transport Upgrade', progress: 90 },
])

const recentActivityLog = ref([
  { id: 1, timestamp: '2025-10-23 14:30', activity: 'Updated \'Water Security Pipeline\' status to Ongoing.' },
  { id: 2, timestamp: '2025-10-23 10:15', activity: 'Submitted report on Project X (Fraud Project).' },
  { id: 3, timestamp: '2025-10-22 16:00', activity: 'Reviewed Q3 budget for Energy Development.' },
])

const teamPerformance = ref({
  myTeamAverage: 75,
  organizationalAverage: 68,
})

// Check login status on mount and listen for changes
onMounted(() => {
  authService.getSession().then((session) => {
    isLoggedIn.value = !!session
  })
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session
  })
})
</script>

<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header />
    <main class="flex-1 flex p-4 pt-16">
      <!-- Burger Icon -->
      <button v-if="isLoggedIn" class="fixed top-4 left-4 z-50 p-2 focus:outline-none rounded-md text-white" @click="toggleSidebar">
        <svg class="w-6 h-6" fill="none" stroke="white" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 p-8">
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-800">
            Dashboard
          </h1>
          <div class="flex items-center">
            <span class="text-lg font-semibold text-gray-600 mr-2">Rewards Points:</span>
            <span class="text-2xl font-bold text-green-600">{{ rewardsPoints }}</span>
          </div>
        </div>

        <!-- Urgent Alerts and Integrity Focus Banner -->
        <div class="bg-gradient-to-r from-red-700 to-amber-500 text-white p-6 rounded-lg shadow-lg mb-8">
          <h2 class="text-2xl font-bold mb-4">
            Urgent Alerts & Integrity Focus
          </h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <!-- Integrity Review Queue -->
            <div class="flex items-center bg-red-800 p-3 rounded-md">
              <svg class="h-8 w-8 text-white mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" /></svg>
              <div>
                <p class="text-sm">
                  Integrity Review Queue
                </p>
                <p class="text-2xl font-bold">
                  {{ integrityReviewQueue }}
                </p>
              </div>
            </div>

            <!-- Projects At Risk -->
            <div class="flex items-center bg-amber-600 p-3 rounded-md">
              <span class="text-2xl font-bold mr-3">⚠️</span>
              <div>
                <p class="text-sm">
                  Projects At Risk
                </p>
                <p class="text-2xl font-bold">
                  {{ projectsAtRisk }}
                </p>
              </div>
            </div>

            <!-- Critical Milestones Missed -->
            <div class="flex items-center bg-red-800 p-3 rounded-md">
              <span class="text-2xl font-bold mr-3">❌</span>
              <div>
                <p class="text-sm">
                  Critical Milestones Missed
                </p>
                <p class="text-2xl font-bold">
                  {{ criticalMilestonesMissed }}
                </p>
              </div>
            </div>

            <!-- Upcoming Deadlines -->
            <div class="bg-red-800 p-3 rounded-md">
              <p class="text-sm mb-1">
                Upcoming Deadlines (7 days)
              </p>
              <ul class="text-xs list-disc list-inside">
                <li v-for="(deadline, index) in upcomingDeadlines" :key="index">
                  {{ deadline.project }} ({{ deadline.date }})
                </li>
              </ul>
            </div>
          </div>
        </div>

        <!-- Global Project Health & Key Financials -->
        <div class="bg-white p-6 rounded-lg shadow-md mb-8">
          <h2 class="text-2xl font-bold text-gray-800 mb-4">
            Global Project Health & Key Financials
          </h2>

          <!-- Financial Oversight -->
          <div class="mb-6">
            <h3 class="text-xl font-semibold text-gray-700 mb-3">
              Financial Oversight
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                <p class="text-sm text-gray-600">
                  Total Budget Allocated
                </p>
                <p class="text-3xl font-bold text-indigo-600">
                  {{ totalBudgetAllocated }}
                </p>
              </div>
              <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                <p class="text-sm text-gray-600">
                  Budget Burn Rate
                </p>
                <div class="flex items-center">
                  <div class="w-16 h-16 rounded-full bg-gray-200 flex items-center justify-center text-sm font-bold text-gray-700 mr-3">
                    {{ budgetBurnRate.spent }}%
                  </div>
                  <p class="text-lg text-gray-700">
                    Spent
                  </p>
                </div>
              </div>
              <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                <p class="text-sm text-gray-600">
                  Budget Variance
                </p>
                <p :class="budgetVariance.startsWith('-') ? 'text-red-600' : 'text-green-600'" class="text-xl font-bold">
                  {{ budgetVariance }}
                </p>
              </div>
            </div>
          </div>

          <!-- Portfolio Progress -->
          <div>
            <h3 class="text-xl font-semibold text-gray-700 mb-3">
              Portfolio Progress
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                <p class="text-sm text-gray-600">
                  Total Projects Completed
                </p>
                <p class="text-3xl font-bold text-teal-600">
                  {{ totalProjectsCompleted }} <span class="text-sm text-gray-500">({{ totalProjectsCompletedLastQuarterChange }})</span>
                </p>
              </div>
              <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                <p class="text-sm text-gray-600">
                  Average Completion
                </p>
                <p class="text-3xl font-bold text-orange-600">
                  {{ averageCompletionPercentage }}%
                </p>
              </div>
              <div class="bg-gray-50 p-4 rounded-lg shadow-sm">
                <p class="text-sm text-gray-600 mb-2">
                  Project Status Distribution
                </p>
                <ul class="text-sm list-disc list-inside">
                  <li v-for="(count, status) in projectStatusDistribution" :key="status">
                    {{ status }}: {{ count }}
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>
