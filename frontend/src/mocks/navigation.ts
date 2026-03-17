import type { NavGroup } from '../types/navigation'

export const globalNavGroups: NavGroup[] = [
  {
    label: '概览',
    items: [
      { key: 'dashboard', label: '工作台', icon: '📊', to: '/dashboard' },
      { key: 'efficiency', label: '效能看板', icon: '📈', to: '/placeholder/efficiency' },
    ],
  },
  {
    label: '开发',
    items: [
      { key: 'projects', label: '项目空间', icon: '📁', to: '/projects' },
      { key: 'cicd', label: 'CI / CD', icon: '🔧', to: '/placeholder/cicd' },
      { key: 'envs', label: '环境管理', icon: '🌍', to: '/placeholder/envs' },
      { key: 'incidents', label: '事故中心', icon: '🚨', to: '/placeholder/incidents', badge: '3' },
    ],
  },
  {
    label: 'AI 能力',
    items: [
      { key: 'workflows', label: 'Agent 工作流', icon: '🔀', to: '/placeholder/workflows' },
      { key: 'functions', label: 'Function 管理', icon: '🔩', to: '/placeholder/functions' },
      { key: 'ai-monitor', label: '执行监控', icon: '🔭', to: '/placeholder/ai-monitor' },
      { key: 'evals', label: 'AI 评估', icon: '📐', to: '/placeholder/evals' },
    ],
  },
  {
    label: '资源',
    items: [
      { key: 'atomic', label: '原子能力库', icon: '⚛️', to: '/placeholder/atomic' },
      { key: 'knowledge', label: '知识库（全局）', icon: '📚', to: '/placeholder/knowledge' },
      { key: 'skills', label: 'Skill 库', icon: '⚡', to: '/placeholder/skills' },
      { key: 'templates', label: '模板库', icon: '🗂️', to: '/placeholder/templates' },
    ],
  },
  {
    label: '管理',
    items: [
      { key: 'keys', label: 'Key 管理', icon: '🔑', to: '/placeholder/keys' },
      { key: 'audit', label: '审计安全', icon: '🛡️', to: '/placeholder/audit' },
      { key: 'settings', label: '设置', icon: '⚙️', to: '/placeholder/settings' },
    ],
  },
]

export const projectNavGroups: NavGroup[] = [
  {
    label: '产品',
    items: [
      { key: 'overview', label: '概览', icon: '📊', to: 'overview' },
      { key: 'agile', label: '研发流程', icon: '🏃', to: 'agile' },
      { key: 'knowledge', label: '知识库', icon: '📚', to: 'knowledge' },
      { key: 'incidents', label: '事故', icon: '🚨', to: 'incidents', badge: '1' },
    ],
  },
  {
    label: '工程',
    items: [{ key: 'services', label: '代码服务', icon: '⚙️', to: 'services' }],
  },
  {
    label: '配置',
    items: [
      { key: 'members', label: '成员权限', icon: '👥', to: 'members' },
      { key: 'skillconfig', label: 'Skill 配置', icon: '⚡', to: 'skillconfig' },
      { key: 'psettings', label: '项目设置', icon: '⚙️', to: 'psettings' },
    ],
  },
]
