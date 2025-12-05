import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import ProjectsView from '@/views/ProjectsView.vue'
import ProjectView from '@/views/ProjectView.vue'
import ProjectEditView from '@/views/ProjectEditView.vue'

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
    {
      path: '/project/:id',
      name: 'project',
      component: ProjectView,
    },
    {
      path: '/project/:id/edit',
      name: 'projectEdit',
      component: ProjectEditView,
    },
    {
      path: '/team',
      name: 'team',
      component: () => import('@/views/TeamView.vue'),
    }
  ],
})

export default router
