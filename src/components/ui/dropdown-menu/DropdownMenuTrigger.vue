<script setup>
import { DropdownMenuTrigger } from 'reka-ui'
import { cn } from '@/lib/utils'

const props = defineProps({
  asChild: { type: Boolean, default: false },
  class: { type: null, required: false },
})
</script>

<template>
  <DropdownMenuTrigger
    v-bind="$attrs"
    :as-child="asChild"
    :class="cn(props.class)"
  >
    <slot />
  </DropdownMenuTrigger>
</template>
