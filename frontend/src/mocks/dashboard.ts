import type {
  ActivityEvent,
  DashboardMetric,
  DepartmentUsage,
  Incident,
  TokenTrendPoint,
} from '../types/dashboard'

export const dashboardMetrics: DashboardMetric[] = [
  {
    id: 'token-usage',
    icon: '🤖',
    label: '本月 Token 消耗',
    value: '2.4M',
    delta: '↑ 12% 较上月',
    tone: 'primary',
  },
  {
    id: 'active-employees',
    icon: '👥',
    label: '活跃员工',
    value: '38',
    delta: '↑ 5 人新增',
  },
  {
    id: 'active-projects',
    icon: '📁',
    label: '进行中项目',
    value: '12',
    delta: '共 18 个项目',
  },
  {
    id: 'pending-incidents',
    icon: '🚨',
    label: '待处理事故',
    value: '3',
    delta: '↑ 较昨日 +2',
    tone: 'danger',
  },
]

export const tokenTrend: TokenTrendPoint[] = [
  { label: '03/01', value: 45 },
  { label: '03/05', value: 62 },
  { label: '03/09', value: 51 },
  { label: '03/12', value: 78 },
  { label: '03/16', value: 69 },
  { label: '03/20', value: 88 },
  { label: '03/24', value: 73 },
  { label: '03/28', value: 95 },
]

export const departmentUsage: DepartmentUsage[] = [
  { id: 'product', name: '产品团队', usage: '680K', progress: 85 },
  { id: 'engineering', name: '研发团队', usage: '820K', progress: 100 },
  { id: 'data', name: '数据团队', usage: '430K', progress: 64 },
  { id: 'operations', name: '运营团队', usage: '210K', progress: 22 },
]

export const dashboardIncidents: Incident[] = [
  {
    id: 'inc-1',
    title: '支付服务 NullPointerException',
    meta: 'order-service · 10分钟前 · AI 已完成诊断',
    severity: 'critical',
    severityLabel: '严重',
  },
  {
    id: 'inc-2',
    title: '用户中心接口 P99 延迟超阈值',
    meta: 'user-service · 1小时前 · 待分配',
    severity: 'warning',
    severityLabel: '警告',
  },
  {
    id: 'inc-3',
    title: '前端打包体积超出限制',
    meta: 'mall-frontend · 3小时前 · AI 正在分析',
    severity: 'info',
    severityLabel: '提示',
  },
]

export const dashboardActivities: ActivityEvent[] = [
  {
    id: 'act-1',
    time: '10分钟前',
    content: '李四在商城系统中更新了需求文档',
  },
  {
    id: 'act-2',
    time: '1小时前',
    content: '王五通过 MCP 接入了支付项目知识库',
  },
  {
    id: 'act-3',
    time: '2小时前',
    content: 'AI 为用户中心项目生成了接口文档',
  },
  {
    id: 'act-4',
    time: '昨天',
    content: '张三新建项目数据看板',
  },
]
