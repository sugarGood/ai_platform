import { computed } from 'vue'
import { useRoute } from 'vue-router'

import { getProjectById } from './useProjects'

export function useAppShell() {
  const route = useRoute()

  const isProjectScope = computed(() => route.meta.scope === 'project')

  const currentProject = computed(() => {
    if (typeof route.params.projectId !== 'string') {
      return undefined
    }

    return getProjectById(route.params.projectId)
  })

  const topbarTitle = computed(() => {
    if (isProjectScope.value) {
      return currentProject.value?.name ?? '项目不存在'
    }

    return typeof route.meta.title === 'string' ? route.meta.title : 'AI 中台'
  })

  const topbarSubtitle = computed(() => {
    if (isProjectScope.value) {
      return typeof route.meta.title === 'string' ? route.meta.title : '项目空间'
    }

    return 'Enterprise AI Platform'
  })

  return {
    currentProject,
    isProjectScope,
    topbarSubtitle,
    topbarTitle,
  }
}
