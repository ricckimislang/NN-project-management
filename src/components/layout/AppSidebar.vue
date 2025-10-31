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
            ><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">      
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 1v4m8-4v4"></path>
              </svg>
            Dashboard
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/projects"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">      
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path>
              </svg>
            Projects
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/tasks"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">      
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path>
              </svg>
            Tasks
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/team"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">      
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197zM13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
              </svg>
            Team
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/reports"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">      
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0h2a2 2 0 012 2v3a2 2 0 01-2 2h-2a2 2 0 01-2-2v-3a2 2 0 012-2z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m6-6H9"></path>
              </svg>
            Reports
          </RouterLink>
        </li>
        <li>
          <RouterLink
            to="/settings"
            class="flex items-center px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
            active-class="bg-blue-50 text-blue-700"
            ><svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">      
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
              </svg>
            Settings
          </RouterLink>
        </li>
      </ul>
    </nav>
  </aside>
</template>
