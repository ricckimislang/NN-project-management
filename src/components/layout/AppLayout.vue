<script setup>
import AppHeader from './AppHeader.vue'
import AppSidebar from './AppSidebar.vue'
import AppMain from './AppMain.vue'
import AppFooter from './AppFooter.vue'
</script>

<template>
  <div class="min-h-screen bg-gray-50 flex flex-col">
    <AppHeader />
    <div class="flex flex-1">
      <AppSidebar class="hidden md:block" />
      <AppMain>
        <slot />
      </AppMain>
    </div>
    <AppFooter />
  </div>
</template>
