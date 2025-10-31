<script setup>
import {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
} from '@/components/ui/dropdown-menu'
</script>

<template>
  <DropdownMenu>
    <DropdownMenuTrigger>
      <slot name="trigger" />
    </DropdownMenuTrigger>
    <DropdownMenuContent>
      <slot name="content" />
    </DropdownMenuContent>
  </DropdownMenu>
</template>
