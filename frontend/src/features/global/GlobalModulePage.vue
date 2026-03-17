<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import ModuleContent from '../../components/ui/ModuleContent.vue'
import type { ModulePageConfig, TableCell } from '../../types/module-page'

const route = useRoute()

// ???????????????????????????
function cell(text: string, tone?: TableCell['tone'], mono = false): TableCell {
  return { text, tone, mono }
}

// ????????????????? pageKey ??????????
const pageConfigs: Record<string, ModulePageConfig> = {
  // ?? / ????????
  efficiency: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Efficiency',
        title: '研发效能看板',
        description: '聚合跨项目的交付速度、变更质量与 AI 贡献情况，帮助技术管理者快速识别效率瓶颈。',
        actions: [
          { label: '导出周报', variant: 'primary' },
          { label: '查看趋势口径' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'lead-time', icon: '⚡', label: '平均 Lead Time', value: '1.8 天', delta: '较上周 -0.4 天', tone: 'success' },
          { id: 'deploy', icon: '🚀', label: '部署频率', value: '42 次/周', delta: '核心项目维持高频发布', tone: 'primary' },
          { id: 'change-fail', icon: '🧯', label: '变更失败率', value: '6.2%', delta: '较上周下降 1.1%', tone: 'success' },
          { id: 'ai-ratio', icon: '🤖', label: 'AI 代码贡献率', value: '34%', delta: '商城系统最高 41%', tone: 'primary' },
        ],
      },
      {
        type: 'progress',
        title: 'DORA 指标拆解',
        items: [
          { label: '部署频率目标达成', value: '84%', progress: 84, tone: 'primary', hint: '支付网关和商城系统拉高整体频率' },
          { label: '平均恢复时长目标达成', value: '92%', progress: 92, tone: 'success', hint: 'AI 辅助诊断将 MTTR 压缩到 28 分钟' },
          { label: '变更失败率控制', value: '76%', progress: 76, tone: 'warning', hint: '需重点关注用户中心接口变更波动' },
        ],
        note: {
          label: 'AI 分析',
          tone: 'primary',
          content: '当前瓶颈主要在跨服务联调阶段，建议引入接口变更提醒 Agent 作为默认守护流程。',
        },
      },
      {
        type: 'table',
        title: '项目效能对比',
        badge: '本周',
        table: {
          columns: ['项目', '交付速度', '缺陷回滚', 'AI 贡献率', '点评'],
          rows: [
            [cell('商城系统'), cell('高'), cell('低', 'success'), cell('41%', 'primary'), cell('搜索改造推进顺畅')],
            [cell('用户中心'), cell('中'), cell('中', 'warning'), cell('29%', 'primary'), cell('权限模型重构占用评审时间')],
            [cell('数据看板'), cell('高'), cell('低', 'success'), cell('33%', 'primary'), cell('发布前验证稳定')],
            [cell('支付网关'), cell('中'), cell('中高', 'warning'), cell('22%', 'primary'), cell('审批链较长，阻塞 STAGING')],
          ],
        },
      },
    ],
  },
  cicd: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Delivery',
        title: 'CI / CD 总览',
        description: '统一查看跨项目流水线状态、失败归因和部署节奏，快速处理构建阻塞。',
        actions: [
          { label: '重试失败流水线', variant: 'primary' },
          { label: '查看部署窗口' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'pipelines', icon: '🔧', label: '今日流水线', value: '128', delta: '成功率 93%', tone: 'primary' },
          { id: 'blocked', icon: '⛔', label: '阻塞发布', value: '4', delta: '2 个等待审批，2 个构建失败', tone: 'warning' },
          { id: 'deploy', icon: '🌍', label: '生产部署', value: '11', delta: '商城系统 3 次，支付网关 2 次', tone: 'success' },
          { id: 'scan', icon: '🛡️', label: '安全扫描告警', value: '6', delta: '高危 1 项待处理', tone: 'danger' },
        ],
      },
      {
        type: 'table',
        title: '最新流水线记录',
        table: {
          columns: ['项目 / 服务', '分支', '当前阶段', '耗时', '状态', '时间'],
          rows: [
            [cell('商城系统 / mall-frontend'), cell('feature/search', 'default', true), cell('单测阶段'), cell('2m 10s'), cell('运行中', 'primary'), cell('5 分钟前')],
            [cell('商城系统 / mall-backend'), cell('main', 'default', true), cell('部署完成'), cell('5m 44s'), cell('成功', 'success'), cell('30 分钟前')],
            [cell('用户中心 / user-api'), cell('feature/rbac', 'default', true), cell('代码扫描'), cell('4m 32s'), cell('等待审批', 'warning'), cell('48 分钟前')],
            [cell('支付网关 / payment-core'), cell('release/2.1', 'default', true), cell('构建失败'), cell('1m 53s'), cell('失败', 'danger'), cell('1 小时前')],
          ],
        },
      },
      {
        type: 'list-grid',
        columns: 2,
        cards: [
          {
            title: '失败归因',
            items: [
              { title: 'payment-core 构建失败', meta: 'JDK 版本与镜像不一致', badge: '高优先级', tone: 'danger' },
              { title: 'user-api 扫描等待审批', meta: '命中新增外网依赖白名单流程', badge: '审批中', tone: 'warning' },
              { title: 'mall-frontend 单测波动', meta: '搜索模块快照用例偶发失败', badge: '观察中', tone: 'primary' },
            ],
          },
          {
            title: '发布节奏',
            items: [
              { title: '商城系统', meta: '今日已发 3 次，最近一次 09:20 → PROD', badge: '高频', tone: 'success' },
              { title: '用户中心', meta: '本周计划 2 次变更，当前处于 STAGING', badge: '计划内', tone: 'primary' },
              { title: '支付网关', meta: '需双人审批后方可进入生产', badge: '受控', tone: 'warning' },
            ],
          },
        ],
      },
    ],
  },
  envs: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Environment',
        title: '环境管理',
        description: '集中查看 DEV / STAGING / PROD 的版本、健康状态和部署策略。',
        actions: [
          { label: '发起部署', variant: 'primary' },
          { label: '查看环境日志' },
        ],
      },
      {
        type: 'catalog-grid',
        columns: 3,
        items: [
          {
            icon: '🧪',
            title: 'DEV',
            badge: '健康',
            tone: 'success',
            lines: [
              { label: '当前版本', value: 'feature/search' },
              { label: '部署策略', value: '每次 Push 自动部署' },
              { label: '最近部署', value: '09:18 · mall-frontend' },
            ],
            cta: '查看构建日志',
          },
          {
            icon: '🛰️',
            title: 'STAGING',
            badge: '需审批',
            tone: 'warning',
            lines: [
              { label: '当前版本', value: 'main #7b9c4d', mono: true },
              { label: '部署策略', value: '手动触发 · Tech Lead 审批' },
              { label: '容量', value: '6 Pods' },
            ],
            cta: '查看审批链路',
          },
          {
            icon: '🏭',
            title: 'PROD',
            badge: '稳定',
            tone: 'success',
            lines: [
              { label: '当前版本', value: 'v2.3.1', mono: true },
              { label: '灰度策略', value: '5% → 25% → 全量' },
              { label: '健康状态', value: '全部实例在线', tone: 'success' },
            ],
            cta: '查看变更窗口',
          },
        ],
      },
      {
        type: 'table',
        title: '最近环境变更',
        table: {
          columns: ['环境', '服务', '变更说明', '执行人', '结果', '时间'],
          rows: [
            [cell('PROD'), cell('mall-backend'), cell('商品搜索 ES 接入发布'), cell('李四'), cell('成功', 'success'), cell('09:20')],
            [cell('STAGING'), cell('payment-core'), cell('风控规则灰度验证'), cell('赵六'), cell('审批中', 'warning'), cell('08:42')],
            [cell('DEV'), cell('user-console'), cell('权限页 UI 调整'), cell('王五'), cell('成功', 'success'), cell('08:15')],
          ],
        },
      },
    ],
  },
  incidents: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Incident Center',
        title: '事故中心',
        description: '统一承接项目级和平台级告警，展示 AI 诊断、修复建议与跟进状态。',
        actions: [
          { label: '新建事故', variant: 'primary' },
          { label: '查看值班安排' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'critical', icon: '🔴', label: '严重事故', value: '1', delta: '支付链路空指针异常', tone: 'danger' },
          { id: 'warning', icon: '🟡', label: '警告告警', value: '5', delta: 'P99、构建和流量波动', tone: 'warning' },
          { id: 'resolved', icon: '✅', label: '今日已恢复', value: '7', delta: '平均耗时 26 分钟', tone: 'success' },
          { id: 'ai', icon: '🤖', label: 'AI 诊断覆盖率', value: '89%', delta: '4 起事故已自动给出修复建议', tone: 'primary' },
        ],
      },
      {
        type: 'list-grid',
        columns: 2,
        cards: [
          {
            title: '重点事故',
            items: [
              {
                title: '支付服务 NullPointerException',
                meta: 'mall-backend · checkout 接口 · 10 分钟前',
                description: 'AI 已定位到 paymentMethod 为空导致的空指针，建议补充参数校验并回滚异常订单。',
                badge: '处理中',
                tone: 'danger',
              },
              {
                title: '用户中心接口 P99 超阈值',
                meta: 'user-service · 1 小时前',
                description: '疑似缓存失效后回源压力上升，建议优先排查热点 Key 淘汰策略。',
                badge: '待分配',
                tone: 'warning',
              },
            ],
          },
          {
            title: 'AI 诊断队列',
            items: [
              { title: '订单支付异常', meta: '根因分析已完成，等待人工确认修复方案', badge: '已分析', tone: 'success', progress: 100 },
              { title: '前端包体积超限', meta: '正在追踪大体积依赖', badge: '分析中', tone: 'primary', progress: 62 },
              { title: '支付风控延迟抖动', meta: '等待拉取近 24h trace 数据', badge: '排队中', tone: 'warning', progress: 28 },
            ],
          },
        ],
      },
    ],
  },
  // AI ??????
  workflows: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Agent Workflow',
        title: 'Agent 工作流',
        description: '用可视化方式配置触发器、LLM 节点、Tool 调用和人工审批节点，编排企业 AI 流程。',
        actions: [
          { label: '新建工作流', variant: 'primary' },
          { label: '导入模板' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'published', icon: '🧩', label: '已发布工作流', value: '12', delta: '其中 5 个面向研发流程', tone: 'primary' },
          { id: 'running', icon: '🏃', label: '运行中实例', value: '7', delta: 'Code Review Agent 占比最高', tone: 'success' },
          { id: 'success', icon: '📈', label: '7 日成功率', value: '94%', delta: '较上周提升 2%', tone: 'success' },
          { id: 'token', icon: '🪙', label: '7 日 Token', value: '182K', delta: 'Review 场景消耗最多', tone: 'primary' },
        ],
      },
      {
        type: 'catalog-grid',
        columns: 3,
        items: [
          {
            icon: '🔍',
            title: '代码 Review Agent',
            subtitle: 'PR 触发 → Diff 分析 → LLM 审查 → 发布评论',
            badge: '主力流程',
            tone: 'success',
            description: '支持安全、规范、性能三类分支审查，可自动调用知识库和规则模板。',
          },
          {
            icon: '🚨',
            title: 'Bug 诊断修复 Agent',
            subtitle: '事故触发 → 拉取日志 → 根因分析 → 生成人工确认修复方案',
            badge: '值守流程',
            tone: 'warning',
            description: '已接入支付和用户中心告警，可在 IDE 内一键领取并修复。',
          },
          {
            icon: '🧠',
            title: '需求拆分 Agent',
            subtitle: 'PRD 上传 → 拆分 Epic / Story / Task → 估算 SP',
            badge: '产品协同',
            tone: 'primary',
            description: '支持多轮 refinement，并输出 Sprint backlog 草案。',
          },
        ],
      },
      {
        type: 'list-grid',
        columns: 2,
        cards: [
          {
            title: '运行中实例',
            items: [
              { title: '代码 Review Agent #EX-1042', meta: 'mall-backend PR#51 · 当前：发布评论', badge: '75%', tone: 'primary', progress: 75 },
              { title: 'Bug 诊断修复 Agent #EX-1041', meta: '支付服务 NPE · 当前：等待人工审批', badge: '60%', tone: 'warning', progress: 60 },
              { title: 'AI 接入原子能力 Agent #EX-1040', meta: '商城系统 · 短信接入 · 当前：生成代码', badge: '40%', tone: 'primary', progress: 40 },
            ],
          },
          {
            title: '执行追踪快照',
            items: [
              { title: '触发器：PR#51 创建事件', meta: '+0s · 输入 diff 2,340 行代码变更', badge: '完成', tone: 'success' },
              { title: 'LLM 节点：理解变更意图', meta: '+2s · claude-sonnet-4-6 · 1,240 tokens', badge: '完成', tone: 'success' },
              { title: 'Tool 调用：post_review_comment', meta: '+17s · 正在发布 3 条行内评论', badge: '运行中', tone: 'primary' },
            ],
          },
        ],
      },
    ],
  },
  functions: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Tools Registry',
        title: 'Function 管理',
        description: '管理 Agent 可调用的函数 / 工具定义、参数 Schema 和权限范围。',
        actions: [
          { label: '注册新函数', variant: 'primary' },
          { label: '查看调用日志' },
        ],
      },
      {
        type: 'table',
        title: '函数清单',
        table: {
          columns: ['函数名', '用途', '权限域', 'Schema 状态', '最近调用'],
          rows: [
            [cell('search_codebase', 'default', true), cell('搜索仓库代码与引用'), cell('项目级'), cell('已校验', 'success'), cell('2 分钟前')],
            [cell('report_bug', 'default', true), cell('创建事故任务并绑定项目'), cell('平台级'), cell('已校验', 'success'), cell('8 分钟前')],
            [cell('trigger_deploy', 'default', true), cell('触发环境部署流程'), cell('服务级'), cell('待审批', 'warning'), cell('15 分钟前')],
            [cell('get_atomic_capability', 'default', true), cell('读取原子能力文档和示例'), cell('平台级'), cell('已校验', 'success'), cell('30 分钟前')],
          ],
        },
      },
      {
        type: 'split',
        columns: 2,
        items: [
          {
            title: '参数 Schema 示例',
            code: '{\n  "name": "trigger_deploy",\n  "params": {\n    "service": "mall-backend",\n    "environment": "prod",\n    "strategy": "canary"\n  }\n}',
          },
          {
            title: '治理规则',
            notes: [
              { label: '权限', content: '高风险函数必须绑定审批策略与审计日志。', tone: 'warning' },
              { label: '演进', content: '建议对外部 API 类函数补充重试与幂等说明。', tone: 'primary' },
            ],
          },
        ],
      },
    ],
  },
  'ai-monitor': {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Execution Monitor',
        title: '执行监控',
        description: '查看 Agent 实例运行状态、步骤追踪、Token 消耗和异常回放。',
        actions: [
          { label: '筛选异常实例', variant: 'primary' },
          { label: '导出执行日志' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'run', icon: '🛰️', label: '今日执行', value: '142', delta: '成功 131，失败 4，等待 7', tone: 'primary' },
          { id: 'active', icon: '🔄', label: '当前运行中', value: '7', delta: 'Code Review 与 Bug 修复占主导', tone: 'success' },
          { id: 'latency', icon: '⏱️', label: '平均耗时', value: '28s', delta: 'PR 审查平均 21s', tone: 'primary' },
          { id: 'token', icon: '🪙', label: '今日 Token', value: '318K', delta: '较昨日 +12%', tone: 'warning' },
        ],
      },
      {
        type: 'list-grid',
        columns: 2,
        cards: [
          {
            title: '运行中实例',
            items: [
              { title: '代码 Review Agent', meta: 'mall-backend PR#51 · 当前：发布评论 · 已耗时 18s', badge: '75%', tone: 'primary', progress: 75 },
              { title: 'Bug 诊断修复 Agent', meta: '支付服务 NPE · 当前：等待人工审批 · 已等待 23 分钟', badge: '60%', tone: 'warning', progress: 60 },
              { title: '需求拆分 Agent', meta: '数据看板 PRD v2.0 · 当前：并行拆分 Story', badge: '55%', tone: 'primary', progress: 55 },
            ],
          },
          {
            title: '执行历史记录',
            items: [
              { title: '代码 Review Agent #EX-1038', meta: '用户中心 PR#44 · 6/6 步 · 4,120 tokens', badge: '成功', tone: 'success' },
              { title: '需求拆分 Agent #EX-1037', meta: '数据看板 PRD v2.0 · 7/7 步 · 8,900 tokens', badge: '成功', tone: 'success' },
              { title: 'AI 接入原子能力 #EX-1036', meta: '支付网关 · OSS 接入 · 3/6 步', badge: '失败', tone: 'danger' },
            ],
          },
        ],
      },
    ],
  },
  evals: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Evaluation Center',
        title: 'AI 评估中心',
        description: '衡量各类 Agent 的准确率、误报率、成本表现和趋势变化，为模型路由提供依据。',
        actions: [
          { label: '生成评估报告', variant: 'primary' },
          { label: '切换评测集' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'review', icon: '🧪', label: 'Code Review 准确率', value: '91', delta: 'A 级 · 较上月 +3%', tone: 'success' },
          { id: 'bug', icon: '🩺', label: 'Bug 诊断准确率', value: '87', delta: 'A 级 · 较上月 +5%', tone: 'success' },
          { id: 'req', icon: '🗂️', label: '需求拆分质量', value: '76', delta: 'B 级 · 基本持平', tone: 'primary' },
          { id: 'predict', icon: '📉', label: 'Sprint 预测准确率', value: '68', delta: 'C 级 · 较上月 -4%', tone: 'warning' },
        ],
      },
      {
        type: 'progress',
        title: '代码 Review 质量详情',
        badge: 'A 级 · 91 分',
        items: [
          { label: '安全漏洞识别率', value: '94%', progress: 94, tone: 'success' },
          { label: '代码规范违反识别率', value: '96%', progress: 96, tone: 'success' },
          { label: '性能问题识别率', value: '82%', progress: 82, tone: 'primary' },
          { label: '误报率（人工驳回）', value: '8%', progress: 8, tone: 'warning' },
        ],
        note: {
          label: '提升建议',
          tone: 'primary',
          content: '建议在 Prompt 模板中补充 Hibernate / MyBatis N+1 查询识别规则，以提高性能问题识别率。',
        },
      },
      {
        type: 'table',
        title: '模型能力对比',
        table: {
          columns: ['模型', 'Code Review', 'Bug 诊断', '平均 Token', '推荐场景'],
          rows: [
            [cell('claude-sonnet-4-6', 'default', true), cell('91%', 'success'), cell('87%', 'success'), cell('4,200'), cell('当前主力', 'success')],
            [cell('claude-opus-4-6', 'default', true), cell('96%', 'success'), cell('93%', 'success'), cell('6,800'), cell('高风险任务', 'warning')],
            [cell('claude-haiku-4-5', 'default', true), cell('74%', 'warning'), cell('71%', 'warning'), cell('1,100'), cell('低成本场景', 'primary')],
            [cell('GPT-4o', 'default', true), cell('88%', 'primary'), cell('82%', 'primary'), cell('3,900'), cell('备用模型', 'primary')],
          ],
        },
      },
    ],
  },
  // ??????
  atomic: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Atomic Capability',
        title: '原子能力库',
        description: '沉淀公司级基础能力与标准接入文档，让项目和 Agent 能快速复用。',
        actions: [
          { label: '注册原子能力', variant: 'primary' },
          { label: '查看接入统计' },
        ],
      },
      {
        type: 'catalog-grid',
        columns: 3,
        items: [
          { icon: '🔐', title: 'SSO / 统一认证', subtitle: '支持 OAuth2、OIDC、LDAP', badge: '高复用', tone: 'success', description: '已接入 12 个项目，提供前后端示例和鉴权中间件。' },
          { icon: '📨', title: '短信服务', subtitle: '验证码、营销、通知模板', badge: '热门', tone: 'primary', description: '支持多供应商路由和发送审计。' },
          { icon: '💾', title: 'OSS 对象存储', subtitle: '上传、签名、生命周期管理', badge: '标准化', tone: 'primary', description: '已提供 Java / Node / Python SDK 模板。' },
        ],
      },
      {
        type: 'table',
        title: '接入分布',
        table: {
          columns: ['能力', '接入项目', '文档状态', '代码模板', '最近更新'],
          rows: [
            [cell('统一认证'), cell('12'), cell('已发布', 'success'), cell('React / Spring / Node'), cell('03-10')],
            [cell('短信服务'), cell('8'), cell('已发布', 'success'), cell('Node / Java'), cell('03-08')],
            [cell('OSS'), cell('9'), cell('已发布', 'success'), cell('Java / Python / TS'), cell('03-06')],
            [cell('支付网关'), cell('4'), cell('校验中', 'warning'), cell('Java'), cell('03-05')],
          ],
        },
      },
    ],
  },
  knowledge: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Knowledge Base',
        title: '全局知识库',
        description: '统一沉淀规范、架构、原型和运营手册，为 Agent 和项目提供共享语义检索。',
        actions: [
          { label: '上传文档', variant: 'primary' },
          { label: '查看索引策略' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'docs', icon: '📚', label: '已收录文档', value: '486', delta: '本周新增 32 份', tone: 'primary' },
          { id: 'search', icon: '🔎', label: '今日检索', value: '1,284', delta: 'Agent 调用占 74%', tone: 'success' },
          { id: 'coverage', icon: '🧠', label: '规范覆盖率', value: '92%', delta: '安全与前端规范已补齐', tone: 'success' },
          { id: 'latency', icon: '⚙️', label: '平均召回耗时', value: '182ms', delta: '混合检索开启后更稳定', tone: 'primary' },
        ],
      },
      {
        type: 'table',
        title: '知识资产',
        table: {
          columns: ['文件名', '类型', '范围', '上传者', '更新时间'],
          rows: [
            [cell('安全规范手册 v3.2'), cell('规范'), cell('全局'), cell('安全团队'), cell('03-12')],
            [cell('前端设计系统说明'), cell('设计'), cell('全局'), cell('设计平台'), cell('03-11')],
            [cell('AI 工作流接入指南'), cell('技术'), cell('全局'), cell('AI 平台'), cell('03-09')],
            [cell('商城系统原型图'), cell('原型'), cell('项目共享'), cell('产品部'), cell('03-08')],
          ],
        },
      },
    ],
  },
  skills: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Skill Library',
        title: 'Skill 库',
        description: '管理可分发到 IDE 和 Agent 的技能集合，统一维护提示词、流程和能力边界。',
        actions: [
          { label: '创建 Skill', variant: 'primary' },
          { label: '查看发布记录' },
        ],
      },
      {
        type: 'catalog-grid',
        columns: 3,
        items: [
          { icon: '🧪', title: '代码审查 Skill', subtitle: 'PR 场景标准审查流程', badge: '活跃', tone: 'success', description: '覆盖安全、规范、性能三个子分支。' },
          { icon: '🩺', title: '事故排障 Skill', subtitle: '结合日志与知识库定位根因', badge: '平台级', tone: 'primary', description: '已接入 SRE 值班流程，支持自动生成修复建议。' },
          { icon: '📋', title: '需求拆分 Skill', subtitle: 'PRD → Story → Task', badge: '产品协同', tone: 'primary', description: '支持生成 Sprint backlog 和评审 checklist。' },
        ],
      },
      {
        type: 'table',
        title: 'Skill 使用情况',
        table: {
          columns: ['Skill', '启用项目', '最近发布', '最近调用', '状态'],
          rows: [
            [cell('代码审查 Skill'), cell('14'), cell('03-11'), cell('2 分钟前'), cell('已发布', 'success')],
            [cell('事故排障 Skill'), cell('9'), cell('03-09'), cell('10 分钟前'), cell('已发布', 'success')],
            [cell('需求拆分 Skill'), cell('6'), cell('03-07'), cell('35 分钟前'), cell('灰度中', 'warning')],
          ],
        },
      },
    ],
  },
  templates: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Template Center',
        title: '模板库',
        description: '提供项目、服务、工作流和知识库接入模板，加速标准化交付。',
        actions: [
          { label: '新建模板', variant: 'primary' },
          { label: '同步模板版本' },
        ],
      },
      {
        type: 'catalog-grid',
        columns: 3,
        items: [
          { icon: '⚛️', title: 'React + TypeScript', subtitle: '适用于中后台与 MCP 前端控制台', badge: '推荐', tone: 'success', description: '内置 Vitest、权限骨架和设计令牌。' },
          { icon: '🍃', title: 'Spring Boot 服务模板', subtitle: '标准化日志、监控与安全配置', badge: '主力', tone: 'primary', description: '集成 CI/CD 与原子能力接入脚手架。' },
          { icon: '🐍', title: 'Python 数据服务', subtitle: '适合离线作业与 AI 推理编排', badge: '数据团队', tone: 'primary', description: '包含任务调度、观测和容器基线。' },
        ],
      },
    ],
  },
  // ??????
  keys: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Key Management',
        title: 'Key 管理',
        description: '统一管理多模型 API Key、Token 配额、轮转策略和使用审计。',
        actions: [
          { label: '新增 Key', variant: 'primary' },
          { label: '批量轮转' },
        ],
      },
      {
        type: 'metrics',
        items: [
          { id: 'active', icon: '🔑', label: '启用 Key', value: '18', delta: 'Claude / GPT / 文心 多模型并存', tone: 'primary' },
          { id: 'quota', icon: '🪙', label: '本月配额使用', value: '61%', delta: '商城系统和支付网关占用最高', tone: 'warning' },
          { id: 'rotation', icon: '🔄', label: '本周轮转', value: '3', delta: '全部已完成审计留痕', tone: 'success' },
          { id: 'risk', icon: '🛡️', label: '高风险告警', value: '1', delta: '有 1 个过期 Key 待下线', tone: 'danger' },
        ],
      },
      {
        type: 'table',
        title: 'Key 清单',
        table: {
          columns: ['Key 名称', '供应商', '作用域', '配额', '状态', '最近使用'],
          rows: [
            [cell('claude-prod-main', 'default', true), cell('Claude'), cell('平台级'), cell('8M / 月'), cell('使用中', 'success'), cell('1 分钟前')],
            [cell('gpt-backup', 'default', true), cell('OpenAI'), cell('备用模型'), cell('2M / 月'), cell('使用中', 'success'), cell('12 分钟前')],
            [cell('wenxin-cn', 'default', true), cell('文心'), cell('中文场景'), cell('1M / 月'), cell('待轮转', 'warning'), cell('昨天')],
            [cell('legacy-test-key', 'default', true), cell('Claude'), cell('测试'), cell('100K / 月'), cell('过期', 'danger'), cell('03-01')],
          ],
        },
      },
    ],
  },
  audit: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Audit & Security',
        title: '审计安全',
        description: '记录高风险操作、模型调用、审批链和配置变更，满足安全追踪要求。',
        actions: [
          { label: '导出审计日志', variant: 'primary' },
          { label: '查看风险策略' },
        ],
      },
      {
        type: 'table',
        title: '最近审计事件',
        table: {
          columns: ['时间', '操作者', '事件', '对象', '结果', '备注'],
          rows: [
            [cell('09:25'), cell('张三'), cell('重置服务 Token'), cell('mall-backend MCP'), cell('成功', 'success'), cell('已通知项目负责人')],
            [cell('09:08'), cell('李四'), cell('发起生产部署'), cell('payment-core'), cell('待审批', 'warning'), cell('双人审批链启动')],
            [cell('08:42'), cell('AI Agent'), cell('调用高风险函数'), cell('trigger_deploy'), cell('拦截', 'danger'), cell('未满足审批策略')],
          ],
        },
      },
      {
        type: 'notes',
        title: '风险策略',
        notes: [
          { label: '高风险操作', content: '生产部署、Key 轮转和审批策略变更必须记录完整操作链。', tone: 'warning' },
          { label: 'Agent 调用', content: 'Tool 调用将自动附带执行 ID、调用参数摘要和触发来源。', tone: 'primary' },
        ],
      },
    ],
  },
  settings: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Platform Settings',
        title: '平台设置',
        description: '维护组织级模型路由、权限策略、通知渠道和默认模板配置。',
        actions: [
          { label: '保存配置', variant: 'primary' },
          { label: '回滚到上次版本' },
        ],
      },
      {
        type: 'split',
        columns: 2,
        items: [
          {
            title: '模型路由',
            lines: [
              { label: '默认推理模型', value: 'claude-sonnet-4-6', mono: true },
              { label: '高风险场景', value: 'claude-opus-4-6', mono: true },
              { label: '低成本回退', value: 'claude-haiku-4-5', mono: true },
            ],
          },
          {
            title: '通知与审批',
            lines: [
              { label: '消息渠道', value: '飞书 + 邮件 + 站内信' },
              { label: '生产审批', value: '双人审批 + 值班确认' },
              { label: '事故升级', value: '15 分钟未处理自动升级' },
            ],
          },
          {
            title: '默认模板',
            lines: [
              { label: '项目模板', value: 'React + TS / Spring Boot' },
              { label: '工作流模板', value: 'Code Review / Bug Fix / PRD Split' },
              { label: '知识库策略', value: '全局规范默认启用' },
            ],
          },
          {
            title: '治理提醒',
            notes: [
              { label: '建议', content: '可以为不同部门设置差异化 Token 配额和审批阈值。', tone: 'primary' },
              { label: '注意', content: '修改模型路由后需同步评估中心基准结果。', tone: 'warning' },
            ],
          },
        ],
      },
    ],
  },
  default: {
    sections: [
      {
        type: 'hero',
        eyebrow: 'Platform Space',
        title: '模块建设中',
        description: '该模块已完成导航预留，后续将按原型继续细化。',
      },
    ],
  },
}

// ???????????????????????????
const pageKey = computed(() =>
  typeof route.params.pageKey === 'string' ? route.params.pageKey : 'default',
)

// ???????????????????????????
const pageConfig = computed(() => pageConfigs[pageKey.value] ?? pageConfigs.default)
</script>

<template>
  <section data-testid="global-module-page">
    <ModuleContent :sections="pageConfig?.sections ?? []" />
  </section>
</template>


