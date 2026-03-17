<script setup lang="ts">
import { useRoute } from 'vue-router'

import { globalNavGroups } from '../../mocks/navigation'

const route = useRoute()

function isActive(path: string) {
  return route.path === path
}
</script>

<template>
  <aside class="sidebar" data-testid="global-sidebar">
    <div class="sidebar-logo">
      <div class="logo-icon">AI</div>
      <div>
        <div class="logo-text">AI 中台</div>
        <div class="logo-sub">Enterprise AI Platform</div>
      </div>
    </div>

    <div v-for="group in globalNavGroups" :key="group.label" class="nav-section">
      <div class="nav-label">{{ group.label }}</div>
      <RouterLink
        v-for="item in group.items"
        :key="item.key"
        :to="item.to"
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
        <div class="role">超级管理员</div>
      </div>
    </div>
  </aside>
</template>
