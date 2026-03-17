<script setup lang="ts">
import type { Incident } from '../../types/dashboard'

defineProps<{
  items: Incident[]
}>()
</script>

<template>
  <div class="incident-list">
    <article v-for="item in items" :key="item.id" class="incident-item">
      <div class="incident-main">
        <span class="incident-dot" :class="item.severity" />
        <div>
          <div class="incident-title">{{ item.title }}</div>
          <div class="incident-meta">{{ item.meta }}</div>
        </div>
      </div>
      <span class="incident-badge" :class="item.severity">{{ item.severityLabel }}</span>
    </article>
  </div>
</template>

<style scoped>
.incident-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.incident-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 0;
  border-bottom: 1px solid rgba(229, 231, 235, 0.9);
}

.incident-item:last-child {
  border-bottom: none;
}

.incident-main {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.incident-dot {
  width: 12px;
  height: 12px;
  margin-top: 4px;
  border-radius: 50%;
}

.incident-dot.critical {
  background: var(--danger);
}

.incident-dot.warning {
  background: var(--warning);
}

.incident-dot.info {
  background: var(--primary);
}

.incident-title {
  font-weight: 600;
}

.incident-meta {
  margin-top: 4px;
  color: var(--text-subtle);
  font-size: 12px;
}

.incident-badge {
  border-radius: 999px;
  padding: 6px 10px;
  font-size: 12px;
  font-weight: 600;
}

.incident-badge.critical {
  background: rgba(240, 68, 56, 0.1);
  color: var(--danger);
}

.incident-badge.warning {
  background: rgba(247, 144, 9, 0.12);
  color: var(--warning);
}

.incident-badge.info {
  background: var(--primary-soft);
  color: var(--primary);
}
</style>
