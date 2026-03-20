<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import PlaceholderState from '../../components/ui/PlaceholderState.vue'
import { globalPlaceholderContent, projectPlaceholderContent } from '../../mocks/placeholders'
import { getProjectById } from '../../composables/useProjects'
import type { PlaceholderContent } from '../../types/navigation'
import NotFoundProjectState from '../project/NotFoundProjectState.vue'

const route = useRoute()

const scope = computed(() => (route.meta.scope === 'project' ? 'project' : 'global'))

const pageKey = computed(() => {
  if (scope.value === 'project' && typeof route.params.section === 'string') {
    return route.params.section
  }

  if (scope.value === 'global' && typeof route.params.pageKey === 'string') {
    return route.params.pageKey
  }

  return 'default'
})

const project = computed(() => {
  if (scope.value !== 'project' || typeof route.params.projectId !== 'string') {
    return undefined
  }

  return getProjectById(route.params.projectId)
})

const content = computed<PlaceholderContent>(() => {
  if (scope.value === 'project') {
    return projectPlaceholderContent[pageKey.value] ?? projectPlaceholderContent.default!
  }

  return globalPlaceholderContent[pageKey.value] ?? globalPlaceholderContent.default!
})
</script>

<template>
  <NotFoundProjectState v-if="scope === 'project' && !project" />

  <section v-else class="placeholder-page" data-testid="placeholder-page">
    <div class="placeholder-meta">
      <span data-testid="placeholder-scope">{{ scope }}</span>
      <span data-testid="placeholder-page-key">{{ pageKey }}</span>
    </div>

    <PlaceholderState
      :description="content.description"
      :eyebrow="scope === 'project' ? `${project?.name} / Project Space` : 'Platform Space'"
      :highlights="content.highlights"
      :title="content.title"
    />
  </section>
</template>

<style scoped>
.placeholder-page {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.placeholder-meta {
  display: inline-flex;
  gap: 10px;
  color: var(--text-subtle);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}
</style>

