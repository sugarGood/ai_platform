<script setup lang="ts">
import type { ActivityEvent } from '../../types/dashboard'

defineProps<{
  items: ActivityEvent[]
}>()
</script>

<template>
  <div class="timeline">
    <article v-for="item in items" :key="item.id" class="timeline-item">
      <div class="timeline-dot" />
      <div class="timeline-content">
        <div class="timeline-time">{{ item.time }}</div>
        <div class="timeline-text">{{ item.content }}</div>
      </div>
    </article>
  </div>
</template>

<style scoped>
.timeline {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.timeline-item {
  position: relative;
  padding-left: 22px;
}

.timeline-item::before {
  content: '';
  position: absolute;
  left: 4px;
  top: 14px;
  bottom: -18px;
  width: 2px;
  background: rgba(79, 110, 247, 0.14);
}

.timeline-item:last-child::before {
  display: none;
}

.timeline-dot {
  position: absolute;
  left: 0;
  top: 2px;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--primary);
  box-shadow: 0 0 0 4px rgba(79, 110, 247, 0.12);
}

.timeline-time {
  color: var(--text-subtle);
  font-size: 12px;
}

.timeline-text {
  margin-top: 6px;
  line-height: 1.55;
}
</style>
