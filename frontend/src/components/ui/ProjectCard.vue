<script setup lang="ts">
import type { ProjectSummary } from '../../types/project'

defineProps<{
  project: ProjectSummary
}>()

const emit = defineEmits<{
  select: [projectId: string]
  click: [projectId: string]
}>()

function handleClick(projectId: string) {
  emit('select', projectId)
  emit('click', projectId)
}
</script>

<template>
  <article class="project-card" :data-project-id="project.id" @click="handleClick(project.id)">
    <div class="project-card-head">
      <div class="project-card-title">
        <div class="project-card-icon">{{ project.icon }}</div>
        <div>
          <div class="project-card-name">{{ project.name }}</div>
          <div class="project-card-type">{{ project.typeLabel }}</div>
        </div>
      </div>
      <span class="project-card-status" :class="project.statusTone">{{ project.statusLabel }}</span>
    </div>

    <p class="project-card-description">{{ project.description }}</p>

    <dl class="project-card-meta">
      <div>
        <dt>当前 Sprint</dt>
        <dd>{{ project.sprintLabel }}</dd>
      </div>
      <div>
        <dt>本月 Token</dt>
        <dd>{{ project.tokenLabel }}</dd>
      </div>
    </dl>

    <div class="project-card-footer">
      <div class="project-card-avatars">
        <span v-for="member in project.members.slice(0, 3)" :key="member" class="project-card-avatar">
          {{ member }}
        </span>
      </div>
      <span class="project-card-summary">{{ project.serviceCount }} 个服务 · {{ project.memberCount }} 人</span>
    </div>
  </article>
</template>

<style scoped>
.project-card {
  padding: 18px;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid var(--card-border);
  border-radius: 24px;
  box-shadow: var(--shadow-soft);
  text-align: left;
  cursor: pointer;
  transition: transform 160ms ease, box-shadow 160ms ease, border-color 160ms ease;
}

.project-card:hover {
  border-color: rgba(79, 110, 247, 0.45);
  box-shadow: 0 18px 38px rgba(79, 110, 247, 0.16);
  transform: translateY(-2px);
}

.project-card-head,
.project-card-footer,
.project-card-meta {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 12px;
}

.project-card-title {
  display: flex;
  gap: 12px;
}

.project-card-icon {
  display: grid;
  place-items: center;
  width: 46px;
  height: 46px;
  border-radius: 16px;
  background: var(--primary-soft);
  font-size: 22px;
}

.project-card-name {
  font-size: 18px;
  font-weight: 700;
}

.project-card-type,
.project-card-description,
.project-card-meta dt,
.project-card-summary {
  color: var(--text-subtle);
}

.project-card-type {
  margin-top: 4px;
  font-size: 12px;
}

.project-card-status {
  border-radius: 999px;
  padding: 6px 10px;
  font-size: 12px;
  font-weight: 600;
}

.project-card-status.success {
  background: rgba(18, 183, 106, 0.12);
  color: var(--success);
}

.project-card-status.warning {
  background: rgba(247, 144, 9, 0.12);
  color: var(--warning);
}

.project-card-description {
  margin: 16px 0 18px;
  line-height: 1.6;
}

.project-card-meta {
  margin: 0;
  padding: 14px 0;
  border-top: 1px solid rgba(229, 231, 235, 0.9);
  border-bottom: 1px solid rgba(229, 231, 235, 0.9);
}

.project-card-meta div {
  flex: 1;
}

.project-card-meta dt {
  font-size: 12px;
}

.project-card-meta dd {
  margin: 8px 0 0;
  font-weight: 600;
}

.project-card-footer {
  align-items: center;
  margin-top: 16px;
}

.project-card-avatars {
  display: flex;
}

.project-card-avatar {
  display: grid;
  place-items: center;
  width: 30px;
  height: 30px;
  margin-right: -8px;
  border: 2px solid white;
  border-radius: 50%;
  background: linear-gradient(135deg, #4f6ef7 0%, #6c89ff 100%);
  color: white;
  font-size: 12px;
  font-weight: 700;
}
</style>
