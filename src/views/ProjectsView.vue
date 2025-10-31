<script setup>
import AppMain from '@/components/layout/AppMain.vue'
import ProjectCard from '@/components/project_module/ProjectCard.vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
</script>

<template>
  <AppMain>
    <div class="toolbar flex justify-between items-center mb-6">
      <div>
        <BreadCrumbs :url="'/projects'" title="Projects"></BreadCrumbs>
      </div>
      <div class="flex space-x-2">
        <button
          class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded flex items-center"
        >
          <i class="fa-solid fa-plus"></i> Add Project
        </button>
        <button
          class="bg-gray-200 hover:bg-gray-300 text-gray-700 px-4 py-2 rounded flex items-center"
        >
          <i class="fa-solid fa-magnifying-glass"></i> Search
        </button>
        <button
          class="bg-gray-200 hover:bg-gray-300 text-gray-700 px-4 py-2 rounded flex items-center"
        >
          <i class="fa-solid fa-gear"></i> Filter / Sort
        </button>
      </div>
    </div>
    <ProjectCard />
  </AppMain>
</template>
