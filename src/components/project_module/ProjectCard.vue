<script setup>
import { ref, onMounted } from 'vue'
import { Card } from '@/components/ui/card'
import { Progress } from '@/components/ui/progress'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { DropdownMenuItem } from '@/components/ui/dropdown-menu'
import AppDropdownMenu from '@/components/layout/AppDropdownMenu.vue'
import { AspectRatio } from '@/components/ui/aspect-ratio'
import projectImage from '@/assets/images/projects/project-1.jpg'

const progress = ref(0)

onMounted(() => {
  // Animate progress from 0 to 65
  const target = 65
  const duration = 300 // 1.5 seconds
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
  <Card class="p-4">
    <div class="flex flex-col">
      <!-- Changed to vertical flex -->
      <div class="flex space-x-4">
        <!-- Top row: image and details -->
        <div class="flex items-center space-x-3">
          <div
            class="w-40 h-40 overflow-hidden rounded-lg bg-muted flex items-center justify-center"
          >
            <AspectRatio :ratio="1 / 1">
              <img class="w-full h-full object-fill" :src="projectImage" alt="" />
            </AspectRatio>
          </div>
        </div>
        <div class="flex flex-col flex-1">
          <div class="relative flex-1 space-y-2">
            <!-- Details column with relative positioning -->
            <div class="space-y-1">
              <h3 class="text-base text-xl font-semibold text-foreground">
                Downtown Office Renovation
              </h3>
              <p class="text-sm text-muted-foreground">Renovation</p>
            </div>
            <div class="space-x-1">
              <p class="text-sm text-muted-foreground">📅 Jan 15, 2024 - Jun 30, 2024</p>
              <p class="text-sm text-muted-foreground">👥 Sarah Johnson</p>
            </div>
            <!-- Badge and dropdown moved to absolute position -->
            <div class="absolute top-2 right-2 flex items-center space-x-2">
              <Badge variant="success">In Progress</Badge>
              <div class="relative">
                <AppDropdownMenu side="left">
                  <template #trigger>
                    <Button variant="ghost" size="sm">
                      <i class="fa-solid fa-ellipsis-vertical"></i>
                    </Button>
                  </template>
                  <template #content>
                    <DropdownMenuItem>View</DropdownMenuItem>
                    <DropdownMenuItem>Edit</DropdownMenuItem>
                    <DropdownMenuItem>Archive</DropdownMenuItem>
                    <DropdownMenuItem class="text-destructive">Delete</DropdownMenuItem>
                  </template>
                </AppDropdownMenu>
              </div>
            </div>
            <!-- Progress bar at the bottom of details -->
            <div class="flex flex-col justify-end flex-1 mt-4">
              <div class="flex justify-between text-xs mb-1">
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
</template>
