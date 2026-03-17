<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import ModuleContent from '../../components/ui/ModuleContent.vue'
import { getProjectById } from '../../mocks/projects'
import type { CatalogItem, ModulePageConfig, TableCell } from '../../types/module-page'
import NotFoundProjectState from './NotFoundProjectState.vue'

const route = useRoute()

// ?????????????????????????????
function cell(text: string, tone?: TableCell['tone'], mono = false): TableCell {
  return { text, tone, mono }
}

// ?????????????????????????????
const project = computed(() => {
  if (typeof route.params.projectId !== 'string') {
    return undefined
  }

  return getProjectById(route.params.projectId)
})

// ??????? section ????????????? overview ???
const section = computed(() =>
  typeof route.params.section === 'string' ? route.params.section : 'overview',
)

// ???????????? ModuleContent ???????????
function buildServiceCards(projectId: string) {
  const serviceMeta: Record<string, { icon: string; repo: string; branch: string; deploy: string; ci: string }> = {
    'mall-backend': { icon: '🍃', repo: 'git.co/mall/backend', branch: 'main', deploy: '30 分钟前 · prod', ci: '通过' },
    'mall-frontend': { icon: '⚛️', repo: 'git.co/mall/frontend', branch: 'main', deploy: '2 小时前 · staging', ci: '构建中' },
    'mall-mobile': { icon: '📱', repo: 'git.co/mall/mobile', branch: 'main', deploy: '昨天 · prod v2.1.0', ci: '通过' },
  }

  return (project.value?.services ?? []).map((service): CatalogItem => {
    const meta = serviceMeta[service.id] ?? {
      icon: '⚙️',
      repo: `git.co/${projectId}/${service.id}`,
      branch: 'main',
      deploy: service.deployMeta,
      ci: service.statusLabel,
    }

    return {
      icon: meta.icon,
      title: service.name,
      subtitle: service.techStack,
      badge: service.statusLabel,
      tone: service.statusTone,
      lines: [
        { label: 'Git 仓库', value: meta.repo, mono: true },
        { label: '主干分支', value: meta.branch },
        { label: '最后部署', value: meta.deploy },
        { label: 'CI 状态', value: meta.ci, tone: service.statusTone },
      ],
      cta: '进入服务详情 →',
      to: `/projects/${projectId}/services/${service.id}`,
    }
  })
}

// ??????? section ??????????????????????
const pageConfig = computed<ModulePageConfig>(() => {
  if (!project.value) {
    return { sections: [] }
  }

  const projectId = project.value.id

  const configs: Record<string, ModulePageConfig> = {
    // ????????
    agile: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Agile`,
          title: '研发流程',
          description: '查看当前 Sprint、Backlog、燃尽进度和 AI 生成的迭代回顾建议。',
          actions: [
            { label: '新建 Sprint 任务', variant: 'primary' },
            { label: '生成 AI 回顾' },
          ],
        },
        {
          type: 'metrics',
          items: [
            { id: 'sprint', icon: '🏃', label: '当前 Sprint', value: project.value.currentSprint, delta: project.value.sprintProgress, tone: 'primary' },
            { id: 'backlog', icon: '🗂️', label: 'Backlog', value: '18', delta: '高优先级需求 5 项', tone: 'primary' },
            { id: 'burn', icon: '🔥', label: '燃尽健康度', value: '82%', delta: '略快于计划线', tone: 'success' },
            { id: 'blocked', icon: '🚧', label: '阻塞项', value: '2', delta: '集中在跨服务联调', tone: 'warning' },
          ],
        },
        {
          type: 'kanban',
          title: 'Sprint 看板',
          columns: [
            {
              title: '待开始',
              badge: '5',
              tone: 'warning',
              items: [
                { title: '搜索结果页埋点补充', meta: '产品 / 前端联合需求', badge: 'Story', tone: 'primary' },
                { title: '风控规则白名单配置', meta: '支付网关联调', badge: 'Task', tone: 'warning' },
              ],
            },
            {
              title: '进行中',
              badge: '8',
              tone: 'primary',
              items: [
                { title: '商品搜索 ES 接入', meta: 'mall-backend · 李四', badge: '高优先级', tone: 'primary' },
                { title: '购物车并发锁优化', meta: 'mall-backend · 张三', badge: 'Blocker', tone: 'warning' },
                { title: '搜索页交互体验优化', meta: 'mall-frontend · 王五', badge: 'UI', tone: 'success' },
              ],
            },
            {
              title: '已完成',
              badge: '11',
              tone: 'success',
              items: [
                { title: '支付异常链路监控补齐', meta: '已发布到 PROD', badge: 'Done', tone: 'success' },
                { title: '订单回滚补偿脚本', meta: '已通过 AI Review', badge: 'Done', tone: 'success' },
              ],
            },
          ],
        },
      ],
    },
    // ????????
    services: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Services`,
          title: '代码服务',
          description: '管理项目下的代码服务、仓库信息、环境状态和接入方式。',
          actions: [
            { label: '+ 添加服务', variant: 'primary' },
            { label: '查看仓库接入规范' },
          ],
        },
        {
          type: 'catalog-grid',
          columns: 3,
          items: buildServiceCards(projectId),
        },
        {
          type: 'catalog-grid',
          columns: 3,
          title: '添加新服务',
          items: [
            { icon: '🗂️', title: '选择模板创建', subtitle: '从公司标准模板快速初始化服务', description: '适合新建 BFF、前端控制台、Java 服务或 Python 数据服务。' },
            { icon: '🔗', title: '关联已有仓库', subtitle: '填入 Git 地址，自动识别技术栈', description: '会自动补全主干分支、CI/CD 模板与基础监控配置。' },
            { icon: '📥', title: '导入 Git 仓库', subtitle: '从 GitHub / GitLab / 自建 Git 导入', description: '支持批量导入并自动生成 MCP Server 接入信息。' },
          ],
        },
      ],
    },
    // ?? / ??????
    knowledge: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Knowledge`,
          title: '项目知识库',
          description: '沉淀需求、原型、技术文档和全局规范，供项目成员与 Agent 协同使用。',
          actions: [
            { label: '+ 上传文档', variant: 'primary' },
            { label: '启用全局知识库' },
          ],
        },
        {
          type: 'table',
          title: '文档清单',
          table: {
            columns: ['文件名', '类型', '大小', '上传者', '更新时间', '状态'],
            rows: [
              [cell('商城需求文档 v2.3'), cell('需求', 'primary'), cell('245KB'), cell('张三'), cell('2026-03-06'), cell('已索引', 'success')],
              [cell('商城原型图 v1.5'), cell('原型', 'warning'), cell('3.2MB'), cell('产品部'), cell('2026-03-05'), cell('已索引', 'success')],
              [cell('接口文档 - 商品模块'), cell('技术', 'success'), cell('88KB'), cell('AI 生成'), cell('2026-03-04'), cell('已索引', 'success')],
              [cell('安全规范手册'), cell('全局', 'primary'), cell('56KB'), cell('全局启用'), cell('2026-02-20'), cell('共享中', 'primary')],
            ],
          },
        },
      ],
    },
    incidents: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Incident`,
          title: '项目事故',
          description: '查看项目事故详情、AI 根因分析和修复建议，支持直接在 IDE 领取处理。',
          actions: [
            { label: '新建事故', variant: 'primary' },
            { label: '拉取诊断报告' },
          ],
        },
        {
          type: 'list-grid',
          columns: 2,
          cards: [
            {
              title: '当前重点事故',
              items: [
                {
                  title: '支付服务 NullPointerException - mall-backend',
                  meta: '严重 · 处理中',
                  description: 'AI 诊断认为 checkout 接口未对 paymentMethod 做非空校验，建议在 OrderController 增加参数校验并补偿回滚。',
                  badge: '处理中',
                  tone: 'danger',
                },
                {
                  title: '前端打包体积超限',
                  meta: '提示 · 观察中',
                  description: '搜索模块引入的图表依赖导致 bundle 增大，建议拆分懒加载。',
                  badge: 'AI 分析中',
                  tone: 'primary',
                },
              ],
            },
            {
              title: 'AI 诊断',
              items: [
                { title: '根因定位', meta: 'OrderController:89 参数校验缺失', badge: '已完成', tone: 'success' },
                { title: '修复建议', meta: '增加空值校验 + 失败补偿事务', badge: '待确认', tone: 'warning' },
                { title: 'IDE 接力', meta: '可直接创建修复任务并在 IDE 中一键领取', badge: '可执行', tone: 'primary' },
              ],
            },
          ],
        },
      ],
    },
    // ?? / Skill / ??????
    members: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Members`,
          title: '成员权限',
          description: '管理项目成员、角色、Token 配额以及知识库和 Skill 的使用权限。',
          actions: [
            { label: '邀请成员', variant: 'primary' },
            { label: '批量调整权限' },
          ],
        },
        {
          type: 'table',
          title: '成员列表',
          table: {
            columns: ['成员', '角色', 'Token 配额', '知识库权限', 'Skill 权限', '状态'],
            rows: [
              [cell('张三'), cell('项目负责人'), cell('120K / 月'), cell('读写'), cell('全部'), cell('在线', 'success')],
              [cell('李四'), cell('后端开发'), cell('80K / 月'), cell('读写'), cell('研发类'), cell('在线', 'success')],
              [cell('王五'), cell('前端开发'), cell('60K / 月'), cell('读取'), cell('研发类'), cell('在线', 'success')],
              [cell('赵六'), cell('测试'), cell('40K / 月'), cell('读取'), cell('测试类'), cell('离线', 'muted')],
            ],
          },
        },
      ],
    },
    skillconfig: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Skill Config`,
          title: 'Skill 配置',
          description: '按项目启用或禁用 Skill，并配置其适用范围和审批要求。',
          actions: [
            { label: '保存 Skill 配置', variant: 'primary' },
            { label: '同步平台默认值' },
          ],
        },
        {
          type: 'table',
          title: 'Skill 开关',
          table: {
            columns: ['Skill', '用途', '当前状态', '审批要求', '最近变更'],
            rows: [
              [cell('代码审查 Skill'), cell('PR 审查与行内评论'), cell('启用', 'success'), cell('无需审批'), cell('03-10')],
              [cell('事故排障 Skill'), cell('告警诊断与修复建议'), cell('启用', 'success'), cell('高风险修复需审批'), cell('03-09')],
              [cell('需求拆分 Skill'), cell('PRD 拆分 Story / Task'), cell('启用', 'success'), cell('无需审批'), cell('03-08')],
              [cell('自动部署 Skill'), cell('从 IDE 触发部署'), cell('禁用', 'warning'), cell('生产必须审批'), cell('03-06')],
            ],
          },
        },
      ],
    },
    psettings: {
      sections: [
        {
          type: 'hero',
          eyebrow: `${project.value.name} / Settings`,
          title: '项目设置',
          description: '维护项目基础信息、Sprint 周期、Token 配额、模板和原子能力关联。',
          actions: [
            { label: '保存项目设置', variant: 'primary' },
            { label: '查看变更记录' },
          ],
        },
        {
          type: 'split',
          columns: 2,
          items: [
            {
              title: '基础信息',
              lines: [
                { label: '项目名称', value: project.value.name },
                { label: '项目类型', value: project.value.typeLabel },
                { label: '当前 Sprint', value: project.value.currentSprint },
                { label: '项目描述', value: project.value.description },
              ],
            },
            {
              title: '研发配置',
              lines: [
                { label: '分支策略', value: 'Git Flow（推荐）' },
                { label: 'CI/CD 模板', value: '标准 Java / Web 双通道' },
                { label: 'Token 配额', value: `${project.value.tokenLabel} / 月` },
                { label: '默认评审模型', value: 'claude-sonnet-4-6', mono: true },
              ],
            },
            {
              title: '已关联原子能力',
              list: [
                { title: '统一认证 SSO', meta: '已在用户登录与后台管理接入', badge: '启用', tone: 'success' },
                { title: '短信服务', meta: '验证码与消息通知均已开通', badge: '启用', tone: 'success' },
                { title: 'OSS 对象存储', meta: '商品图片与订单附件统一托管', badge: '启用', tone: 'success' },
              ],
            },
            {
              title: '治理提醒',
              notes: [
                { label: '建议', content: '将支付相关服务加入高风险审批清单，并提高事故演练频率。', tone: 'warning' },
                { label: '说明', content: '项目设置会同步影响 MCP Server 暴露的工具集合与权限边界。', tone: 'primary' },
              ],
            },
          ],
        },
      ],
    },
  }

  return configs[section.value] ?? {
    sections: [
      {
        type: 'hero',
        eyebrow: `${project.value.name} / Project Space`,
        title: '模块建设中',
        description: '该项目模块的路由和上下文已接入，后续可继续补充更细粒度的数据交互。',
      },
    ],
  }
})
</script>

<template>
  <NotFoundProjectState v-if="!project" />

  <section v-else data-testid="project-module-page">
    <ModuleContent :sections="pageConfig.sections" />
  </section>
</template>

