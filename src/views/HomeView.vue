<script setup>
import AppMain from '@/components/layout/AppMain.vue'
import BreadCrumbs from '@/components/layout/BreadCrumbs.vue'
</script>
<template>
  <AppMain>
    <BreadCrumbs :url="'/'" title="Home"></BreadCrumbs>
  </AppMain>
</template>
