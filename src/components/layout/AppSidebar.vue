<script setup>
import { RouterLink } from 'vue-router'
</script>

<template>
  <aside class="w-64 bg-white shadow-sm border-r border-gray-200">
    <nav class="p-4">
      <ul class="space-y-2">
        <li>
          <RouterLink
            to="/dashboard"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><i class="fas fa-tachometer-alt mr-3"></i>
            Dashboard
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/projects"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><i class="fas fa-folder mr-3"></i>
            Projects
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/tasks"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><i class="fas fa-tasks mr-3"></i>
            Tasks
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/team"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><i class="fas fa-users mr-3"></i>
            Team
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/reports"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><i class="fas fa-chart-bar mr-3"></i>
            Reports
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/settings"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><i class="fas fa-cog mr-3"></i>
            Settings
          </RouterLink>
        </li>
      </ul>
    </nav>
  </aside>
</template>
