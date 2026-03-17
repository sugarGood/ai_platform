<script setup lang="ts">
import { onMounted } from 'vue'

import GlobalSidebar from '../components/shell/GlobalSidebar.vue'
import ProjectSidebar from '../components/shell/ProjectSidebar.vue'
import TopBar from '../components/shell/TopBar.vue'
import AppOverlay from '../components/ui/AppOverlay.vue'
import { useAppShell } from '../composables/useAppShell'
import { useOverlay } from '../composables/useOverlay'

const { isProjectScope, topbarSubtitle, topbarTitle } = useAppShell()
const { resetOverlayState } = useOverlay()

// ???????????????????????????????????
onMounted(() => {
  resetOverlayState()
})
</script>

<template>
  <div class="app-frame" data-testid="app-shell">
    <GlobalSidebar v-if="!isProjectScope" />
    <ProjectSidebar v-else />

    <div class="content-frame">
      <TopBar
        :project-scoped="isProjectScope"
        :subtitle="topbarSubtitle"
        :title="topbarTitle"
      />

      <main class="page-scroll">
        <div class="page-shell">
          <RouterView />
        </div>
      </main>
    </div>

    <AppOverlay />
  </div>
</template>
