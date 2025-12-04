<script setup>
import { RouterLink } from 'vue-router'
import {
  Breadcrumb,
  BreadcrumbList,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from '@/components/ui/breadcrumb'

const props = defineProps({
  url: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  projectName: {
    type: String,
    default: null,
  },
})
</script>

<template>
  <div>
    <h1 class="text-2xl font-bold text-foreground">{{ props.title }}</h1>

    <Breadcrumb>
      <BreadcrumbList>
        <BreadcrumbItem>
          <BreadcrumbLink as-child>
            <RouterLink to="/">
              <i class="fa-regular fa-house"></i>
            </RouterLink>
          </BreadcrumbLink>
        </BreadcrumbItem>
        <BreadcrumbSeparator />
        <BreadcrumbItem>
          <BreadcrumbPage>
            <RouterLink :to="props.url">{{ props.title }} </RouterLink>
          </BreadcrumbPage>
        </BreadcrumbItem>
        <BreadcrumbSeparator v-if="props.projectName" />
        <BreadcrumbItem v-if="props.projectName">
          <BreadcrumbPage>{{ props.projectName }}</BreadcrumbPage>
        </BreadcrumbItem>
      </BreadcrumbList>
    </Breadcrumb>
  </div>
</template>
