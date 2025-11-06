<script setup>
import { reactive, computed } from 'vue'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
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

// scripts

const props = defineProps({
  open: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['update:open'])

const isOpen = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value),
})

const projectForm = reactive({
  name: '',
  image: '',
  description: '',
  category: '',
  address: '',
  branch: '',
  projectManager: '',
  client: '',
  initialProgress: '',
  tasks: [],
  startDate: '',
  endDate: '',
  status: 'Inactive',
  notes: '',
})

const errors = reactive({})

const validateForm = () => {
  errors.name = projectForm.name ? '' : 'Project name is required'
  errors.description = projectForm.description ? '' : 'Description is required'
  errors.category = projectForm.category ? '' : 'Category is required'
  errors.address = projectForm.address ? '' : 'Address is required'
  errors.branch = projectForm.branch ? '' : 'Branch is required'
  errors.projectManager = projectForm.projectManager ? '' : 'Project manager is required'
  errors.startDate = projectForm.startDate ? '' : 'Start date is required'
  errors.endDate = projectForm.endDate ? '' : 'End date is required'
  if (projectForm.startDate && projectForm.endDate) {
    errors.endDate =
      new Date(projectForm.endDate) > new Date(projectForm.startDate)
        ? ''
        : 'End date must be after start date'
  }
  errors.status = projectForm.status ? '' : 'Status is required'

  return Object.values(errors).every((error) => !error)
}

const handleSubmit = () => {
  if (validateForm()) {
    // Handle form submission
    console.log('Form is valid:', projectForm)
    // Reset form or close modal
    emit('update:open', false)
  } else {
    console.log('Form has errors:', errors)
  }
}

const handleFileChange = (event) => {
  const file = event.target.files[0]
  if (file) {
    projectForm.image = file
    // Optional: Create a preview URL
    // projectForm.imageUrl = URL.createObjectURL(file)
  }
}
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogContent class="w-[95vw] sm:w-[640px] md:w-[768px] lg:w-[896px] max-w-full max-h-[90vh] flex flex-col p-4 sm:p-6">
      <DialogHeader>
        <DialogTitle>Create New Project</DialogTitle>
        <DialogDescription> Fill in the details for the new project. </DialogDescription>
      </DialogHeader>
      <div class="flex-1 overflow-y-auto scrollbar-hide">
        <form @submit.prevent="handleSubmit" class="space-y-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-3 sm:gap-4">
            <div class="space-y-2">
              <Label for="name">Project Name</Label>
              <Input
                id="name"
                v-model="projectForm.name"
                placeholder="Enter project name"
                required
              />
              <span v-if="errors.name" class="text-red-500 text-sm">{{ errors.name }}</span>
            </div>
            <div class="flex">
              <div class="flex-1 space-y-2">
                <Label for="category">Category</Label>
                <Select
                  id="category"
                  v-model="projectForm.category"
                  placeholder="Enter category"
                  required
                >
                  <SelectTrigger class="w-full">
                    <SelectValue placeholder="Select category" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Development">Development</SelectItem>
                    <SelectItem value="Renovation">Renovation</SelectItem>
                    <SelectItem value="Maintenance">Maintenance</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div class="space-y-2 col-span-2">
              <Label for="description">Description</Label>
              <Textarea
                id="description"
                v-model="projectForm.description"
                placeholder="Enter description"
                required
              ></Textarea>
            </div>
            <div class="space-y-2">
              <Label for="address">Address</Label>
              <Input
                id="address"
                v-model="projectForm.address"
                placeholder="Enter address"
                required
              />
            </div>
            <div class="space-y-2">
              <Label for="branch">Branch</Label>
              <Input id="branch" v-model="projectForm.branch" placeholder="Enter branch" required />
            </div>
            <div class="space-y-2">
              <Label for="projectManager">Project Manager</Label>
              <Input
                id="projectManager"
                v-model="projectForm.projectManager"
                placeholder="Enter project manager"
                required
              />
            </div>
            <div class="space-y-2">
              <Label for="client">Client</Label>
              <Input id="client" v-model="projectForm.client" placeholder="Enter client" required />
            </div>
            <div class="space-y-2">
              <Label for="initialProgress">Initial Progress (%)</Label>
              <Input
                id="initialProgress"
                type="number"
                v-model="projectForm.initialProgress"
                placeholder="0"
                required
              />
            </div>
            <div class="flex">
              <div class="flex-1 space-y-2">
                <Label for="status">Status</Label>
                <Select v-model="projectForm.status">
                  <SelectTrigger class="w-full">
                    <SelectValue placeholder="Select status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Inactive">Inactive</SelectItem>
                    <SelectItem value="In Progress">In Progress</SelectItem>
                    <SelectItem value="Completed">Completed</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div class="space-y-2">
              <Label for="startDate">Start Date</Label>
              <Input id="startDate" type="date" v-model="projectForm.startDate" required />
            </div>
            <div class="space-y-2">
              <Label for="endDate">End Date</Label>
              <Input id="endDate" type="date" v-model="projectForm.endDate" required />
            </div>
            <div class="flex space-x-2 col-span-2">
              <div class="space-y-2 flex-1">
                <Label for="image">Project Image</Label>
                <Input
                  id="image"
                  type="file"
                  @change="handleFileChange"
                  accept="image/*"
                  required
                />
              </div>
            </div>
          </div>
          <div class="space-y-2">
            <Label for="notes">Notes</Label>
            <Input id="notes" v-model="projectForm.notes" placeholder="Enter notes" required />
          </div>
        </form>
      </div>
      <div class="flex justify-end space-x-2">
        <Button type="button" @click="emit('update:open', false)" variant="outline">Cancel</Button>
        <Button type="button" @click="handleSubmit">Create Project</Button>
      </div>
    </DialogContent>
  </Dialog>
</template>

<style scoped>
.scrollbar-hide {
  scrollbar-width: none;
  -ms-overflow-style: none;
}
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
</style>
