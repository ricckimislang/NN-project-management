<script setup>
// Add any reactive state or composables here if needed
</script>

<template>
  <header
    class="bg-white shadow-sm border-b border-gray-200 px-4 py-3 flex items-center justify-between"
  >
    <div class="flex items-center space-x-4">
      <h1 class="text-xl font-semibold text-gray-900">N + N Project Management</h1>
    </div>
    <div class="flex items-center space-x-4">
      <input
        type="text"
        placeholder="Search projects..."
        class="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
      />
      <button class="p-2 text-gray-600 hover:text-gray-900">
        <i class="fas fa-search"></i>
      </button>
      <div class="relative">
        <button class="p-2 text-gray-600 hover:text-gray-900">
          <i class="fas fa-user"></i>
        </button>
      </div>
    </div>
  </header>
</template>
