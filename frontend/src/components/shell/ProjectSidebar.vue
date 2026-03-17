<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import { projectNavGroups } from '../../mocks/navigation'
import { getProjectById } from '../../mocks/projects'

const route = useRoute()

const project = computed(() =>
  typeof route.params.projectId === 'string' ? getProjectById(route.params.projectId) : undefined,
)

const projectId = computed(() => {
  return typeof route.params.projectId === 'string' ? route.params.projectId : ''
})

function buildPath(section: string) {
  return `/projects/${projectId.value}/${section}`
}

function isActive(section: string) {
  if (section === 'services') {
    return route.path.startsWith(buildPath('services'))
  }

  return route.path === buildPath(section)
}
</script>

<template>
  <aside class="sidebar" data-testid="project-sidebar">
    <RouterLink class="sidebar-back" to="/projects">← 返回项目列表</RouterLink>

    <div class="project-info">
      <div class="project-icon">{{ project?.icon ?? '📁' }}</div>
      <div>
        <div class="project-name">{{ project?.name ?? '未知项目' }}</div>
        <div class="project-sprint">{{ project?.currentSprint ?? '项目上下文' }}</div>
      </div>
    </div>

    <div v-for="group in projectNavGroups" :key="group.label" class="nav-section">
      <div class="nav-label">{{ group.label }}</div>
      <RouterLink
        v-for="item in group.items"
        :key="item.key"
        :to="buildPath(item.to)"
        class="nav-item"
        :class="{ active: isActive(item.to) }"
      >
        <span class="nav-item-main">
          <span class="icon">{{ item.icon }}</span>
          <span class="label">{{ item.label }}</span>
        </span>
        <span v-if="item.badge" class="badge">{{ item.badge }}</span>
      </RouterLink>
    </div>

    <div class="sidebar-footer">
      <div class="avatar">张</div>
      <div class="user-info">
        <div class="name">张三</div>
        <div class="role">项目负责人</div>
      </div>
    </div>
  </aside>
</template>
