<script setup>
// Imports
import ProjectCard from '@/components/project_module/ProjectCard.vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { Button } from '@/components/ui/button'
import ProjectForm from '@/components/project_module/ProjectForm.vue'
import { ref, computed } from 'vue'
import { Input } from '@/components/ui/input'
import { DropdownMenuItem } from '@/components/ui/dropdown-menu'
import AppDropdownMenu from '@/components/layout/AppDropdownMenu.vue'

// Scripts
const modalOpen = ref(false)
const searchOpen = ref(false)
const searchQuery = ref('')
const statusFilter = ref('')
const sortMode = ref('completed') // 'completed' | 'inProgress' | 'notStarted' | 'name' | 'progress'
const dropdownSide = 'bottom'

const handleStatusFilterChange = (status) => {
  statusFilter.value = status
}

const handleSortChange = (mode) => {
  sortMode.value = mode
}

const statusFilterLabel = computed(() => {
  if (!statusFilter.value) return 'All statuses'
  return statusFilter.value
})
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
      <!-- filter -->
      <div class="flex items-center gap-2">
        <AppDropdownMenu :side="dropdownSide">
          <template #trigger>
            <Button variant="outline" size="default" class="gap-2 h-9 px-3 sm:h-10 sm:px-4">
              <i class="fa-solid fa-filter"></i><span class="hidden sm:inline">Filter</span>
            </Button>
          </template>
          <template #content>
            <DropdownMenuItem
              class="text-sm flex items-center gap-2 justify-center"
              @select="
                (event) => {
                  event.preventDefault()
                  handleStatusFilterChange('')
                }
              "
            >
              <span>All statuses</span>
              <span
                class="inline-block w-2 h-2 rounded-full bg-green-500"
                v-if="statusFilter === ''"
              ></span>
            </DropdownMenuItem>
            <DropdownMenuItem
              class="flex items-center gap-2 justify-center"
              @select="
                (event) => {
                  event.preventDefault()
                  handleStatusFilterChange('Completed')
                }
              "
            >
              <span>Completed</span>
              <span
                class="inline-block w-2 h-2 rounded-full bg-green-500"
                v-if="statusFilter === 'Completed'"
              ></span>
            </DropdownMenuItem>

            <DropdownMenuItem
              class="flex items-center gap-2 justify-center"
              @select="
                (event) => {
                  event.preventDefault()
                  handleStatusFilterChange('In Progress')
                }
              "
            >
              <span>In Progress</span>
              <span
                class="inline-block w-2 h-2 rounded-full bg-green-500"
                v-if="statusFilter === 'In Progress'"
              ></span>
            </DropdownMenuItem>

            <DropdownMenuItem
              class="flex items-center gap-2 justify-center"
              @select="
                (event) => {
                  event.preventDefault()
                  handleStatusFilterChange('Not Started')
                }
              "
            >
              <span>Not Started</span>
              <span
                class="inline-block w-2 h-2 rounded-full bg-green-500"
                v-if="statusFilter === 'Not Started'"
              ></span>
            </DropdownMenuItem>
          </template>
        </AppDropdownMenu>
        <span class="text-xs sm:text-sm text-muted-foreground"
          >Filter: {{ statusFilterLabel }}</span
        >
      </div>
      <!-- sort -->
      <AppDropdownMenu :side="dropdownSide">
        <template #trigger>
          <Button variant="outline" size="default" class="gap-2 h-9 px-3 sm:h-10 sm:px-4">
            <i class="fa-solid fa-sort"></i><span class="hidden sm:inline">Sort</span>
          </Button>
        </template>
        <template #content>
          <DropdownMenuItem
            class="text-sm flex items-center gap-2 justify-center"
            @select="
              (event) => {
                event.preventDefault()
                handleSortChange('completed')
              }
            "
          >
            <span>Completed</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            class="text-sm flex items-center gap-2 justify-center"
            @select="
              (event) => {
                event.preventDefault()
                handleSortChange('inProgress')
              }
            "
          >
            <span>In Progress</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            class="text-sm flex items-center gap-2 justify-center"
            @select="
              (event) => {
                event.preventDefault()
                handleSortChange('notStarted')
              }
            "
          >
            <span>Not Started</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            class="text-sm flex items-center gap-2 justify-center"
            @select="
              (event) => {
                event.preventDefault()
                handleSortChange('name')
              }
            "
          >
            <span>Name (A–Z)</span>
          </DropdownMenuItem>

          <DropdownMenuItem
            class="text-sm flex items-center gap-2 justify-center"
            @select="
              (event) => {
                event.preventDefault()
                handleSortChange('progress')
              }
            "
          >
            <span>Progress (high → low)</span>
          </DropdownMenuItem>
        </template>
      </AppDropdownMenu>
    </div>
  </div>
  <ProjectCard :search-query="searchQuery" :status-filter="statusFilter" :sort-mode="sortMode" />
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
