<script setup lang="ts">
import type { ProjectSummary } from '../../types/project'

defineProps<{
  projects: ProjectSummary[]
}>()

const emit = defineEmits<{
  select: [projectId: string]
}>()
</script>

<template>
  <div class="table-shell">
    <table class="project-table">
      <thead>
        <tr>
          <th>项目</th>
          <th>类型</th>
          <th>服务</th>
          <th>成员</th>
          <th>Sprint</th>
          <th>Token</th>
          <th>状态</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="project in projects"
          :key="project.id"
          :data-project-id="project.id"
          @click="emit('select', project.id)"
        >
          <td>{{ project.icon }} {{ project.name }}</td>
          <td>{{ project.typeLabel }}</td>
          <td>{{ project.serviceCount }} 个</td>
          <td>{{ project.memberCount }} 人</td>
          <td>{{ project.sprintLabel }}</td>
          <td>{{ project.tokenLabel }}</td>
          <td>{{ project.statusLabel }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.table-shell {
  overflow: hidden;
  background: rgba(255, 255, 255, 0.9);
  border: 1px solid var(--card-border);
  border-radius: 24px;
  box-shadow: var(--shadow-soft);
}

.project-table {
  width: 100%;
  border-collapse: collapse;
}

.project-table th,
.project-table td {
  padding: 16px 18px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.86);
  text-align: left;
  font-size: 13px;
}

.project-table th {
  color: var(--text-subtle);
  font-weight: 600;
}

.project-table tbody tr {
  cursor: pointer;
  transition: background-color 160ms ease;
}

.project-table tbody tr:hover {
  background: rgba(79, 110, 247, 0.05);
}

.project-table tbody tr:last-child td {
  border-bottom: none;
}
</style>
