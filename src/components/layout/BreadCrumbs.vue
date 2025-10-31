<script setup>
import { RouterLink } from 'vue-router'

const props = defineProps({
  url: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
})
</script>

<template>
  <nav class="text-sm text-gray-500">
    <h1 class="text-2xl font-bold text-gray-800">{{ props.title }}</h1>

    <RouterLink class="hover:underline text-blue-500" to="/"
      ><i class="fa-regular fa-house"></i
    ></RouterLink>
    /
    <RouterLink class="hover:underline text-blue-500" :to="props.url">{{ props.title }}</RouterLink>
  </nav>
</template>
