<script setup lang="ts">
defineProps<{
  icon: string
  label: string
  value: string
  delta: string
  tone?: 'primary' | 'danger' | 'success' | 'warning' | 'default'
}>()
</script>

<template>
  <article class="stat-card">
    <div class="stat-icon">{{ icon }}</div>
    <div class="stat-label">{{ label }}</div>
    <div class="stat-value" :class="tone ?? 'default'">{{ value }}</div>
    <div class="stat-delta">{{ delta }}</div>
  </article>
</template>

<style scoped>
.stat-card {
  padding: 18px 20px;
  background: rgba(255, 255, 255, 0.88);
  border: 1px solid var(--card-border);
  border-radius: 22px;
  box-shadow: var(--shadow-soft);
}

.stat-icon {
  font-size: 22px;
}

.stat-label {
  margin-top: 14px;
  color: var(--text-subtle);
  font-size: 13px;
}

.stat-value {
  margin-top: 10px;
  font-size: 28px;
  font-weight: 700;
  letter-spacing: -0.04em;
}

.stat-value.primary {
  color: var(--primary);
}

.stat-value.danger {
  color: var(--danger);
}

.stat-value.success {
  color: var(--success);
}

.stat-delta {
  margin-top: 8px;
  color: var(--text-subtle);
  font-size: 12px;
}
</style>

