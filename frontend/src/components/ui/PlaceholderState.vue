<script setup lang="ts">
defineProps<{
  eyebrow: string
  title: string
  description: string
  highlights: string[]
}>()
</script>

<template>
  <section class="placeholder-state">
    <div class="placeholder-eyebrow">{{ eyebrow }}</div>
    <h2 class="placeholder-title">{{ title }}</h2>
    <p class="placeholder-description">{{ description }}</p>

    <div class="placeholder-grid">
      <article v-for="highlight in highlights" :key="highlight" class="placeholder-card">
        {{ highlight }}
      </article>
    </div>
  </section>
</template>

<style scoped>
.placeholder-state {
  padding: 32px;
  background: linear-gradient(180deg, rgba(255, 255, 255, 0.92) 0%, rgba(238, 241, 255, 0.9) 100%);
  border: 1px solid rgba(79, 110, 247, 0.16);
  border-radius: 28px;
  box-shadow: var(--shadow-soft);
}

.placeholder-eyebrow {
  color: var(--primary);
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.placeholder-title {
  margin: 14px 0 10px;
  font-size: 30px;
  line-height: 1.15;
}

.placeholder-description {
  max-width: 700px;
  margin: 0;
  color: var(--text-subtle);
  line-height: 1.7;
}

.placeholder-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 14px;
  margin-top: 24px;
}

.placeholder-card {
  padding: 16px;
  background: white;
  border: 1px solid rgba(79, 110, 247, 0.12);
  border-radius: 18px;
  font-weight: 600;
}
</style>
