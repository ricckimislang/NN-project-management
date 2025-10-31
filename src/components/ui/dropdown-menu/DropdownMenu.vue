<script setup>
import { DropdownMenuRoot } from 'reka-ui'

const props = defineProps({
  open: { type: Boolean, default: undefined },
  defaultOpen: { type: Boolean, default: false },
  modal: { type: Boolean, default: true },
})

const emit = defineEmits(['update:open'])

const handleOpenChange = (open) => {
  emit('update:open', open)
}
</script>

<template>
  <DropdownMenuRoot
    :open="open"
    :default-open="defaultOpen"
    :modal="modal"
    @update:open="handleOpenChange"
  >
    <slot />
  </DropdownMenuRoot>
</template>
