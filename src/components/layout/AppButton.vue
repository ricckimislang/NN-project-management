<script setup>
import { computed } from 'vue'

const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  icon: {
    type: String,
    default: '',
  },
  variant: {
    type: String,
    default: 'primary', // 'primary' or 'secondary'
  },
  size: {
    type: String,
    default: 'md', // 'sm', 'md', 'lg'
  },
  disabled: {
    type: Boolean,
    default: false,
  },
})

const buttonClasses = computed(() => {
  let classes = 'flex items-center rounded transition-colors '

  // Variant styles
  if (props.variant === 'primary') {
    classes += 'bg-blue-500 hover:bg-blue-600 text-white '
  } else if (props.variant === 'secondary') {
    classes += 'bg-gray-200 hover:bg-gray-300 text-gray-700 '
  }

  // Size styles
  if (props.size === 'sm') {
    classes += 'px-3 py-1 text-sm '
  } else if (props.size === 'md') {
    classes += 'px-4 py-2 text-base '
  } else if (props.size === 'lg') {
    classes += 'px-5 py-3 text-lg '
  }

  // Disabled
  if (props.disabled) {
    classes += 'opacity-50 cursor-not-allowed '
  }

  return classes.trim()
})
</script>

<template>
  <button :class="buttonClasses" :disabled="disabled">
    <i v-if="icon" :class="icon" class="mr-2"></i>
    <span>{{ label }}</span>
  </button>
</template>
