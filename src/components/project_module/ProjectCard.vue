<script setup>
// Imports
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { RouterLink } from 'vue-router'
import { Card } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { DropdownMenuItem } from '@/components/ui/dropdown-menu'
import AppDropdownMenu from '@/components/layout/AppDropdownMenu.vue'
import { AspectRatio } from '@/components/ui/aspect-ratio'
import { ScrollArea } from '@/components/ui/scroll-area'
import { useIntersectionObserver, useBreakpoints } from '@vueuse/core'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogClose,
} from '@/components/ui/dialog'
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from '@/components/ui/accordion'

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
        project.description.toLowerCase().includes(query) ||
        project.startDate.toLowerCase().includes(query) ||
        project.endDate.toLowerCase().includes(query) ||
        project.status.toLowerCase().includes(query) ||
        project.progress.toLowerCase().includes(query) ||
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

// Dialog state
const isDeleteDialogOpen = ref(false)
const isViewDialogOpen = ref(false)
const selectedProject = ref(null)

const handleDelete = (projectId) => {
  selectedProject.value = projectId
  isDeleteDialogOpen.value = true
}

const handleView = (project) => {
  selectedProject.value = project
  isViewDialogOpen.value = true
}

const confirmDelete = (projectId) => {
  // TODO: Implement actual delete logic
  console.log('Deleting project:', projectId)
  isDeleteDialogOpen.value = false
  selectedProject.value = null
}

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
              <div class="flex justify-center md:justify-start md:items-center mb-3 sm:mb-4 md:mb-0">
                <div
                  class="w-full max-w-[120px] sm:max-w-40 md:w-36 md:h-36 lg:w-40 lg:h-40 overflow-hidden rounded-lg bg-muted flex items-center justify-center">
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
                    class="flex items-center justify-between w-full mt-2 md:mt-0 md:w-auto md:absolute md:top-2 md:right-2 md:justify-end space-x-1 sm:space-x-2">
                    <Badge :variant="badgeVariant(project.status)" class="text-[10px] sm:text-xs capitalize">
                      {{ project.status }}</Badge>
                    <div class="relative">
                      <AppDropdownMenu :side="dropdownSide">
                        <template #trigger>
                          <Button variant="ghost" size="sm" class="h-7 w-7 sm:h-8 sm:w-8 p-0">
                            <i class="fa-solid fa-ellipsis-vertical text-xs sm:text-sm"></i>
                          </Button>
                        </template>
                        <template #content>
                          <DropdownMenuItem class="text-sm flex items-center gap-2 justify-center" @select="
                            (event) => {
                              event.preventDefault()
                              handleView(project)
                            }
                          ">View</DropdownMenuItem>
                          <RouterLink :href="'/project/' + project.id" target="_blank">
                            <DropdownMenuItem class="text-sm flex items-center gap-2 justify-center">Open in <i
                                class="fa-solid fa-arrow-up-right-from-square"></i></DropdownMenuItem>
                          </RouterLink>
                          <DropdownMenuItem class="text-sm flex items-center gap-2 justify-center">Edit
                          </DropdownMenuItem>
                          <DropdownMenuItem class="text-destructive text-sm flex items-center gap-2 justify-center"
                            @click="handleDelete(project.id)">
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
                      <span>{{ project.progress }}%</span>
                    </div>
                    <Progress :value="project.progress" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </Card>
      </div>
    </div>

    <!-- Delete Dialog -->
    <Dialog v-model:open="isDeleteDialogOpen">
      <DialogContent :class="'w-100 max-w-md'">
        <DialogHeader>
          <DialogTitle>Confirm Deletion</DialogTitle>
          <DialogDescription>
            Are you sure you want to delete this project? This action cannot be undone.
          </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <Button variant="destructive" @click="confirmDelete(projectToDelete)"> Delete </Button>
          <DialogClose>
            <Button type="button" variant="secondary"> Close </Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>

    <!-- View Dialog -->
    <Dialog v-model:open="isViewDialogOpen">
      <DialogContent class="max-w-4xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle class="text-2xl font-bold">Project Details</DialogTitle>
        </DialogHeader>

        <div v-if="selectedProject" class="space-y-6">
          <!-- Project Header with Image -->
          <div class="flex flex-col lg:flex-row gap-6">
            <!-- Project Image -->
            <div class="lg:w-1/3">
              <div class="aspect-square rounded-lg overflow-hidden bg-muted">
                <img :src="selectedProject.image" :alt="selectedProject.name" class="w-full h-full object-cover" />
              </div>
            </div>

            <!-- Project Info -->
            <div class="lg:w-2/3 space-y-4">
              <div>
                <h2 class="text-2xl font-semibold text-foreground mb-2">
                  {{ selectedProject.name }}
                </h2>
                <Badge :variant="badgeVariant(selectedProject.status)" class="text-sm">
                  {{ selectedProject.status }}
                </Badge>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <h3 class="text-sm font-medium text-muted-foreground mb-1">Category</h3>
                  <p class="text-base">{{ selectedProject.category }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-muted-foreground mb-1">Project Manager</h3>
                  <p class="text-base">{{ selectedProject.projectManager }}</p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-muted-foreground mb-1">Location</h3>
                  <p class="text-base">
                    {{ selectedProject.branch }}, {{ selectedProject.address }}
                  </p>
                </div>
                <div>
                  <h3 class="text-sm font-medium text-muted-foreground mb-1">Duration</h3>
                  <p class="text-base">
                    {{ selectedProject.startDate }} - {{ selectedProject.endDate }}
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Project Description -->
          <div class="border-t pt-4">
            <h3 class="text-lg font-semibold mb-3">Project Description</h3>
            <p class="text-muted-foreground leading-relaxed">
              {{ selectedProject.description || 'No description available for this project.' }}
            </p>
          </div>

          <!-- Progress Section -->
          <div class="border-t pt-4">
            <h3 class="text-lg font-semibold mb-3">Project Progress</h3>
            <div class="space-y-2">
              <div class="flex justify-between text-sm">
                <span>Overall Progress</span>
                <span class="font-medium">{{ selectedProject.progress }}%</span>
              </div>
              <Progress :value="selectedProject.progress" class="h-2" />
            </div>
          </div>

          <!-- Additional Details (if available) -->
          <div class="border-t pt-4">
            <h3 class="text-lg font-semibold mb-3">Additional Information</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
              <div>
                <span class="text-muted-foreground">Project ID:</span>
                <span class="ml-2 font-mono">{{ selectedProject.id }}</span>
              </div>
              <div>
                <span class="text-muted-foreground">Last Updated:</span>
                <span class="ml-2">{{ new Date().toLocaleDateString() }}</span>
              </div>
            </div>
          </div>

          <!-- Workers Section -->
          <div class="border-t pt-4">
            <h3 class="text-lg font-semibold mb-3">Project Team</h3>
            <Accordion type="single" collapsible class="w-full">
              <AccordionItem value="workers">
                <AccordionTrigger class="text-left">
                  <div class="flex items-center justify-between w-full">
                    <span>Assigned Workers ({{ selectedProject.workers?.length || 0 }})</span>
                    <Badge variant="outline" class="ml-2">
                      {{ selectedProject.workers?.length || 0 }} workers
                    </Badge>
                  </div>
                </AccordionTrigger>
                <AccordionContent>
                  <div class="pt-2">
                    <div v-if="selectedProject.workers && selectedProject.workers.length > 0" class="space-y-2">
                      <div v-for="worker in selectedProject.workers" :key="worker.id"
                        class="flex items-center justify-between py-2 px-3 rounded-lg border border-border/50 bg-muted/30 hover:bg-muted/50 transition-colors">
                        <div class="flex items-center space-x-3">
                          <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
                            <span class="text-primary font-medium text-xs">
                              {{
                                worker.name
                                  .split(' ')
                                  .map((n) => n[0])
                                  .join('')
                                  .toUpperCase()
                              }}
                            </span>
                          </div>
                          <div>
                            <p class="font-medium text-sm">{{ worker.name }}</p>
                            <p class="text-xs text-muted-foreground">{{ worker.role }}</p>
                          </div>
                        </div>
                        <div class="text-right">
                          <p class="text-xs font-mono text-muted-foreground">
                            {{ worker.contact }}
                          </p>
                        </div>
                      </div>
                    </div>
                    <div v-else class="text-center py-8 text-muted-foreground">
                      <p class="text-sm">No workers assigned to this project yet.</p>
                    </div>
                  </div>
                </AccordionContent>
              </AccordionItem>
            </Accordion>
          </div>
        </div>

        <DialogFooter class="mt-6">
          <DialogClose asChild>
            <Button variant="secondary">Close</Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
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
