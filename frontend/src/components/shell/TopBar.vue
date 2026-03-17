<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import { useOverlay } from '../../composables/useOverlay'

const props = defineProps<{
  title: string
  subtitle: string
  projectScoped: boolean
}>()

const route = useRoute()
const { openActionDialog, openNewProjectModal, openNotifications } = useOverlay()

const projectId = computed(() =>
  typeof route.params.projectId === 'string' ? route.params.projectId : '',
)

// ????????????????????????????????????
function handlePrimaryAction() {
  if (!props.projectScoped) {
    openNewProjectModal()
    return
  }

  openActionDialog({
    title: '项目操作',
    description: '已打开当前项目的快捷操作入口，可继续跳转到服务、事故或设置模块。',
    items: ['进入代码服务查看服务健康与仓库状态。', '进入项目设置维护 Sprint、Token 和 Skill 配置。'],
    shortcuts: [
      { label: '代码服务', to: `/projects/${projectId.value}/services` },
      { label: '项目设置', to: `/projects/${projectId.value}/psettings` },
    ],
  })
}
</script>

<template>
  <header class="topbar">
    <div>
      <div class="topbar-title" data-testid="topbar-title">{{ title }}</div>
      <div class="topbar-subtitle">{{ subtitle }}</div>
    </div>

    <div class="topbar-actions">
      <button
        class="ghost-button"
        data-testid="topbar-notifications"
        type="button"
        @click="openNotifications"
      >
        🔔 通知
      </button>
      <button class="primary-button" data-testid="topbar-primary-action" type="button" @click="handlePrimaryAction">
        {{ projectScoped ? '项目操作' : '+ 新建项目' }}
      </button>
    </div>
  </header>
</template>
