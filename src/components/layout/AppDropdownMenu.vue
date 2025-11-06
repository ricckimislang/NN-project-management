<script setup>
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
} from '@/components/ui/dropdown-menu'

defineProps({
  align: { type: String, default: 'end' }, // Default to end to open left
  portal: { type: Boolean, default: true }, // Ensure portaling
  side: { type: String, default: 'bottom' }, // Default side
})
</script>

<template>
  <DropdownMenu>
    <DropdownMenuTrigger>
      <slot name="trigger" />
    </DropdownMenuTrigger>
    <DropdownMenuContent :align="align" :portal="portal" :side="side">
      <slot name="content" />
    </DropdownMenuContent>
  </DropdownMenu>
</template>
