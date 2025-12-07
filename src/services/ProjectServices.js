import { http } from '@/lib/axios'
// Example service showing how to use the configured axios instance
export const projectService = {
  // GET request example
  async getProjects() {
    try {
      const response = await http.get('/projects')
      const data = response.data.data.map(project => {
        return {
          ...project,
          image_path: project.image_path ? `${import.meta.env.VITE_API_BASE_URL}/public/images/${project.image_path}` : ''
        }
      })
      return { data }
    } catch (error) {
      console.error('Error fetching projects:', error)
      throw error
    }
  },

  // POST request example
  async createProject(projectData) {
    try {
      const response = await http.post('/projects', projectData)
      return response.data
    } catch (error) {
      console.error('Error creating project:', error)
      throw error
    }
  },

  // PUT request example
  async updateProject(projectId, projectData) {
    try {
      const response = await http.put(`/projects/${projectId}`, projectData)
      return response.data
    } catch (error) {
      console.error('Error updating project:', error)
      throw error
    }
  },

  // DELETE request example
  async deleteProject(projectId) {
    try {
      await http.delete(`/projects/${projectId}`)
      return true
    } catch (error) {
      console.error('Error deleting project:', error)
      throw error
    }
  },

  // view project
  async showProject(projectId){
    try{
      const response = await http.get(`/project?id=${projectId}`)
      return response.data
    } catch (error){
      console.error('Error fetching project:', error)
      throw error
    }
  }
}
