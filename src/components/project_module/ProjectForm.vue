<script setup>
import { reactive, computed } from 'vue'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
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

const handleSubmit = () => {
  // Handle form submission
  console.log(projectForm)
}
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogContent class="max-w-2xl max-h-[90vh]">
      <DialogHeader>
        <DialogTitle>Create New Project</DialogTitle>
        <DialogDescription> Fill in the details for the new project. </DialogDescription>
      </DialogHeader>
      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div class="space-y-2">
            <Label for="name">Project Name</Label>
            <Input id="name" v-model="projectForm.name" placeholder="Enter project name" />
          </div>
          <div class="space-y-2">
            <Label for="category">Category</Label>
            <Input id="category" v-model="projectForm.category" placeholder="Enter category" />
          </div>
          <div class="space-y-2">
            <Label for="description">Description</Label>
            <Input
              id="description"
              v-model="projectForm.description"
              placeholder="Enter description"
            />
          </div>
          <div class="space-y-2">
            <Label for="address">Address</Label>
            <Input id="address" v-model="projectForm.address" placeholder="Enter address" />
          </div>
          <div class="space-y-2">
            <Label for="branch">Branch</Label>
            <Input id="branch" v-model="projectForm.branch" placeholder="Enter branch" />
          </div>
          <div class="space-y-2">
            <Label for="projectManager">Project Manager</Label>
            <Input
              id="projectManager"
              v-model="projectForm.projectManager"
              placeholder="Enter project manager"
            />
          </div>
          <div class="space-y-2">
            <Label for="client">Client</Label>
            <Input id="client" v-model="projectForm.client" placeholder="Enter client" />
          </div>
          <div class="space-y-2">
            <Label for="initialProgress">Initial Progress (%)</Label>
            <Input
              id="initialProgress"
              type="number"
              v-model="projectForm.initialProgress"
              placeholder="0"
            />
          </div>
          <div class="space-y-2">
            <Label for="startDate">Start Date</Label>
            <Input id="startDate" type="date" v-model="projectForm.startDate" />
          </div>
          <div class="space-y-2">
            <Label for="endDate">End Date</Label>
            <Input id="endDate" type="date" v-model="projectForm.endDate" />
          </div>
          <div class="space-y-2">
            <Label for="status">Status</Label>
            <Select v-model="projectForm.status">
              <SelectTrigger>
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
          <Label for="notes">Notes</Label>
          <Input id="notes" v-model="projectForm.notes" placeholder="Enter notes" />
        </div>
        <div class="flex justify-end space-x-2">
          <Button type="button" @click="isOpen = false" variant="outline">Cancel</Button>
          <Button type="submit">Create Project</Button>
        </div>
      </form>
    </DialogContent>
  </Dialog>
</template>
