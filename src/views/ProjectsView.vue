<script setup>
import AppMain from '@/components/layout/AppMain.vue'
import ProjectCard from '@/components/project_module/ProjectCard.vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { Button } from '@/components/ui/button'
</script>

<template>
  <AppMain>
    <div class="toolbar flex justify-between items-center mb-6">
      <div>
        <BreadCrumbs :url="'/projects'" title="Projects"></BreadCrumbs>
      </div>
      <div class="flex space-x-2">
        <Button variant="outline" size="default">
          <i class="fa-solid fa-plus"></i> Add Project
        </Button>
        <Button variant="outline" size="default">
          <i class="fa-solid fa-magnifying-glass"></i> Search
        </Button>
        <Button variant="outline" size="default">
          <i class="fa-solid fa-gear"></i> Filter / Sort
        </Button>
      </div>
    </div>
    <ProjectCard />
  </AppMain>
</template>
