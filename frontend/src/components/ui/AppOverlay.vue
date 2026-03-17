<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'

import { useOverlay } from '../../composables/useOverlay'

const { closeOverlay, overlayState, submitNewProjectDraft } = useOverlay()

// ???? Esc ????????????????????
onMounted(() => {
  document.addEventListener('keydown', onKeydown)
})

onUnmounted(() => {
  document.removeEventListener('keydown', onKeydown)
})

function onKeydown(event: KeyboardEvent) {
  if (event.key === 'Escape' && overlayState.open) {
    closeOverlay()
  }
}
</script>

<template>
  <div v-if="overlayState.open" class="overlay-backdrop" data-testid="app-overlay" @click.self="closeOverlay">
    <section class="overlay-panel">
      <header class="overlay-header">
        <div>
          <div class="overlay-title">{{ overlayState.title }}</div>
          <div class="overlay-description">{{ overlayState.description }}</div>
        </div>
        <button class="overlay-close" type="button" @click="closeOverlay">✕</button>
      </header>

      <div v-if="overlayState.kind === 'notifications'" data-testid="notifications-panel" class="overlay-body">
        <article v-for="item in overlayState.items" :key="item" class="overlay-list-item">{{ item }}</article>
      </div>

      <div v-else-if="overlayState.kind === 'new-project'" data-testid="new-project-modal" class="overlay-body form-body">
        <!-- ???????????????????????????? -->
        <label class="form-field">
          <span>项目名称</span>
          <input v-model="overlayState.draft.name" placeholder="例：支付网关 v2" />
        </label>
        <label class="form-field">
          <span>项目类型</span>
          <select v-model="overlayState.draft.type">
            <option>对外产品</option>
            <option>内部系统</option>
            <option>技术中台</option>
            <option>数据产品</option>
          </select>
        </label>
        <label class="form-field">
          <span>项目描述</span>
          <textarea v-model="overlayState.draft.description" rows="3" placeholder="简要描述项目背景和目标"></textarea>
        </label>
        <label class="form-field">
          <span>Git 仓库地址</span>
          <input v-model="overlayState.draft.repo" placeholder="git.company.com/team/project-name" />
        </label>
        <label class="form-field">
          <span>主干分支</span>
          <input v-model="overlayState.draft.branch" placeholder="main" />
        </label>

        <div class="overlay-actions">
          <button class="secondary-button" type="button" @click="closeOverlay">取消</button>
          <button class="primary-button" type="button" @click="submitNewProjectDraft">创建草稿</button>
        </div>
      </div>

      <!-- ?????????????????????????? -->
      <div v-else data-testid="action-modal" class="overlay-body">
        <article v-for="item in overlayState.items" :key="item" class="overlay-list-item">{{ item }}</article>
        <div v-if="overlayState.shortcuts.length" class="overlay-shortcuts">
          <RouterLink
            v-for="shortcut in overlayState.shortcuts"
            :key="shortcut.label"
            class="shortcut-link"
            :to="shortcut.to ?? '/dashboard'"
            @click="closeOverlay"
          >
            {{ shortcut.label }}
          </RouterLink>
        </div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.overlay-backdrop {
  position: fixed;
  inset: 0;
  z-index: 60;
  display: grid;
  place-items: center;
  padding: 24px;
  background: rgba(15, 23, 42, 0.42);
  backdrop-filter: blur(6px);
}

.overlay-panel {
  width: min(680px, 100%);
  max-height: calc(100vh - 48px);
  overflow: auto;
  border: 1px solid rgba(79, 110, 247, 0.12);
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.97);
  box-shadow: 0 24px 80px rgba(15, 23, 42, 0.22);
}

.overlay-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  padding: 24px 24px 0;
}

.overlay-title {
  font-size: 22px;
  font-weight: 700;
}

.overlay-description {
  margin-top: 8px;
  color: var(--text-subtle);
  line-height: 1.7;
}

.overlay-close {
  border: none;
  border-radius: 999px;
  padding: 8px 12px;
  background: rgba(15, 23, 42, 0.06);
  cursor: pointer;
}

.overlay-body {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 20px 24px 24px;
}

.overlay-list-item {
  padding: 14px 16px;
  border: 1px solid rgba(229, 231, 235, 0.9);
  border-radius: 18px;
  background: rgba(248, 250, 252, 0.9);
  line-height: 1.7;
}

.form-body {
  gap: 16px;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
}

.form-field input,
.form-field select,
.form-field textarea {
  width: 100%;
  border: 1px solid rgba(209, 213, 219, 0.95);
  border-radius: 14px;
  padding: 12px 14px;
  font: inherit;
}

.overlay-actions,
.overlay-shortcuts {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  flex-wrap: wrap;
}

.secondary-button,
.shortcut-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(17, 24, 39, 0.08);
  border-radius: 999px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.75);
  box-shadow: var(--shadow-soft);
}
</style>
