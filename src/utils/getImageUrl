// Preload all images so Vite bundles them.
const images = import.meta.glob('../assets/images/**/*.{png,jpg,jpeg,svg}', { eager: true })

// Convert the glob result to an object keyed by the *relative path* inside assets/images
const imageMap = {}
for (const fullPath in images) {
  // fullPath looks like '../assets/images/projects/project-1.jpg'
  const relativePath = fullPath.replace('../assets/images/', '')
  imageMap[relativePath] = images[fullPath].default
}

// Accept paths such as 'projects/project-1.jpg' or just 'project-1.jpg'
export const getImageUrl = (path) => {
  if (imageMap[path]) return imageMap[path]

  // Fallback: if only a filename was provided, try to match that
  const filename = path.split('/').pop()
  return imageMap[filename] || ''
}
