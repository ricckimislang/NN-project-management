<script setup>
// Imports
import { ref, reactive, onMounted, computed } from 'vue'
import { Card } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { DropdownMenuItem } from '@/components/ui/dropdown-menu'
import AppDropdownMenu from '@/components/layout/AppDropdownMenu.vue'
import { AspectRatio } from '@/components/ui/aspect-ratio'
import projectImage from '@/assets/images/projects/project-1.jpg'
import { ScrollArea } from '@/components/ui/scroll-area'
import { useIntersectionObserver, useBreakpoints } from '@vueuse/core'

// Scripts
const progress = ref(0)
const scrollArea = ref()
const cardRefs = ref([])
const breakpoints = useBreakpoints({ sm: 640, md: 768, lg: 1024, xl: 1280, '2xl': 1536 })
const isBelowLg = breakpoints.smaller('lg')
const dropdownSide = computed(() => (isBelowLg.value ? 'top' : 'bottom'))

const projects = reactive([
  {
    id: 1,
    name: 'Downtown Office Renovation',
    description: 'Renovation',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Napala',
    image: projectImage,
    startDate: '2024-01-15',
    endDate: '2024-06-30',
    status: 'In Progress',
    progress: 65,
    projectManager: 'John Doe',
  },
  {
    id: 2,
    name: 'General Hospital',
    description: 'Hospital Rooms',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Napala',
    image: projectImage,
    startDate: '2024-01-20',
    endDate: '2024-08-30',
    status: 'In Progress',
    progress: 35,
    projectManager: 'John Doe',
  },
  {
    id: 3,
    name: 'General Hospital',
    description: 'Hospital Rooms',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Kulinas',
    image: projectImage,
    startDate: '2024-01-20',
    endDate: '2024-08-30',
    status: 'In Progress',
    progress: 35,
    projectManager: 'John Doe',
  },
  {
    id: 4,
    name: 'General Hospital',
    description: 'Hospital Rooms',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Kulinas',
    image: projectImage,
    startDate: '2024-01-20',
    endDate: '2024-08-30',
    status: 'In Progress',
    progress: 35,
    projectManager: 'John Doe',
  },
  {
    id: 5,
    name: 'General Hospital',
    description: 'Hospital Rooms',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Kulinas',
    image: projectImage,
    startDate: '2024-01-20',
    endDate: '2024-08-30',
    status: 'In Progress',
    progress: 35,
    projectManager: 'John Doe',
  },
  {
    id: 6,
    name: 'General Hospital',
    description: 'Hospital Rooms',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Kulinas',
    image: projectImage,
    startDate: '2024-01-20',
    endDate: '2024-08-30',
    status: 'In Progress',
    progress: 35,
    projectManager: 'John Doe',
  },
  {
    id: 7,
    name: 'General Hospital',
    description: 'Hospital Rooms',
    category: 'Development',
    address: 'General Santos City',
    branch: 'Kulinas',
    image: projectImage,
    startDate: '2024-01-20',
    endDate: '2024-08-30',
    status: 'In Progress',
    progress: 35,
    projectManager: 'John Doe',
  },
])

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

  // Animate progress from 0 to 65
  const target = 65
  const duration = 300 // .3 seconds
  const increment = target / (duration / 16) // ~60fps
  const timer = setInterval(() => {
    progress.value += increment
    if (progress.value >= target) {
      progress.value = target
      clearInterval(timer)
    }
  }, 16)
})
</script>

<template>
  <ScrollArea ref="scrollArea" class="h-[calc(100vh-90px)]">
    <div class="space-y-3 sm:space-y-4 px-2 sm:px-4">
      <div v-for="(project, index) in projects" :key="project.id">
        <Card class="p-2 sm:p-3 md:p-4 opacity-0" :ref="(el) => (cardRefs[index] = el)">
          <div class="flex flex-col">
            <!-- Responsive flex: column on mobile, row on md+ -->
            <div class="flex flex-col gap-2.5 sm:gap-3 md:flex-row md:gap-4">
              <!-- Image section -->
              <div
                class="flex justify-center md:justify-start md:items-center mb-3 sm:mb-4 md:mb-0"
              >
                <div
                  class="w-full max-w-[120px] sm:max-w-[160px] md:w-36 md:h-36 lg:w-40 lg:h-40 overflow-hidden rounded-lg bg-muted flex items-center justify-center"
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
                    <Badge variant="success" class="text-[10px] sm:text-xs">{{
                      project.status
                    }}</Badge>
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
                      <span>{{ Math.round(progress) }}%</span>
                    </div>
                    <Progress :value="progress" />
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
