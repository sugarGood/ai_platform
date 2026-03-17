<script setup lang="ts">
import ActivityTimeline from '../../components/ui/ActivityTimeline.vue'
import CardPanel from '../../components/ui/CardPanel.vue'
import IncidentList from '../../components/ui/IncidentList.vue'
import MiniBarChart from '../../components/ui/MiniBarChart.vue'
import RankingList from '../../components/ui/RankingList.vue'
import StatCard from '../../components/ui/StatCard.vue'
import {
  dashboardActivities,
  dashboardIncidents,
  dashboardMetrics,
  departmentUsage,
  tokenTrend,
} from '../../mocks/dashboard'
</script>

<template>
  <section class="dashboard-page" data-testid="dashboard-page">
    <div class="stats-grid">
      <StatCard
        v-for="metric in dashboardMetrics"
        :key="metric.id"
        :delta="metric.delta"
        :icon="metric.icon"
        :label="metric.label"
        :tone="metric.tone"
        :value="metric.value"
      />
    </div>

    <div class="dashboard-grid">
      <CardPanel badge="本月" title="Token 消耗趋势（本月）">
        <div data-testid="dashboard-trend-card">
          <MiniBarChart :points="tokenTrend" />
        </div>
      </CardPanel>

      <CardPanel badge="部门" title="部门 Token 用量排行">
        <RankingList :items="departmentUsage" />
      </CardPanel>
    </div>

    <div class="dashboard-grid">
      <CardPanel title="近期事故">
        <IncidentList :items="dashboardIncidents" />
      </CardPanel>

      <CardPanel title="项目活动">
        <ActivityTimeline :items="dashboardActivities" />
      </CardPanel>
    </div>
  </section>
</template>

<style scoped>
.dashboard-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1180px) {
  .stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .dashboard-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 720px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>
