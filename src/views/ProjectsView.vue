<script setup>
// Imports
import ProjectCard from '@/components/project_module/ProjectCard.vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { Button } from '@/components/ui/button'
import ProjectForm from '@/components/project_module/ProjectForm.vue'
import { ref } from 'vue'

// Scripts
const modalOpen = ref(false)
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
      <Button variant="outline" size="default" class="gap-2 h-9 px-3 sm:h-10 sm:px-4">
        <i class="fa-solid fa-magnifying-glass"></i><span class="hidden sm:inline"> Search</span>
      </Button>
      <Button variant="outline" size="default" class="gap-2 h-9 px-3 sm:h-10 sm:px-4">
        <i class="fa-solid fa-gear"></i><span class="hidden sm:inline"> Filter / Sort</span>
      </Button>
    </div>
  </div>
  <ProjectCard />
  <!-- Modal -->
  <ProjectForm v-model:open="modalOpen" />
</template>
