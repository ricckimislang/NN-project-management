<script setup>
// Imports
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { Card } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { DropdownMenuItem } from '@/components/ui/dropdown-menu'
import AppDropdownMenu from '@/components/layout/AppDropdownMenu.vue'
import { AspectRatio } from '@/components/ui/aspect-ratio'
import { ScrollArea } from '@/components/ui/scroll-area'
import { useIntersectionObserver, useBreakpoints } from '@vueuse/core'

import { projectData } from '@/data/projectData'

// Props
const props = defineProps({
  searchQuery: {
    type: String,
    default: '',
  },
  statusFilter: {
    type: String,
    default: '',
  },
  sortMode: {
    type: String,
    default: 'completed', // 'completed' | 'inProgress' | 'notStarted' | 'name' | 'progress'
  },
})

// Scripts
const scrollArea = ref()
const cardRefs = ref([])
const animationTimers = ref([])
const breakpoints = useBreakpoints({ sm: 640, md: 768, lg: 1024, xl: 1280, '2xl': 1536 })
const isBelowLg = breakpoints.smaller('lg')
const dropdownSide = computed(() => (isBelowLg.value ? 'top' : 'bottom'))

const projects = projectData
const projectProgress = ref(projects.map((project) => project.progress))

const animateProgress = (index, target) => {
  const duration = 300
  const increment = target / (duration / 16)
  const timer = setInterval(() => {
    if (projectProgress.value[index] >= target) {
      clearInterval(timer)
      return
    }
    projectProgress.value[index] = Math.min(projectProgress.value[index] + increment, target)
  }, 16)
  animationTimers.value.push(timer) // Store the timer
}

const badgeVariant = (status) => {
  switch (status) {
    case 'Completed':
      return 'success'
    case 'In Progress':
      return 'info'
    case 'Not Started':
      return 'warning'
    default:
      return 'default'
  }
}

const filteredProjects = computed(() => {
  const query = props.searchQuery.trim().toLowerCase()
  const status = props.statusFilter

  let result = [...projects]

  if (status) {
    result = result.filter((project) => project.status === status)
  }

  if (query) {
    result = result.filter((project) => {
      return (
        project.name.toLowerCase().includes(query) ||
        project.category.toLowerCase().includes(query) ||
        project.branch.toLowerCase().includes(query) ||
        project.address.toLowerCase().includes(query) ||
        project.projectManager.toLowerCase().includes(query)
      )
    })
  }

  // Sorting
  if (props.sortMode === 'name') {
    return result.sort((a, b) => a.name.localeCompare(b.name))
  }

  if (props.sortMode === 'progress') {
    // Higher progress first
    return result.sort((a, b) => b.progress - a.progress || a.name.localeCompare(b.name))
  }

  // Status-based modes
  let statusPriority

  if (props.sortMode === 'completed') {
    statusPriority = {
      Completed: 0,
      'In Progress': 1,
      'Not Started': 2,
    }
  } else if (props.sortMode === 'inProgress') {
    statusPriority = {
      'In Progress': 0,
      Completed: 1,
      'Not Started': 2,
    }
  } else if (props.sortMode === 'notStarted') {
    statusPriority = {
      'Not Started': 0,
      'In Progress': 1,
      Completed: 2,
    }
  } else {
    // Fallback to completed-first
    statusPriority = {
      Completed: 0,
      'In Progress': 1,
      'Not Started': 2,
    }
  }

  return result.sort((a, b) => {
    const aPriority = statusPriority[a.status] ?? 99
    const bPriority = statusPriority[b.status] ?? 99

    if (aPriority !== bPriority) {
      return aPriority - bPriority
    }

    return a.name.localeCompare(b.name)
  })
})

onMounted(() => {
  // Get the scrollable viewport
  const viewport = scrollArea.value.$el.querySelector('[data-slot="scroll-area-viewport"]')

  // Set up intersection observer for scroll animations
  useIntersectionObserver(
    cardRefs.value,
    (entries) => {
      entries.forEach((entry, index) => {
        const el = entry.target
        if (entry.isIntersecting) {
          // Staggered animation on enter
          setTimeout(() => {
            el.classList.add('animate-fade-in-up')
          }, index * 200)
        } else {
          // Fade out on exit
          el.classList.remove('animate-fade-in-up')
        }
      })
    },
    {
      root: viewport,
      threshold: 0.1,
    },
  )

  projects.forEach((project, index) => {
    setTimeout(() => {
      animateProgress(index, project.progress)
    }, index * 100) // slight delay between each animation
  })
})
onUnmounted(() => {
  // Clear all animation timers
  animationTimers.value.forEach((timer) => {
    clearInterval(timer)
  })
})
</script>

<template>
  <ScrollArea ref="scrollArea" class="h-[calc(100vh-90px)]">
    <div class="space-y-3 sm:space-y-4 px-2 sm:px-4">
      <div v-for="(project, index) in filteredProjects" :key="project.id">
        <Card class="p-2 sm:p-3 md:p-4 opacity-0" :ref="(el) => (cardRefs[index] = el)">
          <div class="flex flex-col">
            <!-- Responsive flex: column on mobile, row on md+ -->
            <div class="flex flex-col gap-2.5 sm:gap-3 md:flex-row md:gap-4">
              <!-- Image section -->
              <div
                class="flex justify-center md:justify-start md:items-center mb-3 sm:mb-4 md:mb-0"
              >
                <div
                  class="w-full max-w-[120px] sm:max-w-40 md:w-36 md:h-36 lg:w-40 lg:h-40 overflow-hidden rounded-lg bg-muted flex items-center justify-center"
                >
                  <AspectRatio :ratio="1 / 1">
                    <img class="w-full h-full object-cover" :src="project.image" alt="" />
                  </AspectRatio>
                </div>
              </div>
              <div class="flex flex-col flex-1">
                <div class="relative flex-1 space-y-2">
                  <!-- Details column -->
                  <div class="space-y-1 text-center md:text-left">
                    <h3 class="text-sm sm:text-base md:text-xl font-semibold text-foreground">
                      {{ project.name }}
                    </h3>
                    <p class="text-[11px] sm:text-sm text-muted-foreground">
                      {{ project.category }}
                    </p>
                  </div>
                  <div class="space-y-1 text-center md:text-left">
                    <p class="hidden sm:block text-xs text-muted-foreground">
                      {{ project.branch }}, {{ project.address }}
                    </p>
                    <p class="text-[11px] sm:text-xs text-muted-foreground">
                      📅 {{ project.startDate }} - {{ project.endDate }}
                    </p>
                    <p class="text-[11px] sm:text-xs md:text-sm text-muted-foreground">
                      👥 <span class="font-semibold">{{ project.projectManager }}</span>
                    </p>
                  </div>
                  <!-- Actions: static on mobile, absolute on desktop -->
                  <div
                    class="flex items-center justify-between w-full mt-2 md:mt-0 md:w-auto md:absolute md:top-2 md:right-2 md:justify-end space-x-1 sm:space-x-2"
                  >
                    <Badge
                      :variant="badgeVariant(project.status)"
                      class="text-[10px] sm:text-xs capitalize"
                    >
                      {{ project.status }}</Badge
                    >
                    <div class="relative">
                      <AppDropdownMenu :side="dropdownSide">
                        <template #trigger>
                          <Button variant="ghost" size="sm" class="h-7 w-7 sm:h-8 sm:w-8 p-0">
                            <i class="fa-solid fa-ellipsis-vertical text-xs sm:text-sm"></i>
                          </Button>
                        </template>
                        <template #content>
                          <DropdownMenuItem class="text-sm">View</DropdownMenuItem>
                          <DropdownMenuItem class="text-sm">Edit</DropdownMenuItem>
                          <DropdownMenuItem class="text-sm">Archive</DropdownMenuItem>
                          <DropdownMenuItem class="text-destructive text-sm">
                            Delete
                          </DropdownMenuItem>
                        </template>
                      </AppDropdownMenu>
                    </div>
                  </div>
                  <!-- Progress bar -->
                  <div class="flex flex-col justify-end flex-1 mt-3 sm:mt-4">
                    <div class="flex justify-between text-[11px] sm:text-xs mb-1">
                      <span>Progress</span>
                      <span>{{ Math.round(projectProgress[index]) }}%</span>
                    </div>
                    <Progress :value="projectProgress[index]" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Card>
      </div>
    </div>
  </ScrollArea>
</template>

<style scoped>
.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out forwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
