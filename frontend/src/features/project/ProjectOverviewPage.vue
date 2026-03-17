<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import ActivityTimeline from '../../components/ui/ActivityTimeline.vue'
import CardPanel from '../../components/ui/CardPanel.vue'
import StatCard from '../../components/ui/StatCard.vue'
import { getProjectById } from '../../mocks/projects'
import NotFoundProjectState from './NotFoundProjectState.vue'

const route = useRoute()

const project = computed(() => {
  if (typeof route.params.projectId !== 'string') {
    return undefined
  }

  return getProjectById(route.params.projectId)
})

const stats = computed(() => {
  if (!project.value) {
    return []
  }

  return [
    {
      id: 'sprint',
      icon: '🏃',
      label: '当前 Sprint',
      value: project.value.currentSprint,
      delta: project.value.sprintProgress,
      tone: 'primary' as const,
    },
    {
      id: 'services',
      icon: '⚙️',
      label: '代码服务',
      value: `${project.value.serviceCount}`,
      delta: `${project.value.serviceCount} 个已关联服务`,
    },
    {
      id: 'incidents',
      icon: '🚨',
      label: '待处理事故',
      value: `${project.value.incidents.length}`,
      delta: project.value.incidentsSummary,
      tone: project.value.incidents.length ? ('danger' as const) : ('success' as const),
    },
    {
      id: 'token',
      icon: '🤖',
      label: '本月 Token',
      value: project.value.tokenLabel,
      delta: project.value.monthlyTokenDelta,
      tone: 'primary' as const,
    },
  ]
})
</script>

<template>
  <NotFoundProjectState v-if="!project" />

  <section v-else class="project-overview" data-testid="project-overview-page">
    <div class="stats-grid">
      <StatCard
        v-for="item in stats"
        :key="item.id"
        :delta="item.delta"
        :icon="item.icon"
        :label="item.label"
        :tone="item.tone"
        :value="item.value"
      />
    </div>

    <div class="overview-grid">
      <CardPanel title="代码服务健康状态">
        <div class="service-list" data-testid="project-overview-services">
          <article v-for="service in project.services" :key="service.id" class="service-item">
            <div>
              <div class="service-name">
                {{ service.name }}
                <span class="service-stack">{{ service.techStack }}</span>
              </div>
              <div class="service-meta">{{ service.deployMeta }}</div>
            </div>
            <span class="service-status" :class="service.statusTone">{{ service.statusLabel }}</span>
          </article>
        </div>
      </CardPanel>

      <CardPanel title="项目活动">
        <ActivityTimeline :items="project.activities" />
      </CardPanel>
    </div>
  </section>
</template>

<style scoped>
.project-overview {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 16px;
}

.overview-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.service-list {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.service-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 14px 0;
  border-bottom: 1px solid rgba(229, 231, 235, 0.9);
}

.service-item:last-child {
  border-bottom: none;
}

.service-name {
  font-weight: 700;
}

.service-stack,
.service-meta {
  color: var(--text-subtle);
  font-size: 12px;
}

.service-stack {
  margin-left: 8px;
}

.service-meta {
  margin-top: 6px;
}

.service-status {
  border-radius: 999px;
  padding: 6px 10px;
  font-size: 12px;
  font-weight: 600;
}

.service-status.success {
  background: rgba(18, 183, 106, 0.12);
  color: var(--success);
}

.service-status.primary {
  background: var(--primary-soft);
  color: var(--primary);
}

.service-status.warning {
  background: rgba(247, 144, 9, 0.12);
  color: var(--warning);
}

@media (max-width: 1180px) {
  .stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .overview-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 720px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>
