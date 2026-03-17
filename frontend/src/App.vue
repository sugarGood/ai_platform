<template>
  <AppShell />
</template>
<script setup lang="ts">
import { onMounted } from 'vue'
import AppShell from './layouts/AppShell.vue'
import { initGlobalPageNavigation } from './composables/usePageNavigation'

// Initialize global page navigation for HTML prototype compatibility
onMounted(() => {
  initGlobalPageNavigation()
})
</script>
