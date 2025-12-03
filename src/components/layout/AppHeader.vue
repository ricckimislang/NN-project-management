<script setup>
import { ref } from 'vue'

// Props
const props = defineProps({
  onToggleSidebar: {
    type: Function,
    required: true,
  },
})

// Scripts
const companyTitle = ref('N + N Project Management')
</script>

<template>
  <header
    class="sticky top-0 z-40 md:z-50 bg-white shadow-sm border-b border-gray-200 px-2 md:px-4 py-2 md:py-3 flex items-center justify-between">
    <div class="flex items-center space-x-2 md:space-x-4">
      <h1 class="text-sm md:text-xl font-semibold text-gray-900">{{ companyTitle }}</h1>
    </div>
    <div class="flex items-center space-x-1 md:space-x-4 flex-1 md:flex-none justify-end">
      <!-- Desktop Navigation -->
      <div class="hidden md:flex items-center space-x-4">
        <div class="relative flex-1 md:flex-none max-w-xs md:max-w-none">
          <input type="text" placeholder="Search projects..."
            class="w-full px-4 py-2 text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent" />
          <button class="absolute right-2 top-1/2 transform -translate-y-1/2 p-1 text-gray-600 hover:text-gray-900">
            <i class="fas fa-search"></i>
          </button>
        </div>
        <button class="p-2 text-gray-600 hover:text-gray-900">
          <i class="fas fa-user"></i>
        </button>
      </div>

      <!-- Mobile Menu Toggle -->
      <button @click="props.onToggleSidebar()" class="md:hidden p-1 text-gray-600 hover:text-gray-900"
        :aria-label="'Toggle navigation menu'">
        <i class="fas fa-bars text-sm"></i>
      </button>
    </div>
  </header>
</template>
