<script setup>
import { ref, computed, onMounted } from 'vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
import { Card } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Checkbox } from '@/components/ui/checkbox'
import { Trash2, Edit2, UserPlus, ArrowRightLeft, Eye } from 'lucide-vue-next'

const loading = ref(true)
const searchQuery = ref('')
const roleFilter = ref('all')
const projectFilter = ref('all')
const showUnassignedOnly = ref(false)
const sortBy = ref('name')
const sortOrder = ref('asc')

const showCreateModal = ref(false)
const showEditModal = ref(false)
const showAssignModal = ref(false)
const showRemoveModal = ref(false)
const modalMode = ref('assign') // assign | transfer

const currentEmployee = ref(null)
const assignSelectionSingle = ref('')
const assignSelectionMulti = ref([])

const formData = ref({
  name: '',
  email: '',
  role: '',
  status: 'active',
})

const formErrors = ref({})
const employees = ref([])

const projectOptions = ['Downtown Office Renovation', 'Seaside Residences', 'Gensan Mall Expansion', 'Warehouse Fit-out']

const mockEmployees = [
  {
    id: 1,
    name: 'Carlos Santos',
    email: 'carlos@example.com',
    role: 'Foreman',
    project: 'Downtown Office Renovation',
    status: 'active',
    joinDate: '2024-01-15',
    assignedProjects: ['Downtown Office Renovation', 'Seaside Residences'],
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos',
  },
  {
    id: 2,
    name: 'Ramon Reyes',
    email: 'ramon@example.com',
    role: 'Carpenter',
    project: 'Seaside Residences',
    status: 'active',
    joinDate: '2024-02-20',
    assignedProjects: ['Seaside Residences'],
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Ramon',
  },
  {
    id: 3,
    name: 'Jose Martinez',
    email: 'jose@example.com',
    role: 'Electrician',
    project: '',
    status: 'inactive',
    joinDate: '2023-11-10',
    assignedProjects: [],
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Jose',
  },
  {
    id: 4,
    name: 'Miguel Torres',
    email: 'miguel@example.com',
    role: 'Foreman',
    project: 'Gensan Mall Expansion',
    status: 'active',
    joinDate: '2024-03-18',
    assignedProjects: ['Gensan Mall Expansion'],
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Miguel',
  },
  {
    id: 5,
    name: 'Juan Dela Cruz',
    email: 'juan@example.com',
    role: 'Mason',
    project: 'Warehouse Fit-out',
    status: 'active',
    joinDate: '2024-03-25',
    assignedProjects: ['Warehouse Fit-out'],
    avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Juan',
  },
]

const isForeman = (employee) => employee?.role?.toLowerCase().includes('foreman')

const filteredEmployees = computed(() => {
  let filtered = employees.value.filter((emp) => {
    const matchesSearch =
      emp.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      emp.email.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      emp.role.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      (emp.project || '').toLowerCase().includes(searchQuery.value.toLowerCase())

    const matchesRole = roleFilter.value === 'all' || emp.role === roleFilter.value
    const matchesProject =
      projectFilter.value === 'all' ||
      (emp.assignedProjects || []).some((p) => p === projectFilter.value)
    const matchesUnassigned = showUnassignedOnly.value ? (emp.assignedProjects?.length || 0) === 0 : true

    return matchesSearch && matchesRole && matchesProject && matchesUnassigned
  })

  filtered.sort((a, b) => {
    let aVal = a[sortBy.value] ?? ''
    let bVal = b[sortBy.value] ?? ''

    if (typeof aVal === 'string') {
      aVal = aVal.toLowerCase()
      bVal = bVal.toLowerCase()
    }

    if (sortOrder.value === 'asc') {
      return aVal > bVal ? 1 : -1
    }
    return aVal < bVal ? 1 : -1
  })

  return filtered
})

const statusColorMap = {
  active: 'success',
  inactive: 'secondary',
  on_leave: 'warning',
}

const uniqueRoles = computed(() => ['all', ...new Set(employees.value.map((e) => e.role))])

const loadEmployees = () => {
  loading.value = true
  setTimeout(() => {
    employees.value = mockEmployees
    loading.value = false
  }, 150)
}

const resetForm = () => {
  formData.value = {
    name: '',
    email: '',
    role: '',
    status: 'active',
  }
  formErrors.value = {}
}

const validateForm = () => {
  formErrors.value = {}
  if (!formData.value.name.trim()) formErrors.value.name = 'Name is required'
  if (!formData.value.email.trim()) {
    formErrors.value.email = 'Email is required'
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.value.email)) {
    formErrors.value.email = 'Invalid email format'
  }
  if (!formData.value.role.trim()) formErrors.value.role = 'Role is required'
  return Object.keys(formErrors.value).length === 0
}

const saveEmployee = () => {
  if (!validateForm()) return

  if (currentEmployee.value) {
    const index = employees.value.findIndex((e) => e.id === currentEmployee.value.id)
    if (index !== -1) {
      employees.value[index] = { ...employees.value[index], ...formData.value }
    }
    showEditModal.value = false
  } else {
    const newEmployee = {
      id: Math.max(...employees.value.map((e) => e.id), 0) + 1,
      ...formData.value,
      joinDate: new Date().toISOString().split('T')[0],
      assignedProjects: [],
      project: '',
      avatar: `https://api.dicebear.com/7.x/avataaars/svg?seed=${encodeURIComponent(formData.value.name || 'New')}`,
    }
    employees.value.push(newEmployee)
    showCreateModal.value = false
  }
  resetForm()
}

const openCreateModal = () => {
  currentEmployee.value = null
  resetForm()
  showCreateModal.value = true
}

const openEditModal = (employee) => {
  currentEmployee.value = employee
  formData.value = { ...employee }
  showEditModal.value = true
}

const openViewModal = (employee) => {
  currentEmployee.value = employee
  showViewModal.value = true
}

const showViewModal = ref(false)

const toggleSort = (field) => {
  if (sortBy.value === field) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = field
    sortOrder.value = 'asc'
  }
}

const setAssignmentSelections = (employee) => {
  if (!employee) return
  if (isForeman(employee)) {
    assignSelectionMulti.value = [...(employee.assignedProjects || [])]
  } else {
    assignSelectionSingle.value = employee.assignedProjects?.[0] || 'unassigned'
  }
}

const openAssignModal = (employee, mode = 'assign') => {
  modalMode.value = mode
  currentEmployee.value = employee
  setAssignmentSelections(employee)
  showAssignModal.value = true
}

const resetAssignState = () => {
  assignSelectionSingle.value = 'unassigned'
  assignSelectionMulti.value = []
  currentEmployee.value = null
  modalMode.value = 'assign'
}

const closeAssignModal = () => {
  showAssignModal.value = false
  resetAssignState()
}

const applyAssignment = () => {
  if (!currentEmployee.value) return
  const targetId = currentEmployee.value.id
  employees.value = employees.value.map((emp) => {
    if (emp.id !== targetId) return emp
    const updated = { ...emp }
    if (isForeman(emp)) {
      updated.assignedProjects = [...assignSelectionMulti.value]
      updated.project = updated.assignedProjects[0] || ''
    } else {
      updated.assignedProjects = assignSelectionSingle.value && assignSelectionSingle.value !== 'unassigned' ? [assignSelectionSingle.value] : []
      updated.project = updated.assignedProjects[0] || ''
    }
    return updated
  })
  closeAssignModal()
}

const confirmRemove = () => {
  if (!currentEmployee.value) return
  employees.value = employees.value.filter((e) => e.id !== currentEmployee.value.id)
  showRemoveModal.value = false
  currentEmployee.value = null
}

const openRemoveModal = (employee) => {
  currentEmployee.value = employee
  showRemoveModal.value = true
}

const roleBadgeVariant = (role) => {
  if (role.toLowerCase().includes('foreman')) return 'default'
  return 'outline'
}

onMounted(() => {
  loadEmployees()
})
</script>

<template>
  <div class="space-y-6">
    <!-- Toolbar -->
    <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center gap-3 sm:gap-4">
      <BreadCrumbs :url="'/team'" title="Team Management" />
      <Button @click="openCreateModal" class="w-full sm:w-auto">
        <UserPlus class="w-4 h-4 mr-2" />
        Add Employee
      </Button>
    </div>

    <!-- Search + Filters -->
    <Card class="p-4 space-y-3">
      <div class="flex flex-col lg:flex-row gap-3">
        <Input
          v-model="searchQuery"
          placeholder="Search by name, email, role, or project"
          class="flex-1"
        />
        <Select v-model="roleFilter">
          <SelectTrigger class="w-full lg:w-48">
            <SelectValue placeholder="Filter by role" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem v-for="role in uniqueRoles" :key="role" :value="role">
              {{ role === 'all' ? 'All roles' : role }}
            </SelectItem>
          </SelectContent>
        </Select>
        <Select v-model="projectFilter">
          <SelectTrigger class="w-full lg:w-48">
            <SelectValue placeholder="Filter by project" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All projects</SelectItem>
            <SelectItem v-for="project in projectOptions" :key="project" :value="project">
              {{ project }}
            </SelectItem>
          </SelectContent>
        </Select>
      </div>
      <div class="flex items-center gap-2">
        <Checkbox id="unassigned" v-model:checked="showUnassignedOnly" />
        <Label for="unassigned" class="text-sm text-gray-700">Show only unassigned</Label>
      </div>
    </Card>

    <!-- Employees Table -->
    <Card v-if="!loading" class="overflow-hidden">
      <ScrollArea class="w-full">
        <table class="w-full">
          <thead class="bg-gray-50 border-b">
            <tr>
              <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Avatar</th>
              <th
                class="px-4 py-3 text-left text-sm font-semibold text-gray-700 cursor-pointer hover:bg-gray-100"
                @click="toggleSort('name')"
              >
                Name
                <span v-if="sortBy === 'name'" class="ml-1">{{ sortOrder === 'asc' ? '↑' : '↓' }}</span>
              </th>
              <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700 cursor-pointer hover:bg-gray-100"
              @click="toggleSort('role')">Role
            <span v-if="sortBy === 'role'" class="ml-1">{{ sortOrder === 'asc' ? '↑' : '↓' }}</span></th>
              <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Projects</th>
              <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700 cursor-pointer hover:bg-gray-100"
              @click="toggleSort('status')">Status
            <span v-if="sortBy === 'status'" class="ml-1">{{ sortOrder === 'asc' ? '↑' : '↓' }}</span></th>
              <th class="px-4 py-3 text-left text-sm font-semibold text-gray-700">Actions</th>
            </tr>
          </thead>
          <tbody class="divide-y">
            <tr
              v-for="employee in filteredEmployees"
              :key="employee.id"
              class="hover:bg-gray-50 transition-colors"
            >
              <td class="px-4 py-3">
                <img
                  :src="employee.avatar"
                  :alt="employee.name"
                  class="w-10 h-10 rounded-full object-cover border border-gray-200"
                />
              </td>
              <td class="px-4 py-3">
                <div class="text-sm font-semibold text-gray-900">{{ employee.name }}</div>
                <div class="text-xs text-gray-500">{{ employee.email }}</div>
              </td>
              <td class="px-4 py-3">
                <Badge :variant="roleBadgeVariant(employee.role)" class="capitalize">
                  {{ employee.role }}
                </Badge>
              </td>
              <td class="px-4 py-3">
                <div v-if="employee.assignedProjects?.length" class="flex flex-wrap gap-2">
                  <Badge
                    v-for="project in employee.assignedProjects.slice(0, 2)"
                    :key="project"
                    variant="outline"
                  >
                    {{ project }}
                  </Badge>
                  <Badge v-if="employee.assignedProjects.length > 2" variant="secondary">
                    +{{ employee.assignedProjects.length - 2 }} more
                  </Badge>
                </div>
                <Badge v-else variant="secondary">Unassigned</Badge>
              </td>
              <td class="px-4 py-3">
                <Badge :variant="statusColorMap[employee.status] || 'outline'">
                  {{ employee.status.replace('_', ' ') }}
                </Badge>
              </td>
              <td class="px-4 py-3">
                <div class="flex gap-2 flex-wrap">
                  <Button variant="ghost" size="sm" @click="openViewModal(employee)" title="View">
                    <Eye class="w-4 h-4" />
                  </Button>
                  <Button variant="ghost" size="sm" @click="openEditModal(employee)" title="Edit">
                    <Edit2 class="w-4 h-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="sm"
                    @click="openAssignModal(employee, 'assign')"
                    title="Assign"
                  >
                    <UserPlus class="w-4 h-4" />
                  </Button>
                  <Button
                    variant="ghost"
                    size="sm"
                    @click="openAssignModal(employee, 'transfer')"
                    title="Transfer"
                  >
                    <ArrowRightLeft class="w-4 h-4" />
                  </Button>
                  <Button variant="ghost" size="sm" @click="openRemoveModal(employee)" title="Remove">
                    <Trash2 class="w-4 h-4 text-red-500" />
                  </Button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </ScrollArea>

      <div v-if="filteredEmployees.length === 0" class="p-8 text-center text-gray-500">
        No employees found
      </div>
    </Card>

    <Card v-else class="p-8 text-center text-gray-500">Loading employees...</Card>

    <!-- CREATE / EDIT MODAL -->
    <Dialog :open="showCreateModal || showEditModal" @update:open="(val) => { showCreateModal = val; showEditModal = val }">
      <DialogContent class="max-w-md">
        <DialogHeader>
          <DialogTitle>{{ currentEmployee ? 'Edit Employee' : 'Add New Employee' }}</DialogTitle>
        </DialogHeader>
        <div class="space-y-4">
          <div class="space-y-2">
            <Label for="name">Name</Label>
            <Input
              id="name"
              v-model="formData.name"
              placeholder="Enter employee name"
              :class="{ 'border-red-500': formErrors.name }"
            />
            <p v-if="formErrors.name" class="text-sm text-red-500">{{ formErrors.name }}</p>
          </div>
          <div class="space-y-2">
            <Label for="email">Email</Label>
            <Input
              id="email"
              v-model="formData.email"
              type="email"
              placeholder="Enter email address"
              :class="{ 'border-red-500': formErrors.email }"
            />
            <p v-if="formErrors.email" class="text-sm text-red-500">{{ formErrors.email }}</p>
          </div>
          <div class="space-y-2">
            <Label for="role">Role</Label>
            <Input
              id="role"
              v-model="formData.role"
              placeholder="e.g., Foreman, Mason, Carpenter"
              :class="{ 'border-red-500': formErrors.role }"
            />
            <p v-if="formErrors.role" class="text-sm text-red-500">{{ formErrors.role }}</p>
          </div>
          <div class="space-y-2">
            <Label for="status">Status</Label>
            <Select v-model="formData.status">
              <SelectTrigger id="status">
                <SelectValue placeholder="Select status" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="inactive">Inactive</SelectItem>
                <SelectItem value="on_leave">On Leave</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="showCreateModal = false; showEditModal = false">Cancel</Button>
          <Button @click="saveEmployee">{{ currentEmployee ? 'Update' : 'Create' }}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>

    <!-- VIEW MODAL -->
    <Dialog :open="showViewModal" @update:open="showViewModal = $event">
      <DialogContent class="max-w-md">
        <DialogHeader>
          <DialogTitle>Employee Details</DialogTitle>
        </DialogHeader>
        <div v-if="currentEmployee" class="space-y-4">
          <div class="flex justify-center">
            <img
              :src="currentEmployee.avatar"
              :alt="currentEmployee.name"
              class="w-24 h-24 rounded-full object-cover border-2 border-gray-300"
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <p class="text-sm font-semibold text-gray-600">Name</p>
              <p class="text-base text-gray-900">{{ currentEmployee.name }}</p>
            </div>
            <div>
              <p class="text-sm font-semibold text-gray-600">Email</p>
              <p class="text-base text-gray-900">{{ currentEmployee.email }}</p>
            </div>
            <div>
              <p class="text-sm font-semibold text-gray-600">Role</p>
              <p class="text-base text-gray-900">{{ currentEmployee.role }}</p>
            </div>
            <div>
              <p class="text-sm font-semibold text-gray-600">Primary Project</p>
              <p class="text-base text-gray-900">
                {{ currentEmployee.project || 'Unassigned' }}
              </p>
            </div>
            <div>
              <p class="text-sm font-semibold text-gray-600">Status</p>
              <Badge :variant="statusColorMap[currentEmployee.status]">
                {{ currentEmployee.status.replace('_', ' ') }}
              </Badge>
            </div>
            <div>
              <p class="text-sm font-semibold text-gray-600">Join Date</p>
              <p class="text-base text-gray-900">{{ currentEmployee.joinDate }}</p>
            </div>
          </div>
          <div>
            <p class="text-sm font-semibold text-gray-600 mb-2">Assigned Projects</p>
            <div v-if="currentEmployee.assignedProjects.length > 0" class="flex flex-wrap gap-2">
              <Badge v-for="project in currentEmployee.assignedProjects" :key="project" variant="outline">
                {{ project }}
              </Badge>
            </div>
            <p v-else class="text-sm text-gray-500">No projects assigned</p>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="showViewModal = false">Close</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>

    <!-- ASSIGN / TRANSFER MODAL -->
    <Dialog :open="showAssignModal" @update:open="(val) => { if (!val) closeAssignModal() }">
      <DialogContent class="max-w-md">
        <DialogHeader>
          <DialogTitle>
            {{ modalMode === 'transfer' ? 'Transfer Employee' : 'Assign Employee' }}
          </DialogTitle>
        </DialogHeader>
        <div v-if="currentEmployee" class="space-y-4">
          <p class="text-sm text-gray-600">
            {{ modalMode === 'transfer' ? 'Update assignments for' : 'Assign' }}
            <span class="font-semibold">{{ currentEmployee.name }}</span>
            ({{ currentEmployee.role }})
          </p>

          <div v-if="isForeman(currentEmployee)" class="space-y-2">
            <p class="text-sm font-semibold text-gray-700">Select projects (multi-select)</p>
            <div class="space-y-2">
              <label
                v-for="project in projectOptions"
                :key="project"
                class="flex items-center gap-2 rounded-md border px-3 py-2 hover:bg-gray-50"
              >
                <Checkbox
                  :checked="assignSelectionMulti.includes(project)"
                  @update:checked="(checked) => {
                    if (checked && !assignSelectionMulti.includes(project)) {
                      assignSelectionMulti = [...assignSelectionMulti, project]
                    } else if (!checked) {
                      assignSelectionMulti = assignSelectionMulti.filter((p) => p !== project)
                    }
                  }"
                />
                <span class="text-sm text-gray-800">{{ project }}</span>
              </label>
            </div>
            <p class="text-xs text-gray-500">Foremen can be assigned to multiple projects.</p>
          </div>

          <div v-else class="space-y-2">
            <Label for="single-project">Select project (single)</Label>
            <Select v-model="assignSelectionSingle">
              <SelectTrigger id="single-project">
                <SelectValue placeholder="Choose a project" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="unassigned">Unassigned</SelectItem>
                <SelectItem v-for="project in projectOptions" :key="project" :value="project">
                  {{ project }}
                </SelectItem>
              </SelectContent>
            </Select>
            <p class="text-xs text-gray-500">
              Skilled laborers can belong to one project at a time. Saving replaces the current assignment.
            </p>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="closeAssignModal">Cancel</Button>
          <Button @click="applyAssignment">Save</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>

    <!-- REMOVE MODAL -->
    <Dialog :open="showRemoveModal" @update:open="showRemoveModal = $event">
      <DialogContent class="max-w-md">
        <DialogHeader>
          <DialogTitle>Remove Employee</DialogTitle>
        </DialogHeader>
        <div v-if="currentEmployee" class="space-y-4">
          <div class="bg-red-50 border border-red-200 rounded-lg p-4">
            <p class="text-sm text-red-800">
              Remove <span class="font-semibold">{{ currentEmployee.name }}</span> from the team? This action
              cannot be undone.
            </p>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" @click="showRemoveModal = false">Cancel</Button>
          <Button variant="destructive" @click="confirmRemove">Remove</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  </div>
</template>
