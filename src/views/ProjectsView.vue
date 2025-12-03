<script setup>
// Imports
import ProjectCard from '@/components/project_module/ProjectCard.vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { Button } from '@/components/ui/button'
import ProjectForm from '@/components/project_module/ProjectForm.vue'
import { ref } from 'vue'
import { Input } from '@/components/ui/input'

// Scripts
const modalOpen = ref(false)
const searchOpen = ref(false)
const searchQuery = ref('')
</script>

<template>
  <div
    class="toolbar flex flex-col sm:flex-row sm:justify-between sm:items-center gap-3 sm:gap-4 mb-6"
  >
    <div>
      <BreadCrumbs :url="'/projects'" title="Projects"></BreadCrumbs>
    </div>
    <div class="flex flex-wrap gap-2 sm:gap-3">
      <Button
        variant="outline"
        size="default"
        @click="modalOpen = true"
        class="gap-2 h-9 px-3 sm:h-10 sm:px-4"
      >
        <i class="fa-solid fa-plus"></i><span class="hidden sm:inline"> Add Project</span>
      </Button>
      <div class="flex items-center gap-2">
        <Button
          variant="outline"
          size="default"
          class="gap-2 h-9 px-3 sm:h-10 sm:px-4"
          @click="searchOpen = !searchOpen"
        >
          <i class="fa-solid fa-magnifying-glass"></i>
          <span class="hidden sm:inline"> Search</span>
        </Button>
        <Transition name="search-expand">
          <div v-if="searchOpen" class="w-40 sm:w-64">
            <Input v-model="searchQuery" placeholder="Search projects" />
          </div>
        </Transition>
      </div>
      <Button variant="outline" size="default" class="gap-2 h-9 px-3 sm:h-10 sm:px-4">
        <i class="fa-solid fa-gear"></i><span class="hidden sm:inline"> Filter / Sort</span>
      </Button>
    </div>
  </div>
  <ProjectCard />
  <!-- Modal -->
  <ProjectForm v-model:open="modalOpen" />
</template>

<style scoped>
.search-expand-enter-active,
.search-expand-leave-active {
  transition:
    opacity 0.2s ease-out 0.05s,
    transform 0.2s ease-out 0.05s,
    max-width 0.2s ease-out 0.05s;
}

.search-expand-enter-from,
.search-expand-leave-to {
  opacity: 0;
  transform: translateX(4px) scale(0.98);
  max-width: 0;
}

.search-expand-enter-to,
.search-expand-leave-from {
  opacity: 1;
  transform: translateX(0) scale(1);
  max-width: 16rem; /* matches w-64 */
}
</style>
