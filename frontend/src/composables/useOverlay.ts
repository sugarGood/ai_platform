import { reactive } from 'vue'

export type OverlayKind = 'none' | 'notifications' | 'new-project' | 'action'

export interface OverlayShortcut {
  label: string
  to?: string
}

interface NewProjectDraft {
  name: string
  type: string
  description: string
  repo: string
  branch: string
}

interface OverlayState {
  open: boolean
  kind: OverlayKind
  title: string
  description: string
  items: string[]
  shortcuts: OverlayShortcut[]
  draft: NewProjectDraft
}

const defaultDraft = (): NewProjectDraft => ({
  name: '',
  type: '对外产品',
  description: '',
  repo: '',
  branch: 'main',
})

const state = reactive<OverlayState>({
  open: false,
  kind: 'none',
  title: '',
  description: '',
  items: [],
  shortcuts: [],
  draft: defaultDraft(),
})

// ???????????????????????????
function resetDraft() {
  state.draft = defaultDraft()
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
}

// ???????????????????????????????
export function openNewProjectModal() {
  state.open = true
  state.kind = 'new-project'
  state.title = '新建项目空间'
  state.description = '补充基础信息后即可生成项目草稿，后续再继续完善服务与知识库配置。'
  state.items = []
  state.shortcuts = []
  resetDraft()
}

// ????????????????????????????
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
}

// ?????????????????????????????????
export function submitNewProjectDraft() {
  const name = state.draft.name.trim() || '未命名项目'

  openActionDialog({
    title: `已创建项目草稿：${name}`,
    description: '当前为前端原型交互，项目草稿已在界面层完成收集，下一步可继续接后端创建接口。',
    items: [
      `项目类型：${state.draft.type}`,
      `主干分支：${state.draft.branch || 'main'}`,
      state.draft.repo ? `仓库地址：${state.draft.repo}` : '暂未填写仓库地址，可稍后补充。',
    ],
    shortcuts: [{ label: '返回项目列表', to: '/projects' }],
  })
}

// ??????????????????????????????????
export function triggerModuleAction(actionLabel: string, contextTitle?: string) {
  const title = contextTitle ? `${contextTitle} · ${actionLabel}` : actionLabel

  const descriptionMap: Record<string, string> = {
    '新建工作流': '已打开工作流创建入口，可继续补充触发器、LLM 节点、工具调用和审批链。',
    '导入模板': '可从模板库选择预设流程，快速初始化当前页面的标准能力。',
    '导出周报': '已触发周报导出动作，后续可接入真实下载接口。',
    '生成评估报告': '已触发评估报告生成入口，可继续接入异步任务与文件下载。',
    '保存配置': '已记录当前配置保存动作，后续可接入后端持久化。',
    '保存项目设置': '已记录项目设置保存动作，后续可接入后端持久化。',
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
