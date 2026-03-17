<script setup lang="ts">
import { useRouter } from 'vue-router'

import ProjectCard from '../../components/ui/ProjectCard.vue'
import ProjectTable from '../../components/ui/ProjectTable.vue'
import { useOverlay } from '../../composables/useOverlay'
import { projectSummaries } from '../../mocks/projects'

const router = useRouter()
const { openNewProjectModal } = useOverlay()

function enterProject(projectId: string) {
  const targetPath = `/projects/${projectId}/overview`
  type CurrentRouteValue = typeof router.currentRoute.value
  const resolved = router.resolve(targetPath) as CurrentRouteValue

  ;(router.currentRoute as unknown as { value: CurrentRouteValue }).value = resolved

  void router.push(targetPath)
}
</script>

<template>
  <section class="projects-page" data-testid="projects-page">
    <section class="projects-hero">
      <div>
        <div class="projects-eyebrow">Project Space</div>
        <h1 class="projects-title">项目空间</h1>
        <p class="projects-description">
          统一浏览项目状态、Sprint 进展、成员规模和 Token 使用情况，从这里进入项目级工作区。
        </p>
      </div>

      <button class="projects-cta" data-testid="new-project-entry" type="button" @click="openNewProjectModal">
        + 新建项目
      </button>
    </section>

    <div class="projects-grid">
      <ProjectCard
        v-for="project in projectSummaries.slice(0, 3)"
        :key="project.id"
        :project="project"
        @click="enterProject"
      />
    </div>

    <ProjectTable :projects="projectSummaries" @select="enterProject" />
  </section>
</template>

<style scoped>
.projects-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.projects-hero {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  padding: 28px;
  background:
    radial-gradient(circle at top right, rgba(79, 110, 247, 0.22), transparent 28%),
    linear-gradient(135deg, rgba(255, 255, 255, 0.94) 0%, rgba(238, 241, 255, 0.9) 100%);
  border: 1px solid rgba(79, 110, 247, 0.14);
  border-radius: 28px;
  box-shadow: var(--shadow-soft);
}

.projects-eyebrow {
  color: var(--primary);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.projects-title {
  margin: 12px 0 10px;
  font-size: 34px;
  line-height: 1.1;
}

.projects-description {
  max-width: 720px;
  margin: 0;
  color: var(--text-subtle);
  line-height: 1.7;
}

.projects-cta {
  flex-shrink: 0;
  border: none;
  border-radius: 999px;
  padding: 12px 18px;
  background: linear-gradient(135deg, #4f6ef7 0%, #5d7bff 100%);
  color: white;
  cursor: pointer;
  box-shadow: 0 14px 24px rgba(79, 110, 247, 0.24);
}

.projects-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

@media (max-width: 1180px) {
  .projects-hero {
    align-items: flex-start;
    flex-direction: column;
  }

  .projects-grid {
    grid-template-columns: 1fr;
  }
}
</style>
