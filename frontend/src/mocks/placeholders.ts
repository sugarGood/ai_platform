import type { PlaceholderContent } from '../types/navigation'

export const globalPlaceholderContent: Record<string, PlaceholderContent> = {
  efficiency: {
    title: '效能看板',
    description: '用于展示 AI 代码贡献率、变更失败率、恢复时长等全局研发效能指标。',
    highlights: ['DORA 指标趋势', 'AI 贡献率分析', '跨项目维度对比'],
  },
  cicd: {
    title: 'CI / CD',
    description: '集中管理跨项目流水线状态、构建失败分析与部署节奏。',
    highlights: ['流水线阶段状态', '失败原因归因', '重试与部署入口'],
  },
  default: {
    title: '模块建设中',
    description: '该模块的高保真页面将在后续迭代中接入，目前先保留导航与上下文结构。',
    highlights: ['信息架构已就位', '路由结构已预留', '后续可直接接入真实数据'],
  },
}

export const projectPlaceholderContent: Record<string, PlaceholderContent> = {
  agile: {
    title: '研发流程',
    description: '这里将承载 Sprint 看板、Backlog、燃尽图与 AI 回顾能力。',
    highlights: ['Sprint 看板', '任务状态流转', 'AI 迭代回顾'],
  },
  services: {
    title: '代码服务',
    description: '这里将承载项目下服务列表、健康状态与仓库配置。',
    highlights: ['服务健康卡片', 'Git 仓库配置', '环境部署摘要'],
  },
  default: {
    title: '模块建设中',
    description: '该项目模块已完成导航预留，后续会在当前项目上下文内逐页补齐。',
    highlights: ['保持项目上下文', '保留导航与入口', '支持后续无缝扩展'],
  },
}
