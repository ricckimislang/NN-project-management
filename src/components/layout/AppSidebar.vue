<script setup>
// Props
const props = defineProps({
  isOpen: {
    type: Boolean,
    default: false,
  },
})

// Emits
const emit = defineEmits(['toggle'])
</script>

<template>
  <aside
    class="fixed left-0 top-0 h-full bg-white shadow-lg border-r border-gray-200 transition-transform duration-300 ease-in-out z-40"
    :class="props.isOpen ? 'translate-x-0' : '-translate-x-full'"
    style="width: 280px"
  >
    <!-- Header -->
    <div class="md:hidden p-4 border-b border-gray-200">
      <div class="flex items-center justify-between">
        <h2 class="text-lg font-semibold text-gray-900">N + N Project Management</h2>
        <button
          @click="emit('toggle')"
          class="p-2 text-gray-600 hover:text-gray-900 rounded-md hover:bg-gray-100"
        >
          <i class="fas fa-times"></i>
        </button>
      </div>
    </div>

    <!-- Search -->
    <div class="md:hidden p-4 border-b border-gray-200">
      <div class="relative">
        <input
          type="text"
          placeholder="Search projects..."
          class="w-full px-4 py-3 text-sm border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
        />
        <button class="absolute right-3 top-1/2 transform -translate-y-1/2 p-1 text-gray-600">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>

    <!-- Navigation -->
    <nav class="md:mt-5 p-4 flex-1">
      <ul class="space-y-2">
        <li>
          <RouterLink
            to="/dashboard"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            @click="emit('toggle')"
          >
            <i class="fa-solid fa-house mr-3"></i>
            Dashboard
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/projects"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            @click="emit('toggle')"
          >
            <i class="fa-solid fa-bars-progress mr-3"></i>
            Projects
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/tasks"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            @click="emit('toggle')"
          >
            <i class="fa-solid fa-list-check mr-3"></i>
            Tasks
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/team"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            @click="emit('toggle')"
          >
            <i class="fa-solid fa-people-group mr-3"></i>
            Team
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/reports"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            @click="emit('toggle')"
          >
            <i class="fa-solid fa-chart-simple mr-3"></i>
            Reports
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/settings"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            @click="emit('toggle')"
          >
            <i class="fa-solid fa-gear mr-3"></i>
            Settings
          </RouterLink>
        </li>
      </ul>
    </nav>

    <!-- User Menu -->
    <div class="md:hidden p-4 border-t border-gray-200">
      <div class="space-y-2">
        <button
          class="flex items-center space-x-3 w-full p-3 text-left hover:bg-gray-50 rounded-lg transition-colors"
        >
          <i class="fas fa-user text-gray-600"></i>
          <span class="text-gray-700">Profile</span>
        </button>
        <button
          class="flex items-center space-x-3 w-full p-3 text-left hover:bg-gray-50 rounded-lg transition-colors"
        >
          <i class="fas fa-cog text-gray-600"></i>
          <span class="text-gray-700">Settings</span>
        </button>
        <button
          class="flex items-center space-x-3 w-full p-3 text-left hover:bg-gray-50 rounded-lg transition-colors text-red-600"
        >
          <i class="fas fa-sign-out-alt"></i>
          <span>Logout</span>
        </button>
      </div>
    </div>
  </aside>
</template>
