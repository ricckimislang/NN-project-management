<script setup>
import { ref } from 'vue'
import AppHeader from './AppHeader.vue'
import AppSidebar from './AppSidebar.vue'
import AppMain from './AppMain.vue'
import AppFooter from './AppFooter.vue'

// Sidebar state
const isSidebarOpen = ref(false)

// Toggle sidebar
const toggleSidebar = () => {
  isSidebarOpen.value = !isSidebarOpen.value
}

// Close sidebar (for navigation clicks)
const closeSidebar = () => {
  isSidebarOpen.value = false
}
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <AppHeader :on-toggle-sidebar="toggleSidebar" />

    <!-- Desktop Sidebar (Fixed) -->
    <AppSidebar
      :is-open="true"
      @toggle="toggleSidebar"
      class="hidden md:block md:top-[56px] md:h-[calc(100vh-56px)]"
    />

    <!-- Sidebar Backdrop (Mobile) -->
    <transition
      enter-active-class="transition-opacity duration-300 ease-out"
      leave-active-class="transition-opacity duration-200 ease-in"
    >
      <div
        v-if="isSidebarOpen"
        class="fixed inset-0 backdrop-blur-sm z-30 md:hidden"
        @click="closeSidebar"
      ></div>
    </transition>

    <div class="flex flex-1">
      <!-- Mobile Sidebar -->
      <AppSidebar :is-open="isSidebarOpen" @toggle="closeSidebar" class="md:hidden" />

      <AppMain class="md:ml-[280px]">
        <slot />
      </AppMain>
    </div>
    <AppFooter />
  </div>
</template>
