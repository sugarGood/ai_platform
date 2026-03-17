<template>
  <section class="project-not-found" data-testid="project-not-found">
    <div class="eyebrow">Unknown Project</div>
    <h2>未找到对应的项目上下文</h2>
    <p>当前项目 ID 不存在于本地 mock 数据中。你仍然可以返回项目空间继续浏览其他项目。</p>
    <RouterLink class="back-link" to="/projects">返回项目空间</RouterLink>
  </section>
</template>

<style scoped>
.project-not-found {
  padding: 32px;
  background: rgba(255, 255, 255, 0.92);
  border: 1px solid var(--card-border);
  border-radius: 28px;
  box-shadow: var(--shadow-soft);
}

.eyebrow {
  color: var(--danger);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

h2 {
  margin: 14px 0 12px;
  font-size: 30px;
}

p {
  max-width: 680px;
  margin: 0;
  color: var(--text-subtle);
  line-height: 1.7;
}

.back-link {
  display: inline-flex;
  margin-top: 22px;
  border-radius: 999px;
  padding: 10px 16px;
  background: var(--primary-soft);
  color: var(--primary);
  font-weight: 600;
}
</style>
