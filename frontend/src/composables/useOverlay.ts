import { reactive } from 'vue'

import router from '../router'
import type { BackendBranchStrategy, BackendProjectType } from '../types/project'
import { branchStrategyLabelMap, createProject, projectTypeLabelMap } from './useProjects'

export type OverlayKind = 'none' | 'notifications' | 'new-project' | 'action'

export interface OverlayShortcut {
  label: string
  to?: string
}

interface NewProjectDraft {
  name: string
  code: string
  type: BackendProjectType
  branchStrategy: BackendBranchStrategy
}

interface OverlayState {
  open: boolean
  kind: OverlayKind
  title: string
  description: string
  items: string[]
  shortcuts: OverlayShortcut[]
  draft: NewProjectDraft
  submitError: string
  submitting: boolean
}

const defaultDraft = (): NewProjectDraft => ({
  name: '',
  code: '',
  type: 'PRODUCT',
  branchStrategy: 'GIT_FLOW',
})

const state = reactive<OverlayState>({
  open: false,
  kind: 'none',
  title: '',
  description: '',
  items: [],
  shortcuts: [],
  draft: defaultDraft(),
  submitError: '',
  submitting: false,
})

function resetDraft() {
  state.draft = defaultDraft()
  state.submitError = ''
  state.submitting = false
}

export function closeOverlay() {
  state.open = false
  state.kind = 'none'
  state.title = ''
  state.description = ''
  state.items = []
  state.shortcuts = []
  resetDraft()
}

export function resetOverlayState() {
  closeOverlay()
}

export function openNotifications() {
  state.open = true
  state.kind = 'notifications'
  state.title = '通知中心'
  state.description = '集中查看审批提醒、事故进展和 Agent 执行状态。'
  state.items = [
    '支付服务空指针异常已完成 AI 根因分析，等待人工确认修复方案。',
    'mall-backend PR#51 的代码 Review Agent 正在发布 3 条评论。',
    '支付网关生产部署仍待双人审批，已等待 23 分钟。',
  ]
  state.shortcuts = []
  state.submitError = ''
}

export function openNewProjectModal() {
  state.open = true
  state.kind = 'new-project'
  state.title = '新建项目空间'
  state.description = '字段已对齐后端 `POST /api/projects`，创建成功后会立即刷新项目空间列表。'
  state.items = []
  state.shortcuts = []
  resetDraft()
}

export function openActionDialog(options: {
  title: string
  description: string
  items?: string[]
  shortcuts?: OverlayShortcut[]
}) {
  state.open = true
  state.kind = 'action'
  state.title = options.title
  state.description = options.description
  state.items = options.items ?? []
  state.shortcuts = options.shortcuts ?? []
  state.submitError = ''
  state.submitting = false
}

export async function submitNewProjectDraft() {
  const name = state.draft.name.trim()
  const code = state.draft.code.trim().toUpperCase()

  if (!name || !code) {
    state.submitError = '请先填写项目名称和项目编码。'
    return
  }

  state.submitError = ''
  state.submitting = true

  try {
    const createdProject = await createProject({
      name,
      code,
      projectType: state.draft.type,
      branchStrategy: state.draft.branchStrategy,
    })

    const overviewPath = `/projects/${createdProject.id}/overview`
    const items = [
      `项目编码：${code}`,
      `项目类型：${projectTypeLabelMap[state.draft.type]}`,
      `分支策略：${branchStrategyLabelMap[state.draft.branchStrategy]}`,
      '项目列表已和后端重新同步。',
    ]

    openActionDialog({
      title: `项目已创建：${createdProject.name}`,
      description: '后端创建接口调用成功，项目空间列表已经刷新。',
      items,
      shortcuts: [
        { label: '进入项目概览', to: overviewPath },
        { label: '返回项目列表', to: '/projects' },
      ],
    })

    void router.replace('/projects')
  } catch (error) {
    state.submitError = error instanceof Error ? error.message : '项目创建失败，请稍后重试。'
  } finally {
    state.submitting = false
  }
}

export function triggerModuleAction(actionLabel: string, contextTitle?: string) {
  const title = contextTitle ? `${contextTitle} · ${actionLabel}` : actionLabel

  const descriptionMap: Record<string, string> = {
    新建工作流: '已打开工作流创建入口，可继续补充触发器、LLM 节点、工具调用和审批链。',
    导入模板: '可从模板库选择预设流程，快速初始化当前页面的标准能力。',
    导出周报: '已触发周报导出动作，后续可接入真实下载接口。',
    生成评估报告: '已触发评估报告生成入口，可继续接入异步任务与文件下载。',
    保存配置: '已记录当前配置保存动作，后续可接入后端持久化。',
    保存项目设置: '已记录项目设置保存动作，后续可接入后端持久化。',
    '分配新 Key': 'Key 分配功能已准备就绪，可选择成员并配置对应的模型权限与配额限制。',
    导出使用报告: '正在生成 Key 使用情况报告，包含成员活跃度、配额使用率和异常告警分析。',
    生成成员使用指南: '正在根据项目配置生成个性化的 Key 使用指南，包含权限说明和最佳实践。',
  }

  openActionDialog({
    title,
    description:
      descriptionMap[actionLabel] ?? '该按钮已接入交互逻辑，当前会打开对应操作入口或说明弹层。',
    items: ['按钮事件已绑定。', '当前为原型阶段，后续可继续接入真实接口或任务流。'],
  })
}

export function useOverlay() {
  return {
    overlayState: state,
    closeOverlay,
    openActionDialog,
    openNewProjectModal,
    openNotifications,
    resetOverlayState,
    submitNewProjectDraft,
    triggerModuleAction,
  }
}
