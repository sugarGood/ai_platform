<script setup lang="ts">
defineProps<{
  title: string
  badge?: string
}>()
</script>

<template>
  <section class="card-panel">
    <header class="card-panel-header">
      <h2 class="card-panel-title">{{ title }}</h2>
      <span v-if="badge" class="card-panel-badge">{{ badge }}</span>
    </header>

    <div class="card-panel-body">
      <slot />
    </div>
  </section>
</template>

<style scoped>
.card-panel {
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid var(--card-border);
  border-radius: 24px;
  box-shadow: var(--shadow-soft);
}

.card-panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 18px 20px 0;
}

.card-panel-title {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
}

.card-panel-badge {
  border-radius: 999px;
  padding: 4px 10px;
  background: var(--primary-soft);
  color: var(--primary);
  font-size: 12px;
  font-weight: 600;
}

.card-panel-body {
  padding: 18px 20px 20px;
}
</style>
