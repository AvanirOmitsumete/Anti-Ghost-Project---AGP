<template>
  <div class="min-h-screen bg-gray-100 flex flex-col">
    <Header @toggle-sidebar="toggleSidebar" />
    <main class="flex-1 flex p-4 pt-16">
      <Sidebar v-if="isLoggedIn" :is-open="isSidebarOpen" @close="toggleSidebar" />

      <div class="flex-1 p-8">
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-3xl font-bold text-gray-800">Project Updates</h1>
        </div>

        <!-- Search Input -->
        <div class="mb-4">
          <input
            type="text"
            v-model="searchQuery"
            placeholder="Search project by name..."
            class="w-full p-3 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-200 ease-in-out"
          />
        </div>

        <!-- Date Filter Buttons -->
        <div class="flex space-x-2 mb-8">
          <button
            @click="dateFilter = 'all'"
            :class="{'bg-blue-600 text-white': dateFilter === 'all', 'bg-gray-200 text-gray-800': dateFilter !== 'all'}"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
          >
            All Updates
          </button>
          <button
            @click="dateFilter = 'today'"
            :class="{'bg-blue-600 text-white': dateFilter === 'today', 'bg-gray-200 text-gray-800': dateFilter !== 'today'}"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
          >
            Today Only
          </button>
          <button
            @click="dateFilter = 'lastWeek'"
            :class="{'bg-blue-600 text-white': dateFilter === 'lastWeek', 'bg-gray-200 text-gray-800': dateFilter !== 'lastWeek'}"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
          >
            Last Week
          </button>
          <button
            @click="dateFilter = 'lastMonth'"
            :class="{'bg-blue-600 text-white': dateFilter === 'lastMonth', 'bg-gray-200 text-gray-800': dateFilter !== 'lastMonth'}"
            class="px-4 py-2 rounded-md text-sm font-medium transition duration-200 ease-in-out hover:bg-blue-500 hover:text-white"
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

        <div v-else-if="Object.keys(groupedUpdates).length === 0" class="text-gray-600 text-center text-lg py-10">
          No updates available for "<span class="font-semibold">{{ searchQuery }}</span>" with the selected filter.
        </div>

        <div v-else class="space-y-10">
          <div v-for="(projectUpdates, projectName) in groupedUpdates" :key="projectName" class="bg-white p-6 rounded-lg shadow-lg border border-gray-200">
            <h2 class="text-2xl font-bold text-gray-800 mb-5 border-b pb-3 border-gray-200">{{ projectName }}</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <div
                v-for="update in projectUpdates" :key="update.id"
                class="bg-gray-50 p-5 rounded-lg shadow-sm hover:shadow-md transition-all duration-300 ease-in-out transform hover:scale-102 cursor-pointer border border-gray-100"
              >
                <h3 class="text-xl font-semibold text-gray-700 mb-2">{{ update.title }}</h3>
                <p class="text-gray-600 text-sm mb-4">{{ update.description }}</p>
                <div class="flex justify-between items-center text-xs text-gray-500">
                  <span>Date: {{ new Date(update.date).toLocaleDateString() }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { defineAsyncComponent, ref, onMounted, computed } from 'vue'
import Sidebar from '@/components/global/Sidebar.vue'
import LoadingSpinner from '@/components/global/LoadingSpinner.vue'
import { authService } from '@/services/auth' // Import authService

const Header = defineAsyncComponent(() => import('@/components/global/Header.vue'))
const Footer = defineAsyncComponent(() => import('@/components/global/Footer.vue'))

const isSidebarOpen = ref(false)
const updates = ref<any[]>([])
const isLoading = ref(true)
const error = ref<string | null>(null)
const searchQuery = ref<string>('')
const dateFilter = ref<string>('all') // 'all', 'today', 'lastWeek', 'lastMonth'
const isLoggedIn = ref(false) // Add isLoggedIn state

function toggleSidebar() {
  isSidebarOpen.value = !isSidebarOpen.value
}

interface ProjectUpdate {
  id: number;
  title: string;
  description: string;
  project: string;
  date: string;
}

const filteredUpdates = computed(() => {
  let filtered = updates.value;

  // Apply search query filter
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase();
    filtered = filtered.filter(update =>
      update.project.toLowerCase().includes(query)
    );
  }

  // Apply date filter
  const now = new Date();
  now.setHours(0, 0, 0, 0); // Normalize 'now' to start of today

  if (dateFilter.value === 'today') {
    filtered = filtered.filter(update => {
      const updateDate = new Date(update.date);
      updateDate.setHours(0, 0, 0, 0);
      return updateDate.getTime() === now.getTime();
    });
  } else if (dateFilter.value === 'lastWeek') {
    const lastWeek = new Date(now);
    lastWeek.setDate(now.getDate() - 7);
    filtered = filtered.filter(update => {
      const updateDate = new Date(update.date);
      return updateDate >= lastWeek && updateDate <= now;
    });
  } else if (dateFilter.value === 'lastMonth') {
    const lastMonth = new Date(now);
    lastMonth.setMonth(now.getMonth() - 1);
    filtered = filtered.filter(update => {
      const updateDate = new Date(update.date);
      return updateDate >= lastMonth && updateDate <= now;
    });
  }

  // Sort by date (latest first)
  return filtered.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
});

const groupedUpdates = computed(() => {
  const grouped: { [key: string]: ProjectUpdate[] } = {};
  filteredUpdates.value.forEach(update => {
    if (!grouped[update.project]) {
      grouped[update.project] = [];
    }
    grouped[update.project].push(update);
  });
  return grouped;
});

onMounted(() => {
  // Dummy Data for demonstration
  const today = new Date();
  const yesterday = new Date(today);
  yesterday.setDate(today.getDate() - 1);
  const lastWeek = new Date(today);
  lastWeek.setDate(today.getDate() - 6);
  const lastMonth = new Date(today);
  lastMonth.setDate(today.getDate() - 20);

  updates.value = [
    {
      id: 1,
      title: 'Project Alpha Progress Report',
      description: 'Weekly progress meeting held. All tasks on track. Next milestone due in 5 days.',
      project: 'Project Alpha',
      date: today.toISOString().split('T')[0],
    },
    {
      id: 2,
      title: 'Budget Review for Project Beta',
      description: 'Budget allocation for Q4 approved. Minor adjustments made to resource spending.',
      project: 'Project Beta',
      date: yesterday.toISOString().split('T')[0],
    },
    {
      id: 3,
      title: 'New Task Assigned in Project Gamma',
      description: 'John Doe has been assigned to lead the new data migration task. Deadline: 2025-11-05.',
      project: 'Project Gamma',
      date: lastWeek.toISOString().split('T')[0],
    },
    {
      id: 4,
      title: 'Project Delta Scope Change',
      description: 'Client requested a minor scope change. Impact analysis completed and approved.',
      project: 'Project Delta',
      date: lastMonth.toISOString().split('T')[0],
    },
    {
      id: 5,
      title: 'Team Meeting for Project Epsilon',
      description: 'Kick-off meeting for the new phase of Project Epsilon. Roles and responsibilities defined.',
      project: 'Project Epsilon',
      date: new Date(lastMonth.getTime() - 5 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
    },
    {
      id: 6,
      title: 'Project Alpha Phase 2 Planning',
      description: 'Initial planning for the second phase of Project Alpha has begun.',
      project: 'Project Alpha',
      date: new Date(yesterday.getTime() - 2 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
    },
    {
      id: 7,
      title: 'Project Beta Security Audit',
      description: 'Security audit completed with no critical vulnerabilities found.',
      project: 'Project Beta',
      date: today.toISOString().split('T')[0],
    },
  ];
  isLoading.value = false;

  authService.getSession().then(session => {
    isLoggedIn.value = !!session;
  });
  authService.onAuthStateChange((event, session) => {
    isLoggedIn.value = !!session;
  });
});
</script>