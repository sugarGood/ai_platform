<script setup lang="ts">
import { RouterLink } from 'vue-router'

import type {
  CatalogItem,
  ModuleSection,
  PageAction,
  TableCell,
  Tone,
} from '../../types/module-page'
import CardPanel from './CardPanel.vue'
import StatCard from './StatCard.vue'
import { useOverlay } from '../../composables/useOverlay'

const props = defineProps<{
  sections: ModuleSection[]
}>()

const { triggerModuleAction } = useOverlay()

function toneClass(tone?: Tone) {
  return tone ? `tone-${tone}` : 'tone-default'
}

function actionClass(action?: PageAction) {
  return action?.variant === 'primary' ? 'module-action primary' : 'module-action'
}

function gridClass(columns?: 1 | 2 | 3) {
  if (columns === 1) {
    return 'grid-one'
  }

  if (columns === 3) {
    return 'grid-three'
  }

  return 'grid-two'
}

function cardTag(item: CatalogItem) {
  return item.to ? RouterLink : 'article'
}

function tableCellClass(cell: TableCell) {
  return [toneClass(cell.tone), cell.mono ? 'cell-mono' : '']
}

function actionTestId(label: string) {
  return `module-action-${label}`
}

// ?? section ?????????????????????????????
function resolveActionContext(section: ModuleSection) {
  if ('title' in section && typeof section.title === 'string') {
    return section.title
  }

  if (section.type === 'hero' && section.title) {
    return section.title
  }

  return undefined
}

// ?????????????????????? overlay composable ?????
function handleActionClick(action: PageAction, section: ModuleSection) {
  triggerModuleAction(action.label, resolveActionContext(section))
}
</script>

<template>
  <div class="module-content">
    <template v-for="(section, index) in sections" :key="`${section.type}-${index}`">
      <section v-if="section.type === 'hero'" class="module-hero">
        <div>
          <div v-if="section.eyebrow" class="module-eyebrow">{{ section.eyebrow }}</div>
          <h1 v-if="section.title" class="module-title">{{ section.title }}</h1>
          <p class="module-description">{{ section.description }}</p>
        </div>

        <div v-if="section.actions?.length" class="module-actions">
          <button
            v-for="action in section.actions"
            :key="action.label"
            :class="actionClass(action)"
            :data-testid="actionTestId(action.label)"
            type="button"
            @click="handleActionClick(action, section)"
          >
            {{ action.label }}
          </button>
        </div>
      </section>

      <section v-else-if="section.type === 'metrics'" class="module-metrics">
        <StatCard
          v-for="metric in section.items"
          :key="metric.id"
          :delta="metric.delta"
          :icon="metric.icon"
          :label="metric.label"
          :tone="metric.tone"
          :value="metric.value"
        />
      </section>

      <section v-else-if="section.type === 'catalog-grid'" class="module-block">
        <div v-if="section.title" class="section-kicker">{{ section.title }}</div>
        <div class="catalog-grid" :class="gridClass(section.columns)">
          <component
            :is="cardTag(item)"
            v-for="item in section.items"
            :key="item.title"
            :to="item.to"
            class="catalog-card"
          >
            <div class="catalog-head">
              <span v-if="item.icon" class="catalog-icon">{{ item.icon }}</span>
              <span v-if="item.badge" class="badge-pill" :class="toneClass(item.tone)">{{ item.badge }}</span>
            </div>
            <div class="catalog-title">{{ item.title }}</div>
            <div v-if="item.subtitle" class="catalog-subtitle">{{ item.subtitle }}</div>
            <div v-if="item.description" class="catalog-description">{{ item.description }}</div>
            <div v-if="item.lines?.length" class="catalog-lines">
              <div v-for="line in item.lines" :key="`${item.title}-${line.label}`" class="info-row">
                <span class="info-label">{{ line.label }}</span>
                <span :class="[toneClass(line.tone), line.mono ? 'mono-text' : '']">{{ line.value }}</span>
              </div>
            </div>
            <div v-if="item.cta" class="catalog-cta">{{ item.cta }}</div>
          </component>
        </div>
      </section>

      <section v-else-if="section.type === 'list-grid'" class="module-grid" :class="gridClass(section.columns)">
        <CardPanel v-for="card in section.cards" :key="card.title" :badge="card.badge" :title="card.title">
          <div class="list-stack">
            <article v-for="item in card.items" :key="`${card.title}-${item.title}`" class="list-item">
              <div class="list-main">
                <div class="list-title-row">
                  <div class="list-title">{{ item.title }}</div>
                  <span v-if="item.badge" class="badge-pill" :class="toneClass(item.tone)">
                    {{ item.badge }}
                  </span>
                </div>
                <div v-if="item.meta" class="list-meta">{{ item.meta }}</div>
                <div v-if="item.description" class="list-description">{{ item.description }}</div>
                <div v-if="typeof item.progress === 'number'" class="progress-wrap slim">
                  <div class="progress-bar" :class="toneClass(item.tone)" :style="{ width: `${item.progress}%` }" />
                </div>
              </div>
            </article>
          </div>

          <div v-if="card.note" class="note-bubble" :class="toneClass(card.note.tone)">
            <strong v-if="card.note.label">{{ card.note.label }}?</strong>
            {{ card.note.content }}
          </div>
        </CardPanel>
      </section>

      <CardPanel v-else-if="section.type === 'table'" :badge="section.badge" :title="section.title">
        <div class="table-shell">
          <table class="module-table">
            <thead>
              <tr>
                <th v-for="column in section.table.columns" :key="column">{{ column }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(row, rowIndex) in section.table.rows" :key="`${section.title}-${rowIndex}`">
                <td v-for="(cell, cellIndex) in row" :key="`${section.title}-${rowIndex}-${cellIndex}`">
                  <span :class="tableCellClass(cell)">{{ cell.text }}</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div v-if="section.note" class="table-note">{{ section.note }}</div>
      </CardPanel>

      <CardPanel v-else-if="section.type === 'progress'" :badge="section.badge" :title="section.title">
        <div class="progress-list">
          <div v-for="item in section.items" :key="item.label" class="progress-item">
            <div class="progress-label-row">
              <span class="progress-label">{{ item.label }}</span>
              <span class="progress-value" :class="toneClass(item.tone)">{{ item.value }}</span>
            </div>
            <div class="progress-wrap">
              <div class="progress-bar" :class="toneClass(item.tone)" :style="{ width: `${item.progress}%` }" />
            </div>
            <div v-if="item.hint" class="progress-hint">{{ item.hint }}</div>
          </div>
        </div>
        <div v-if="section.note" class="note-bubble" :class="toneClass(section.note.tone)">
          <strong v-if="section.note.label">{{ section.note.label }}?</strong>
          {{ section.note.content }}
        </div>
      </CardPanel>

      <CardPanel v-else-if="section.type === 'notes'" :badge="section.badge" :title="section.title">
        <div class="note-stack">
          <div
            v-for="note in section.notes"
            :key="`${section.title}-${note.label ?? note.content}`"
            class="note-bubble"
            :class="toneClass(note.tone)"
          >
            <strong v-if="note.label">{{ note.label }}?</strong>
            {{ note.content }}
          </div>
        </div>
      </CardPanel>

      <CardPanel v-else-if="section.type === 'code'" :badge="section.badge" :title="section.title">
        <p v-if="section.description" class="code-description">{{ section.description }}</p>
        <pre class="code-block"><code>{{ section.code }}</code></pre>
        <div v-if="section.actions?.length" class="module-actions inside">
          <button
            v-for="action in section.actions"
            :key="action.label"
            :class="actionClass(action)"
            :data-testid="actionTestId(action.label)"
            type="button"
            @click="handleActionClick(action, section)"
          >
            {{ action.label }}
          </button>
        </div>
      </CardPanel>

      <CardPanel v-else-if="section.type === 'kanban'" :title="section.title">
        <div class="kanban-grid">
          <section v-for="column in section.columns" :key="column.title" class="kanban-column">
            <div class="kanban-head">
              <div class="kanban-title">{{ column.title }}</div>
              <span v-if="column.badge" class="badge-pill" :class="toneClass(column.tone)">
                {{ column.badge }}
              </span>
            </div>
            <article v-for="item in column.items" :key="item.title" class="kanban-card">
              <div class="list-title-row">
                <div class="list-title">{{ item.title }}</div>
                <span v-if="item.badge" class="badge-pill" :class="toneClass(item.tone)">
                  {{ item.badge }}
                </span>
              </div>
              <div v-if="item.meta" class="list-meta">{{ item.meta }}</div>
              <div v-if="item.description" class="list-description">{{ item.description }}</div>
            </article>
          </section>
        </div>
      </CardPanel>

      <section v-else-if="section.type === 'split'" class="module-grid" :class="gridClass(section.columns)">
        <CardPanel v-for="item in section.items" :key="item.title" :badge="item.badge" :title="item.title">
          <div v-if="item.lines?.length" class="catalog-lines">
            <div v-for="line in item.lines" :key="`${item.title}-${line.label}`" class="info-row">
              <span class="info-label">{{ line.label }}</span>
              <span :class="[toneClass(line.tone), line.mono ? 'mono-text' : '']">{{ line.value }}</span>
            </div>
          </div>

          <div v-if="item.list?.length" class="list-stack">
            <article v-for="entry in item.list" :key="`${item.title}-${entry.title}`" class="list-item compact">
              <div class="list-main">
                <div class="list-title-row">
                  <div class="list-title">{{ entry.title }}</div>
                  <span v-if="entry.badge" class="badge-pill" :class="toneClass(entry.tone)">
                    {{ entry.badge }}
                  </span>
                </div>
                <div v-if="entry.meta" class="list-meta">{{ entry.meta }}</div>
                <div v-if="entry.description" class="list-description">{{ entry.description }}</div>
              </div>
            </article>
          </div>

          <div v-if="item.notes?.length" class="note-stack">
            <div
              v-for="note in item.notes"
              :key="`${item.title}-${note.label ?? note.content}`"
              class="note-bubble"
              :class="toneClass(note.tone)"
            >
              <strong v-if="note.label">{{ note.label }}?</strong>
              {{ note.content }}
            </div>
          </div>

          <pre v-if="item.code" class="code-block compact"><code>{{ item.code }}</code></pre>

          <div v-if="item.actions?.length" class="module-actions inside">
            <button
              v-for="action in item.actions"
              :key="action.label"
              :class="actionClass(action)"
              type="button"
            >
              {{ action.label }}
            </button>
          </div>
        </CardPanel>
      </section>
    </template>
  </div>
</template>

<style scoped>
.module-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.module-hero {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  padding: 28px;
  border: 1px solid rgba(79, 110, 247, 0.14);
  border-radius: 28px;
  background:
    radial-gradient(circle at top right, rgba(79, 110, 247, 0.22), transparent 28%),
    linear-gradient(135deg, rgba(255, 255, 255, 0.96) 0%, rgba(238, 241, 255, 0.92) 100%);
  box-shadow: var(--shadow-soft);
}

.module-eyebrow,
.section-kicker {
  color: var(--primary);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.section-kicker {
  margin-bottom: 12px;
}

.module-title {
  margin: 12px 0 10px;
  font-size: 34px;
  line-height: 1.1;
}

.module-description,
.code-description,
.table-note,
.progress-hint,
.list-description,
.catalog-description {
  color: var(--text-subtle);
  line-height: 1.7;
}

.module-description {
  max-width: 760px;
  margin: 0;
}

.module-actions {
  display: inline-flex;
  flex-wrap: wrap;
  gap: 12px;
}

.module-actions.inside {
  margin-top: 16px;
}

.module-action {
  border: 1px solid rgba(17, 24, 39, 0.08);
  border-radius: 999px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.75);
  box-shadow: var(--shadow-soft);
  cursor: pointer;
}

.module-action.primary {
  border-color: transparent;
  background: linear-gradient(135deg, #4f6ef7 0%, #5d7bff 100%);
  color: white;
}

.module-metrics,
.module-grid.grid-two,
.module-grid.grid-three,
.catalog-grid.grid-two,
.catalog-grid.grid-three {
  display: grid;
  gap: 16px;
}

.module-metrics {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.grid-one {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
}

.grid-two {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.grid-three {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.catalog-card {
  display: flex;
  flex-direction: column;
  min-width: 0;
  padding: 20px;
  border: 1px solid var(--card-border);
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.9);
  box-shadow: var(--shadow-soft);
}

.catalog-head,
.list-title-row,
.info-row,
.progress-label-row,
.kanban-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.catalog-icon {
  font-size: 28px;
}

.catalog-title,
.list-title,
.kanban-title {
  font-size: 15px;
  font-weight: 700;
}

.catalog-subtitle,
.list-meta,
.info-label {
  color: var(--text-subtle);
  font-size: 12px;
}

.catalog-subtitle {
  margin-top: 8px;
}

.catalog-description,
.catalog-lines,
.catalog-cta {
  margin-top: 12px;
}

.catalog-lines,
.list-stack,
.note-stack,
.progress-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.catalog-cta {
  color: var(--primary);
  font-size: 12px;
  font-weight: 600;
}

.list-item {
  display: flex;
  gap: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.9);
}

.list-item:last-child {
  padding-bottom: 0;
  border-bottom: none;
}

.list-item.compact {
  padding-bottom: 10px;
}

.list-main {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 4px;
}

.badge-pill {
  display: inline-flex;
  align-items: center;
  flex-shrink: 0;
  border-radius: 999px;
  padding: 4px 10px;
  background: rgba(17, 24, 39, 0.08);
  color: var(--text-main);
  font-size: 12px;
  font-weight: 600;
}

.note-bubble {
  margin-top: 14px;
  padding: 14px 16px;
  border-radius: 18px;
  background: rgba(79, 110, 247, 0.08);
  color: var(--text-main);
  line-height: 1.7;
  white-space: pre-line;
}

.table-shell {
  overflow-x: auto;
}

.module-table {
  width: 100%;
  border-collapse: collapse;
}

.module-table th,
.module-table td {
  padding: 12px 10px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.9);
  text-align: left;
  font-size: 13px;
}

.module-table th {
  color: var(--text-subtle);
  font-size: 12px;
  font-weight: 600;
}

.progress-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.progress-label,
.progress-value {
  font-size: 13px;
  font-weight: 600;
}

.progress-wrap {
  width: 100%;
  height: 8px;
  border-radius: 999px;
  background: rgba(229, 231, 235, 0.9);
  overflow: hidden;
}

.progress-wrap.slim {
  height: 6px;
  margin-top: 6px;
}

.progress-bar {
  height: 100%;
  border-radius: inherit;
  background: var(--primary);
}

.kanban-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 16px;
}

.kanban-column {
  padding: 16px;
  border-radius: 20px;
  background: rgba(244, 246, 252, 0.9);
}

.kanban-card {
  margin-top: 12px;
  padding: 14px;
  border: 1px solid rgba(229, 231, 235, 0.9);
  border-radius: 16px;
  background: white;
}

.code-block {
  margin: 0;
  overflow-x: auto;
  padding: 16px;
  border-radius: 18px;
  background: #0f172a;
  color: #d6e2ff;
  font-family: 'Cascadia Code', 'Consolas', monospace;
  font-size: 12px;
  line-height: 1.7;
}

.code-block.compact {
  margin-top: 12px;
}

.mono-text,
.cell-mono {
  font-family: 'Cascadia Code', 'Consolas', monospace;
}

.tone-default {
  color: inherit;
}

.tone-muted {
  color: var(--text-subtle);
}

.tone-primary {
  color: var(--primary);
}

.tone-success {
  color: var(--success);
}

.tone-warning {
  color: var(--warning);
}

.tone-danger {
  color: var(--danger);
}

.badge-pill.tone-primary {
  background: var(--primary-soft);
}

.badge-pill.tone-success {
  background: rgba(18, 183, 106, 0.12);
}

.badge-pill.tone-warning {
  background: rgba(247, 144, 9, 0.12);
}

.badge-pill.tone-danger {
  background: rgba(240, 68, 56, 0.12);
}

.note-bubble.tone-success {
  background: rgba(18, 183, 106, 0.1);
}

.note-bubble.tone-warning {
  background: rgba(247, 144, 9, 0.12);
}

.note-bubble.tone-danger {
  background: rgba(240, 68, 56, 0.1);
}

@media (max-width: 1180px) {
  .module-hero {
    align-items: flex-start;
    flex-direction: column;
  }

  .module-metrics {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .grid-two,
  .grid-three,
  .kanban-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 720px) {
  .module-metrics {
    grid-template-columns: 1fr;
  }
}
</style>
