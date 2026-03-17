<script setup lang="ts">
import type { DepartmentUsage } from '../../types/dashboard'

defineProps<{
  items: DepartmentUsage[]
}>()
</script>

<template>
  <div class="ranking-list">
    <div v-for="item in items" :key="item.id" class="ranking-item">
      <div class="ranking-head">
        <span class="ranking-name">{{ item.name }}</span>
        <span class="ranking-value">{{ item.usage }}</span>
      </div>
      <div class="ranking-track">
        <div class="ranking-fill" :class="item.tone ?? 'default'" :style="{ width: `${item.progress}%` }" />
      </div>
    </div>
  </div>
</template>

<style scoped>
.ranking-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.ranking-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.ranking-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  font-size: 13px;
}

.ranking-name {
  color: var(--text-main);
  font-weight: 600;
}

.ranking-value {
  color: var(--text-subtle);
}

.ranking-track {
  height: 10px;
  overflow: hidden;
  background: #eef2f7;
  border-radius: 999px;
}

.ranking-fill {
  height: 100%;
  border-radius: inherit;
  background: linear-gradient(135deg, #4f6ef7 0%, #6c89ff 100%);
}

.ranking-fill.warning {
  background: linear-gradient(135deg, #f79009 0%, #f9b44a 100%);
}
</style>
