<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute } from 'vue-router'

import CardPanel from '../../components/ui/CardPanel.vue'
import ModuleContent from '../../components/ui/ModuleContent.vue'
import StatCard from '../../components/ui/StatCard.vue'
import { getProjectById } from '../../composables/useProjects'
import type { CatalogItem, ListItem, ModuleSection, PageMetric, TableCell, TableData, Tone } from '../../types/module-page'
import NotFoundProjectState from './NotFoundProjectState.vue'

const route = useRoute()
const activeTab = ref<'overview' | 'cicd' | 'envs' | 'mcp'>('overview')

function cell(text: string, tone?: TableCell['tone'], mono = false): TableCell {
  return { text, tone, mono }
}

const project = computed(() => {
  if (typeof route.params.projectId !== 'string') {
    return undefined
  }

  return getProjectById(route.params.projectId)
})

const serviceId = computed(() =>
  typeof route.params.serviceId === 'string' ? route.params.serviceId : '',
)

interface ServiceDetailData {
  icon: string
  name: string
  techStack: string
  statusLabel: string
  statusTone: Tone
  metrics: PageMetric[]
  pullRequests: ListItem[]
  aiNotes: ListItem[]
  pipelineTable: TableData
  environments: CatalogItem[]
  mcpCode: string
  mcpTools: ListItem[]
}

function buildServiceDetail(): ServiceDetailData | undefined {
  if (!project.value) {
    return undefined
  }

  // ?????????????????????????????????
  if (project.value.id === 'mall' && serviceId.value === 'mall-backend') {
    return {
      icon: '🍃',
      name: 'mall-backend',
      techStack: 'Spring Boot 3 · Java · MySQL',
      statusLabel: '正常',
      statusTone: 'success',
      metrics: [
        { id: 'builds', icon: '🔧', label: '今日构建', value: '6', delta: '成功率 100%', tone: 'primary' },
        { id: 'latency', icon: '⚡', label: 'Prod P99 延迟', value: '120ms', delta: '稳定在阈值以内', tone: 'success' },
        { id: 'coverage', icon: '🧪', label: '测试覆盖率', value: '82%', delta: '较上周 +3%', tone: 'success' },
        { id: 'loc', icon: '📦', label: '代码行数', value: '48K', delta: 'AI 贡献 38%', tone: 'primary' },
      ],
      pullRequests: [
        { title: 'feat: 商品搜索 ES 接入', meta: '李四 · feature/search · AI Review：通过', badge: 'Review 中', tone: 'primary' },
        { title: 'fix: 购物车并发锁优化', meta: '张三 · feature/cart-fix · 已合并', badge: '已合并', tone: 'success' },
      ],
      aiNotes: [
        { title: 'OrderService:203 缺少事务回滚处理', meta: '建议在订单扣减库存失败时补充回滚与重试机制', badge: '风险提示', tone: 'warning' },
        { title: 'PaymentController 参数校验不完整', meta: '可补充空值校验与枚举校验', badge: '建议修复', tone: 'primary' },
      ],
      pipelineTable: {
        columns: ['分支', '触发', '阶段', '时长', '状态', '时间'],
        rows: [
          [cell('feature/search', 'default', true), cell('李四 Push'), cell('构建 → 单测 → 部署'), cell('2m 10s'), cell('运行中', 'primary'), cell('5 分钟前')],
          [cell('main', 'default', true), cell('Merge PR#45'), cell('构建 → 单测 → 部署'), cell('5m 44s'), cell('成功', 'success'), cell('30 分钟前')],
        ],
      },
      environments: [
        {
          icon: '🧪',
          title: 'DEV',
          badge: '健康',
          tone: 'success',
          lines: [
            { label: '地址', value: 'dev-backend.company.internal', mono: true },
            { label: '当前分支', value: 'feature/search', mono: true },
            { label: '自动部署', value: '每次 Push' },
          ],
          cta: '查看日志',
        },
        {
          icon: '🛰️',
          title: 'STAGING',
          badge: '健康',
          tone: 'success',
          lines: [
            { label: '地址', value: 'staging-backend.company.internal', mono: true },
            { label: '当前版本', value: 'main #7b9c4d', mono: true },
            { label: '部署策略', value: '手动 · 需审批' },
          ],
          cta: '查看日志',
        },
        {
          icon: '🏭',
          title: 'PROD',
          badge: '稳定',
          tone: 'success',
          lines: [
            { label: '地址', value: 'api.mall.company.com', mono: true },
            { label: '当前版本', value: 'v2.3.1', mono: true },
            { label: '实例数', value: '4 Pods' },
          ],
          cta: '🚀 发起部署',
        },
      ],
      mcpCode: '{\n  "mcpServers": {\n    "mall-backend": {\n      "url": "https://mcp.ai.co/svc/mall-backend",\n      "token": "sk-svc-xxxxxxxxxxxx"\n    }\n  }\n}',
      mcpTools: [
        { title: 'search_knowledge', meta: '语义搜索项目知识库和需求文档', badge: '检索', tone: 'primary' },
        { title: 'get_atomic_capability', meta: '获取原子能力接入文档和示例代码', badge: '能力', tone: 'success' },
        { title: 'report_bug', meta: '在 IDE 中直接创建事故任务', badge: '运维', tone: 'danger' },
        { title: 'trigger_deploy', meta: '触发指定环境的服务部署', badge: '发布', tone: 'warning' },
      ],
    }
  }

  const service = project.value.services.find((item) => item.id === serviceId.value)
  if (!service) {
    return undefined
  }

  return {
    icon: '⚙️',
    name: service.name,
    techStack: service.techStack,
    statusLabel: service.statusLabel,
    statusTone: service.statusTone,
    metrics: [
      { id: 'builds', icon: '🔧', label: '今日构建', value: '3', delta: '最近一次已完成', tone: 'primary' },
      { id: 'latency', icon: '⚡', label: '服务健康', value: service.statusLabel, delta: service.deployMeta, tone: service.statusTone === 'warning' ? 'warning' : 'success' },
      { id: 'coverage', icon: '🧪', label: '测试覆盖率', value: '78%', delta: '建议补齐关键路径用例', tone: 'primary' },
      { id: 'loc', icon: '📦', label: '仓库状态', value: '已接入', delta: 'MCP / CI / 环境已纳管', tone: 'success' },
    ],
    pullRequests: [
      { title: `feat: ${service.name} 新能力接入`, meta: `${project.value.name} · 最近 PR`, badge: 'Review 中', tone: 'primary' },
      { title: `fix: ${service.name} 稳定性修复`, meta: '最近一次已合并', badge: '已合并', tone: 'success' },
    ],
    aiNotes: [{ title: 'AI 建议', meta: '建议补齐核心接口契约测试和上线回归检查。', badge: '建议', tone: 'primary' }],
    pipelineTable: {
      columns: ['分支', '触发', '阶段', '时长', '状态', '时间'],
      rows: [[cell('main', 'default', true), cell('Merge PR'), cell('构建 → 单测 → 部署'), cell('4m 20s'), cell(service.statusLabel, service.statusTone), cell('最近一次')]],
    },
    environments: [
      { icon: '🧪', title: 'DEV', badge: '可用', tone: 'success', lines: [{ label: '部署策略', value: '自动部署' }, { label: '当前版本', value: 'latest', mono: true }], cta: '查看日志' },
      { icon: '🛰️', title: 'STAGING', badge: '受控', tone: 'warning', lines: [{ label: '部署策略', value: '手动审批' }, { label: '当前版本', value: 'main', mono: true }], cta: '查看日志' },
      { icon: '🏭', title: 'PROD', badge: '稳定', tone: 'success', lines: [{ label: '状态', value: service.statusLabel }, { label: '最近部署', value: service.deployMeta }], cta: '查看部署' },
    ],
    mcpCode: `{\n  "mcpServers": {\n    "${service.name}": {\n      "url": "https://mcp.ai.co/svc/${service.name}",\n      "token": "sk-svc-xxxxxxxxxxxx"\n    }\n  }\n}`,
    mcpTools: [
      { title: 'search_knowledge', meta: '搜索项目知识库', badge: '检索', tone: 'primary' },
      { title: 'report_bug', meta: '创建事故任务', badge: '运维', tone: 'danger' },
    ],
  }
}

const detail = computed(() => buildServiceDetail())

const envSections = computed<ModuleSection[]>(() => {
  if (!detail.value) {
    return []
  }

  // ??????????? ModuleContent???????????????
  return [
    {
      type: 'catalog-grid',
      columns: 3,
      items: detail.value.environments,
    },
  ]
})
</script>

<template>
  <NotFoundProjectState v-if="!project || !detail" />

  <section v-else class="service-detail-page" data-testid="service-detail-page">
    <div class="service-header">
      <RouterLink class="back-button" :to="`/projects/${project.id}/services`">← 代码服务</RouterLink>
      <span class="service-icon">{{ detail.icon }}</span>
      <div>
        <div class="service-name">{{ detail.name }}</div>
        <div class="service-meta">{{ detail.techStack }}</div>
      </div>
      <span class="status-badge" :class="detail.statusTone">{{ detail.statusLabel }}</span>
    </div>

    <div class="service-tabs">
      <button type="button" :class="['service-tab', { active: activeTab === 'overview' }]" @click="activeTab = 'overview'">📊 概览</button>
      <button type="button" :class="['service-tab', { active: activeTab === 'cicd' }]" @click="activeTab = 'cicd'">🔧 CI/CD</button>
      <button type="button" :class="['service-tab', { active: activeTab === 'envs' }]" @click="activeTab = 'envs'">🌍 环境管理</button>
      <button type="button" :class="['service-tab', { active: activeTab === 'mcp' }]" @click="activeTab = 'mcp'">🔌 MCP 配置</button>
    </div>

    <div v-show="activeTab === 'overview'" class="tab-panel">
      <div class="stats-grid">
        <StatCard
          v-for="metric in detail.metrics"
          :key="metric.id"
          :delta="metric.delta"
          :icon="metric.icon"
          :label="metric.label"
          :tone="metric.tone"
          :value="metric.value"
        />
      </div>

      <div class="detail-grid">
        <CardPanel title="最近 PR">
          <div class="list-stack">
            <article v-for="item in detail.pullRequests" :key="item.title" class="detail-item">
              <div>
                <div class="detail-title">{{ item.title }}</div>
                <div class="detail-meta">{{ item.meta }}</div>
              </div>
              <span class="status-badge" :class="item.tone">{{ item.badge }}</span>
            </article>
          </div>
        </CardPanel>

        <CardPanel title="🤖 AI 代码质量分析">
          <div class="list-stack">
            <article v-for="item in detail.aiNotes" :key="item.title" class="detail-item compact">
              <div>
                <div class="detail-title">{{ item.title }}</div>
                <div class="detail-meta">{{ item.meta }}</div>
              </div>
              <span class="status-badge" :class="item.tone">{{ item.badge }}</span>
            </article>
          </div>
        </CardPanel>
      </div>
    </div>

    <div v-show="activeTab === 'cicd'" class="tab-panel">
      <CardPanel title="流水线记录">
        <div class="table-shell">
          <table class="module-table">
            <thead>
              <tr>
                <th v-for="column in detail.pipelineTable.columns" :key="column">{{ column }}</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(row, rowIndex) in detail.pipelineTable.rows" :key="rowIndex">
                <td v-for="(entry, cellIndex) in row" :key="cellIndex">{{ entry.text }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </CardPanel>
    </div>

    <div v-show="activeTab === 'envs'" class="tab-panel">
      <ModuleContent :sections="envSections" />
    </div>

    <div v-show="activeTab === 'mcp'" class="tab-panel">
      <div class="detail-grid">
        <CardPanel title="🔌 服务 MCP Server">
          <div class="mcp-description">在 IDE 中接入此地址，AI 将自动拥有该服务的知识库、原子能力和操作工具。</div>
          <pre class="code-block"><code>{{ detail.mcpCode }}</code></pre>
        </CardPanel>

        <CardPanel title="MCP 暴露的工具">
          <div class="list-stack">
            <article v-for="item in detail.mcpTools" :key="item.title" class="detail-item compact">
              <div>
                <div class="detail-title">{{ item.title }}</div>
                <div class="detail-meta">{{ item.meta }}</div>
              </div>
              <span class="status-badge" :class="item.tone">{{ item.badge }}</span>
            </article>
          </div>
        </CardPanel>
      </div>
    </div>
  </section>
</template>

<style scoped>
.service-detail-page {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.service-header,
.service-tabs {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.back-button,
.service-tab {
  border: 1px solid rgba(17, 24, 39, 0.08);
  border-radius: 999px;
  padding: 10px 14px;
  background: rgba(255, 255, 255, 0.82);
  box-shadow: var(--shadow-soft);
}

.service-tab {
  cursor: pointer;
}

.service-tab.active {
  background: linear-gradient(135deg, #4f6ef7 0%, #5d7bff 100%);
  color: white;
  border-color: transparent;
}

.service-icon {
  font-size: 28px;
}

.service-name,
.detail-title {
  font-weight: 700;
}

.service-meta,
.detail-meta,
.mcp-description {
  color: var(--text-subtle);
  font-size: 13px;
}

.stats-grid,
.detail-grid {
  display: grid;
  gap: 16px;
}

.stats-grid {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.detail-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.list-stack {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.detail-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(229, 231, 235, 0.9);
}

.detail-item:last-child {
  padding-bottom: 0;
  border-bottom: none;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  border-radius: 999px;
  padding: 6px 10px;
  background: rgba(17, 24, 39, 0.08);
  font-size: 12px;
  font-weight: 600;
}

.status-badge.primary {
  background: var(--primary-soft);
  color: var(--primary);
}

.status-badge.success {
  background: rgba(18, 183, 106, 0.12);
  color: var(--success);
}

.status-badge.warning {
  background: rgba(247, 144, 9, 0.12);
  color: var(--warning);
}

.status-badge.danger {
  background: rgba(240, 68, 56, 0.12);
  color: var(--danger);
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
}

.code-block {
  margin-top: 12px;
  overflow-x: auto;
  padding: 16px;
  border-radius: 18px;
  background: #0f172a;
  color: #d6e2ff;
  font-family: 'Cascadia Code', 'Consolas', monospace;
  font-size: 12px;
  line-height: 1.7;
}

@media (max-width: 1180px) {
  .stats-grid,
  .detail-grid {
    grid-template-columns: 1fr;
  }
}
</style>

