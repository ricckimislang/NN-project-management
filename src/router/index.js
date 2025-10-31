import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import ProjectsView from '@/views/ProjectsView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: HomeView,
      // Add more child routes here
    },
    {
      path: '/projects',
      name: 'projects',
      component: ProjectsView,
    },
  ],
})

export default router
