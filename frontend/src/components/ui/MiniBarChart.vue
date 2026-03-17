<script setup lang="ts">
import type { TokenTrendPoint } from '../../types/dashboard'

defineProps<{
  points: TokenTrendPoint[]
}>()
</script>

<template>
  <div class="chart" data-testid="mini-bar-chart">
    <div v-for="point in points" :key="point.label" class="chart-column">
      <div class="chart-track">
        <div class="chart-bar" :style="{ height: `${point.value}%` }" />
      </div>
      <div class="chart-label">{{ point.label }}</div>
    </div>
  </div>
</template>

<style scoped>
.chart {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(44px, 1fr));
  gap: 12px;
  align-items: end;
}

.chart-column {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
}

.chart-track {
  display: flex;
  align-items: end;
  width: 100%;
  height: 170px;
  padding: 8px;
  background: linear-gradient(180deg, rgba(79, 110, 247, 0.12) 0%, rgba(79, 110, 247, 0.02) 100%);
  border-radius: 18px;
}

.chart-bar {
  width: 100%;
  border-radius: 12px 12px 8px 8px;
  background: linear-gradient(180deg, #6c89ff 0%, #4f6ef7 100%);
}

.chart-label {
  color: var(--text-subtle);
  font-size: 11px;
}
</style>
