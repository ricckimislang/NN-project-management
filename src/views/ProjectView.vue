<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Card } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { AspectRatio } from '@/components/ui/aspect-ratio'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { projectData } from '@/data/projectData'

const route = useRoute()
const router = useRouter()

// State
const project = ref(null)
const loading = ref(true)

// Computed
const projectId = computed(() => parseInt(route.params.id))

const statusColor = computed(() => {
  if (!project.value) return 'secondary'
  const status = project.value.status
  if (status === 'Completed') return 'success'
  if (status === 'In Progress') return 'warning'
  return 'secondary'
})

// Methods
const loadProject = () => {
  loading.value = true
  // Simulate API call delay
  setTimeout(() => {
    const foundProject = projectData.find(p => p.id === projectId.value)
    if (foundProject) {
      project.value = foundProject
    } else {
      router.push('/projects')
    }
    loading.value = false
  }, 300)
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })
}

const calculateDuration = () => {
  if (!project.value) return ''
  const start = new Date(project.value.startDate)
  const end = new Date(project.value.endDate)
  const days = Math.ceil((end - start) / (1000 * 60 * 60 * 24))
  return `${days} days`
}

// Lifecycle
onMounted(() => {
  loadProject()
})
</script>

<template>
  <div v-if="!loading" class="space-y-6">
    <!-- Toolbar -->
    <div class="toolbar flex flex-col sm:flex-row sm:justify-between sm:items-center gap-3 sm:gap-4">
      <div>
        <BreadCrumbs :url="'/projects'" title="Projects" :project-name="project?.name"></BreadCrumbs>
      </div>
      <div class="flex gap-2">
        <Button variant="outline" @click="router.back()">
          <i class="fa-solid fa-arrow-left mr-2"></i>Back
        </Button>
      </div>
    </div>

    <!-- Project Header -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Main Content -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Project Image -->
        <Card class="overflow-hidden">
          <AspectRatio :ratio="16 / 9">
            <img :src="project.image" :alt="project.name" class="w-full h-full object-cover" />
          </AspectRatio>
        </Card>

        <!-- Project Title and Basic Info -->
        <Card class="p-6">
          <div class="space-y-4">
            <div class="flex items-start justify-between gap-4">
              <div class="space-y-2 flex-1">
                <h1 class="text-3xl font-bold">{{ project.name }}</h1>
                <p class="text-gray-600">{{ project.description }}</p>
              </div>
              <Badge :variant="statusColor === 'success' ? 'success' : 'secondary'">
                {{ project.status }}
              </Badge>
            </div>

            <!-- Quick Stats -->
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 pt-4 border-t">
              <div>
                <p class="text-sm text-gray-600">Category</p>
                <p class="font-semibold">{{ project.category }}</p>
              </div>
              <div>
                <p class="text-sm text-gray-600">Branch</p>
                <p class="font-semibold">{{ project.branch }}</p>
              </div>
              <div>
                <p class="text-sm text-gray-600">Progress</p>
                <p class="font-semibold">{{ project.progress }}%</p>
              </div>
              <div>
                <p class="text-sm text-gray-600">Duration</p>
                <p class="font-semibold">{{ calculateDuration() }}</p>
              </div>
            </div>
          </div>
        </Card>

        <!-- Progress Bar -->
        <Card class="p-6">
          <div class="space-y-3">
            <div class="flex justify-between items-center">
              <h3 class="font-semibold">Project Progress</h3>
              <span class="text-sm font-medium">{{ project.progress }}%</span>
            </div>
            <Progress :value="project.progress" class="h-3" />
            <div class="flex justify-between text-xs text-gray-600">
              <span>Start: {{ formatDate(project.startDate) }}</span>
              <span>End: {{ formatDate(project.endDate) }}</span>
            </div>
          </div>
        </Card>

        <!-- Tabs for Details -->
        <Tabs defaultValue="details" class="w-full">
          <TabsList class="grid w-full grid-cols-2">
            <TabsTrigger value="details">Project Details</TabsTrigger>
            <TabsTrigger value="members">Team Members</TabsTrigger>
          </TabsList>

          <!-- Project Details Tab -->
          <TabsContent value="details" class="space-y-4">
            <Card class="p-6">
              <div class="space-y-6">
                <!-- Location Info -->
                <div>
                  <h3 class="font-semibold mb-4 flex items-center gap-2">
                    <i class="fa-solid fa-map-pin text-blue-500"></i>
                    Location Information
                  </h3>
                  <div class="space-y-3 ml-6">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <p class="text-sm text-gray-600">Address</p>
                        <p class="font-medium">{{ project.address }}</p>
                      </div>
                      <div>
                        <p class="text-sm text-gray-600">Branch</p>
                        <p class="font-medium">{{ project.branch }}</p>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Project Timeline -->
                <div class="border-t pt-6">
                  <h3 class="font-semibold mb-4 flex items-center gap-2">
                    <i class="fa-solid fa-calendar text-green-500"></i>
                    Project Timeline
                  </h3>
                  <div class="space-y-3 ml-6">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <p class="text-sm text-gray-600">Start Date</p>
                        <p class="font-medium">{{ formatDate(project.startDate) }}</p>
                      </div>
                      <div>
                        <p class="text-sm text-gray-600">End Date</p>
                        <p class="font-medium">{{ formatDate(project.endDate) }}</p>
                      </div>
                    </div>
                    <div>
                      <p class="text-sm text-gray-600">Duration</p>
                      <p class="font-medium">{{ calculateDuration() }}</p>
                    </div>
                  </div>
                </div>

                <!-- Project Status -->
                <div class="border-t pt-6">
                  <h3 class="font-semibold mb-4 flex items-center gap-2">
                    <i class="fa-solid fa-chart-line text-purple-500"></i>
                    Project Status
                  </h3>
                  <div class="space-y-3 ml-6">
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                      <div>
                        <p class="text-sm text-gray-600">Status</p>
                        <Badge :variant="statusColor === 'success' ? 'success' : 'secondary'">
                          {{ project.status }}
                        </Badge>
                      </div>
                      <div>
                        <p class="text-sm text-gray-600">Progress</p>
                        <p class="font-medium">{{ project.progress }}%</p>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </Card>
          </TabsContent>

          <!-- Team Members Tab -->
          <TabsContent value="members" class="space-y-4">
            <Card class="p-6">
              <div class="space-y-6">
                <!-- Project Manager -->
                <div>
                  <h3 class="font-semibold mb-4 flex items-center gap-2">
                    <i class="fa-solid fa-user-tie text-blue-500"></i>
                    Project Manager
                  </h3>
                  <div class="ml-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
                    <p class="font-medium">{{ project.projectManager }}</p>
                  </div>
                </div>

                <!-- Team Members -->
                <div class="border-t pt-6">
                  <h3 class="font-semibold mb-4 flex items-center gap-2">
                    <i class="fa-solid fa-users text-green-500"></i>
                    Team Members ({{ project.workers.length }})
                  </h3>
                  <div class="ml-6 space-y-3">
                    <div v-for="worker in project.workers" :key="worker.id"
                      class="p-4 border rounded-lg hover:bg-gray-50 transition-colors">
                      <div class="flex items-start justify-between gap-4">
                        <div class="flex-1">
                          <p class="font-medium">{{ worker.name }}</p>
                          <p class="text-sm text-gray-600">{{ worker.role }}</p>
                        </div>
                        <Badge variant="outline">{{ worker.role }}</Badge>
                      </div>
                      <div class="mt-3 flex items-center gap-2 text-sm text-gray-600">
                        <i class="fa-solid fa-phone"></i>
                        <a :href="`tel:${worker.contact}`" class="hover:text-blue-500">
                          {{ worker.contact }}
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </Card>
          </TabsContent>
        </Tabs>
      </div>

      <!-- Sidebar -->
      <div class="space-y-6">
        <!-- Summary Card -->
        <Card class="p-6 relative">
          <h3 class="font-semibold mb-4">Project Summary</h3>
          <div class="space-y-4">
            <div class="flex justify-between items-center py-2 border-b">
              <span class="text-sm text-gray-600">Status</span>
              <Badge :variant="statusColor === 'success' ? 'success' : 'secondary'">
                {{ project.status }}
              </Badge>
            </div>
            <div class="flex justify-between items-center py-2 border-b">
              <span class="text-sm text-gray-600">Progress</span>
              <span class="font-semibold">{{ project.progress }}%</span>
            </div>
            <div class="flex justify-between items-center py-2 border-b">
              <span class="text-sm text-gray-600">Category</span>
              <span class="font-medium text-sm">{{ project.category }}</span>
            </div>
            <div class="flex justify-between items-center py-2 border-b">
              <span class="text-sm text-gray-600">Team Size</span>
              <span class="font-semibold">{{ project.workers.length }} members</span>
            </div>
            <div class="flex justify-between items-center py-2">
              <span class="text-sm text-gray-600">Manager</span>
              <span class="font-medium text-sm">{{ project.projectManager }}</span>
            </div>
          </div>
        </Card>

        <!-- Quick Actions -->
        <Card class="p-6">
          <h3 class="font-semibold mb-4">Quick Actions</h3>
          <div class="space-y-2">
            <Button variant="outline" class="w-full justify-start">
              <i class="fa-solid fa-pen mr-2"></i>Edit Project
            </Button>
            <Button variant="outline" class="w-full justify-start">
              <i class="fa-solid fa-download mr-2"></i>Export Report
            </Button>
            <Button variant="outline" class="w-full justify-start">
              <i class="fa-solid fa-share mr-2"></i>Share Project
            </Button>
          </div>
        </Card>
      </div>
    </div>
  </div>

  <!-- Loading State -->
  <div v-else class="flex items-center justify-center py-12">
    <div class="text-center">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mb-4"></div>
      <p class="text-gray-600">Loading project details...</p>
    </div>
  </div>
</template>
