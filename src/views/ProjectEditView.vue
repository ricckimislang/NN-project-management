<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { Textarea } from '@/components/ui/textarea'
import { Card } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { projectData } from '@/data/projectData'

const route = useRoute()
const router = useRouter()

// State
const project = ref(null)
const loading = ref(true)
const isSaving = ref(false)
const errors = ref({})
const hasChanges = ref(false)
const originalProject = ref(null)

// Computed
const projectId = computed(() => parseInt(route.params.id))

// Form state
const formData = ref({
  name: '',
  image: '',
  description: '',
  category: '',
  address: '',
  branch: '',
  projectManager: '',
  client: '',
  progress: 0,
  startDate: '',
  endDate: '',
  status: 'Not Started',
  notes: '',
  workers: [],
})

// Team member form state
const newWorker = ref({
  name: '',
  role: '',
  contact: '',
})
const showAddWorker = ref(false)

// Methods
const loadProject = () => {
  loading.value = true
  setTimeout(() => {
    const foundProject = projectData.find(p => p.id === projectId.value)
    if (foundProject) {
      project.value = foundProject
      originalProject.value = JSON.parse(JSON.stringify(foundProject))
      // Populate form with project data
      Object.keys(formData.value).forEach(key => {
        if (foundProject[key] !== undefined) {
          formData.value[key] = foundProject[key]
        }
      })
    } else {
      router.push('/projects')
    }
    loading.value = false
  }, 300)
}

const validateForm = () => {
  errors.value = {}

  if (!formData.value.name?.trim()) {
    errors.value.name = 'Project name is required'
  }
  if (!formData.value.description?.trim()) {
    errors.value.description = 'Description is required'
  }
  if (!formData.value.category) {
    errors.value.category = 'Category is required'
  }
  if (!formData.value.address?.trim()) {
    errors.value.address = 'Address is required'
  }
  if (!formData.value.branch?.trim()) {
    errors.value.branch = 'Branch is required'
  }
  if (!formData.value.projectManager?.trim()) {
    errors.value.projectManager = 'Project manager is required'
  }
  if (!formData.value.startDate) {
    errors.value.startDate = 'Start date is required'
  }
  if (!formData.value.endDate) {
    errors.value.endDate = 'End date is required'
  }
  if (formData.value.startDate && formData.value.endDate) {
    if (new Date(formData.value.endDate) <= new Date(formData.value.startDate)) {
      errors.value.endDate = 'End date must be after start date'
    }
  }
  if (formData.value.progress < 0 || formData.value.progress > 100) {
    errors.value.progress = 'Progress must be between 0 and 100'
  }

  return Object.keys(errors.value).length === 0
}

const handleFileChange = (event) => {
  const file = event.target.files[0]
  if (file) {
    // In a real app, you'd upload this to a server
    formData.value.image = file
  }
}

const handleSave = async () => {
  if (!validateForm()) {
    return
  }

  isSaving.value = true
  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 800))

    // Update project data (in real app, this would be an API call)
    const projectIndex = projectData.findIndex(p => p.id === projectId.value)
    if (projectIndex !== -1) {
      Object.keys(formData.value).forEach(key => {
        if (typeof formData.value[key] !== 'object') {
          projectData[projectIndex][key] = formData.value[key]
        }
      })
    }

    originalProject.value = JSON.parse(JSON.stringify(formData.value))
    hasChanges.value = false

    // Show success message (you could use a toast here)
    console.log('Project updated successfully')

    // Redirect back to project view
    setTimeout(() => {
      router.push(`/project/${projectId.value}`)
    }, 500)
  } catch (error) {
    console.error('Error saving project:', error)
  } finally {
    isSaving.value = false
  }
}

const handleCancel = () => {
  if (hasChanges.value) {
    if (confirm('You have unsaved changes. Are you sure you want to discard them?')) {
      router.back()
    }
  } else {
    router.back()
  }
}

const checkForChanges = () => {
  hasChanges.value = JSON.stringify(formData.value) !== JSON.stringify(originalProject.value)
}

const addWorker = () => {
  if (!newWorker.value.name?.trim() || !newWorker.value.role?.trim() || !newWorker.value.contact?.trim()) {
    return
  }

  const worker = {
    id: Date.now(),
    name: newWorker.value.name,
    role: newWorker.value.role,
    contact: newWorker.value.contact,
  }

  formData.value.workers.push(worker)
  newWorker.value = { name: '', role: '', contact: '' }
  showAddWorker.value = false
  checkForChanges()
}

const removeWorker = (workerId) => {
  formData.value.workers = formData.value.workers.filter(w => w.id !== workerId)
  checkForChanges()
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
        <BreadCrumbs :url="'/projects'" title="Projects" :project-name="`Edit: ${project?.name}`"></BreadCrumbs>
      </div>
      <div class="flex gap-2">
        <Button variant="outline" @click="handleCancel">
          <i class="fa-solid fa-times mr-2"></i>Cancel
        </Button>
        <Button @click="handleSave" :disabled="isSaving || !hasChanges">
          <i class="fa-solid fa-check mr-2"></i>{{ isSaving ? 'Saving...' : 'Save Changes' }}
        </Button>
      </div>
    </div>

    <!-- Main Edit Form -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <!-- Main Content -->
      <div class="lg:col-span-2 space-y-6">
        <!-- Project Image Section -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Project Image</h2>
          <div class="space-y-4">
            <div v-if="formData.image && typeof formData.image === 'string'"
              class="rounded-lg overflow-hidden bg-muted">
              <img :src="formData.image" :alt="formData.name" class="w-full h-64 object-cover" />
            </div>
            <div class="space-y-2">
              <Label for="image">Upload New Image</Label>
              <Input id="image" type="file" accept="image/*" @change="handleFileChange" />
              <p class="text-xs text-muted-foreground">Recommended: 1200x800px or larger</p>
            </div>
          </div>
        </Card>

        <!-- Basic Information -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Basic Information</h2>
          <div class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="space-y-2">
                <Label for="name">Project Name *</Label>
                <Input id="name" v-model="formData.name" placeholder="Enter project name" @input="checkForChanges" />
                <span v-if="errors.name" class="text-red-500 text-sm">{{ errors.name }}</span>
              </div>

              <div class="space-y-2">
                <Label for="category">Category *</Label>
                <Select v-model="formData.category" @update:model-value="checkForChanges">
                  <SelectTrigger id="category">
                    <SelectValue placeholder="Select category" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Development">Development</SelectItem>
                    <SelectItem value="Renovation">Renovation</SelectItem>
                    <SelectItem value="Maintenance">Maintenance</SelectItem>
                  </SelectContent>
                </Select>
                <span v-if="errors.category" class="text-red-500 text-sm">{{ errors.category }}</span>
              </div>
            </div>

            <div class="space-y-2">
              <Label for="description">Description *</Label>
              <Textarea id="description" v-model="formData.description" placeholder="Enter project description" rows="4"
                @input="checkForChanges" />
              <span v-if="errors.description" class="text-red-500 text-sm">{{ errors.description }}</span>
            </div>
          </div>
        </Card>

        <!-- Location Information -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Location Information</h2>
          <div class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="space-y-2">
                <Label for="address">Address *</Label>
                <Input id="address" v-model="formData.address" placeholder="Enter address" @input="checkForChanges" />
                <span v-if="errors.address" class="text-red-500 text-sm">{{ errors.address }}</span>
              </div>

              <div class="space-y-2">
                <Label for="branch">Branch *</Label>
                <Input id="branch" v-model="formData.branch" placeholder="Enter branch" @input="checkForChanges" />
                <span v-if="errors.branch" class="text-red-500 text-sm">{{ errors.branch }}</span>
              </div>
            </div>
          </div>
        </Card>

        <!-- Timeline Information -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Project Timeline</h2>
          <div class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="space-y-2">
                <Label for="startDate">Start Date *</Label>
                <Input id="startDate" type="date" v-model="formData.startDate" @input="checkForChanges" />
                <span v-if="errors.startDate" class="text-red-500 text-sm">{{ errors.startDate }}</span>
              </div>

              <div class="space-y-2">
                <Label for="endDate">End Date *</Label>
                <Input id="endDate" type="date" v-model="formData.endDate" @input="checkForChanges" />
                <span v-if="errors.endDate" class="text-red-500 text-sm">{{ errors.endDate }}</span>
              </div>
            </div>
          </div>
        </Card>

        <!-- Project Status and Progress -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Status & Progress</h2>
          <div class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="space-y-2">
                <Label for="status">Status *</Label>
                <Select v-model="formData.status" @update:model-value="checkForChanges">
                  <SelectTrigger id="status">
                    <SelectValue placeholder="Select status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Not Started">Not Started</SelectItem>
                    <SelectItem value="In Progress">In Progress</SelectItem>
                    <SelectItem value="Completed">Completed</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div class="space-y-2">
                <Label for="progress">Progress (%) *</Label>
                <div class="flex items-center gap-2">
                  <Input id="progress" type="number" v-model.number="formData.progress" min="0" max="100"
                    placeholder="0" @input="checkForChanges" class="flex-1" />
                  <span class="text-sm font-medium w-12 text-right">{{ formData.progress }}%</span>
                </div>
                <span v-if="errors.progress" class="text-red-500 text-sm">{{ errors.progress }}</span>
              </div>
            </div>
          </div>
        </Card>

        <!-- Team Information -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Team Information</h2>
          <div class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="space-y-2">
                <Label for="projectManager">Project Manager *</Label>
                <Input id="projectManager" v-model="formData.projectManager" placeholder="Enter project manager name"
                  @input="checkForChanges" />
                <span v-if="errors.projectManager" class="text-red-500 text-sm">{{ errors.projectManager
                }}</span>
              </div>

              <div class="space-y-2">
                <Label for="client">Client</Label>
                <Input id="client" v-model="formData.client" placeholder="Enter client name" @input="checkForChanges" />
              </div>
            </div>
          </div>
        </Card>

        <!-- Additional Notes -->
        <Card class="p-6">
          <h2 class="text-xl font-semibold mb-4">Additional Notes</h2>
          <div class="space-y-2">
            <Label for="notes">Notes</Label>
            <Textarea id="notes" v-model="formData.notes" placeholder="Enter any additional notes about this project"
              rows="4" @input="checkForChanges" />
          </div>
        </Card>

        <!-- Team Members Management -->
        <Card class="p-6">
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-xl font-semibold">Team Members</h2>
            <Button v-if="!showAddWorker" size="sm" @click="showAddWorker = true" class="gap-2">
              <i class="fa-solid fa-plus"></i>Add Member
            </Button>
          </div>

          <!-- Add Worker Form -->
          <div v-if="showAddWorker" class="mb-6 p-4 border rounded-lg bg-muted/30 space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div class="space-y-2">
                <Label for="workerName">Name</Label>
                <Input id="workerName" v-model="newWorker.name" placeholder="Enter worker name" />
              </div>
              <div class="space-y-2">
                <Label for="workerRole">Role</Label>
                <Input id="workerRole" v-model="newWorker.role" placeholder="e.g., Engineer, Manager" />
              </div>
              <div class="space-y-2">
                <Label for="workerContact">Contact</Label>
                <Input id="workerContact" v-model="newWorker.contact" placeholder="Phone or email" />
              </div>
            </div>
            <div class="flex gap-2">
              <Button size="sm" @click="addWorker" class="gap-2">
                <i class="fa-solid fa-check"></i>Add
              </Button>
              <Button size="sm" variant="outline" @click="showAddWorker = false" class="gap-2">
                <i class="fa-solid fa-times"></i>Cancel
              </Button>
            </div>
          </div>

          <!-- Workers List -->
          <div class="space-y-3">
            <div v-if="formData.workers.length === 0" class="text-center py-8 text-muted-foreground">
              <p class="text-sm">No team members assigned yet.</p>
            </div>
            <div v-for="worker in formData.workers" :key="worker.id"
              class="flex items-center justify-between p-4 border rounded-lg hover:bg-muted/50 transition-colors">
              <div class="flex-1">
                <p class="font-medium">{{ worker.name }}</p>
                <p class="text-sm text-muted-foreground">{{ worker.role }}</p>
                <p class="text-xs text-muted-foreground mt-1">{{ worker.contact }}</p>
              </div>
              <Button size="sm" variant="destructive" @click="removeWorker(worker.id)" class="gap-2">
                <i class="fa-solid fa-trash"></i>Remove
              </Button>
            </div>
          </div>
        </Card>
      </div>

      <!-- Sidebar -->
      <div class="space-y-6">
        <!-- Changes Summary -->
        <Card class="p-6">
          <h3 class="font-semibold mb-4">Changes Summary</h3>
          <div class="space-y-3">
            <div class="flex items-center justify-between py-2 border-b">
              <span class="text-sm text-muted-foreground">Status</span>
              <Badge variant="outline">
                {{ hasChanges ? 'Unsaved' : 'Saved' }}
              </Badge>
            </div>
            <div class="text-xs text-muted-foreground space-y-2">
              <p>* Required fields</p>
              <p v-if="hasChanges" class="text-amber-600 font-medium">
                You have unsaved changes
              </p>
              <p v-else class="text-green-600 font-medium">
                All changes are saved
              </p>
            </div>
          </div>
        </Card>

        <!-- Project Info Card -->
        <Card class="p-6">
          <h3 class="font-semibold mb-4">Project Information</h3>
          <div class="space-y-3 text-sm">
            <div>
              <p class="text-muted-foreground">Project ID</p>
              <p class="font-mono text-xs">{{ project?.id }}</p>
            </div>
            <div class="border-t pt-3">
              <p class="text-muted-foreground">Created</p>
              <p class="text-xs">{{ new Date().toLocaleDateString() }}</p>
            </div>
            <div class="border-t pt-3">
              <p class="text-muted-foreground">Last Modified</p>
              <p class="text-xs">{{ new Date().toLocaleDateString() }}</p>
            </div>
          </div>
        </Card>

        <!-- Quick Actions -->
        <Card class="p-6">
          <h3 class="font-semibold mb-4">Quick Actions</h3>
          <div class="space-y-2">
            <Button variant="outline" class="w-full justify-start text-sm"
              @click="router.push(`/project/${projectId}`)">
              <i class="fa-solid fa-eye mr-2"></i>View Project
            </Button>
            <Button variant="outline" class="w-full justify-start text-sm" disabled>
              <i class="fa-solid fa-trash mr-2"></i>Delete Project
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
      <p class="text-muted-foreground">Loading project...</p>
    </div>
  </div>
</template>
