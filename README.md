# AI 中台 - 企业 AI 管理平台 技术方案

## 一、项目概述

AI 中台是面向企业的 AI 能力管理平台，统一管理 AI 资源（大模型 Key、Token 配额）、研发流程（项目管理、CI/CD、环境管理）和 AI 辅助能力（Agent 工作流、代码审查、故障诊断），通过 MCP Server 将平台能力无缝接入开发者 IDE（Cursor / Claude Code）。

### 核心价值

- **统一治理**：集中管理多模型 Key（Claude / GPT / 文心）、Token 配额分配与审计
- **AI 赋能研发**：AI 自动 Code Review、故障诊断、需求拆分、单测生成
- **MCP 桥接 IDE**：每个项目/服务生成专属 MCP Server，开发者在 IDE 中直接使用平台能力
- **原子能力复用**：公司级基础能力（SSO、短信、支付、OSS）标准化注册，AI 自动生成接入代码

---

## 二、系统架构

### 2.1 整体分层架构

```
┌─────────────────────────────────────────────────────────┐
│                      前端 Web 管理台                       │
│  工作台 │ 项目空间 │ AI能力管理 │ 资源管理 │ 安全审计 │ 设置  │
├─────────────────────────────────────────────────────────┤
│                       API Gateway                        │
├──────────┬──────────┬──────────┬──────────┬──────────────┤
│ 项目服务  │ AI 能力   │ 资源服务  │ 安全审计  │ MCP Server  │
│          │ 服务      │          │ 服务     │ 生成/代理    │
├──────────┴──────────┴──────────┴──────────┴──────────────┤
│                    基础设施层                              │
│  数据库 │ 消息队列 │ 对象存储 │ 日志系统 │ 监控告警       │
├─────────────────────────────────────────────────────────┤
│               外部集成层                                  │
│  LLM API │ Git 平台 │ CI/CD 引擎 │ K8s 集群 │ SSO/LDAP   │
└─────────────────────────────────────────────────────────┘
```

### 2.2 MCP 通信架构

```
开发者 IDE (Cursor / Claude Code)
       │
       │ MCP Protocol (HTTP/SSE)
       ▼
┌─────────────────────┐
│  MCP Server Gateway  │  ← 每个项目/服务生成独立 MCP endpoint
│  (认证 + 路由)       │     URL: https://mcp.ai.co/svc/{service-name}
├─────────────────────┤
│ Tools:               │
│ • search_knowledge   │  → 语义搜索知识库
│ • get_atomic_cap     │  → 获取原子能力文档
│ • report_bug         │  → 创建事故任务
│ • trigger_deploy     │  → 触发环境部署
└─────────────────────┘
```

---

## 三、功能模块详细设计

### 3.1 工作台 (Dashboard)

| 功能项 | 说明 | 数据来源 |
|-------|------|---------|
| Token 消耗统计 | 月度总量、日趋势折线图 | LLM API 调用日志聚合 |
| 部门 Token 排行 | 按部门维度展示用量，超配额预警 | Token 计量服务 |
| 事故摘要 | 近期事故列表，含严重/警告/提示分级 | 事故中心服务 |
| 项目活动流 | 时间线展示近期操作（代码推送、文档更新等） | 事件总线聚合 |

### 3.2 项目空间

#### 3.2.1 项目模型

```
Project {
  id: UUID
  name: string                    // 项目名称
  type: enum(产品/内部系统/技术中台/数据产品)
  description: string
  icon: string                    // emoji 图标
  status: enum(进行中/待上线/已完成/已归档)
  services: Service[]             // 关联的代码服务
  members: Member[]               // 成员及权限
  sprint: Sprint                  // 当前 Sprint
  tokenQuota: number              // 月 Token 配额
  tokenUsed: number               // 已使用 Token
  knowledgeBase: Document[]       // 项目知识库
  skills: Skill[]                 // 启用的 AI Skill
  atomicCapabilities: AtomicCap[] // 关联的原子能力
  gitBranchStrategy: enum(GitFlow/TrunkBased/FeatureBranch)
  template: Template?             // 创建时使用的模板
}
```

#### 3.2.2 项目创建流程

1. 填写基础信息（名称、类型、描述、分支策略）
2. 选择项目模板（React+TS / Spring Boot / Node.js BFF / Python 数据服务 / 空白）
3. 启用全局知识库（代码规范、安全手册、UI规范、架构指南）
4. 关联原子能力（SSO、短信、支付、OSS、BI 等）
5. 配置研发流程（Sprint 周期、CI/CD 流水线模板、Token 配额）
6. **自动生成项目专属 MCP Server**

#### 3.2.3 项目内部功能

- **概览**：Sprint 进度、代码服务健康、AI 每日摘要
- **研发流程（Agile）**：Sprint 看板（Kanban）、Backlog 管理、燃尽图、迭代回顾（AI 生成）
- **知识库**：项目文档管理（需求/原型/技术文档），支持全局知识库继承
- **事故管理**：项目维度事故列表，AI 自动诊断 + IDE 内修复
- **代码服务**：管理项目关联的多个 Git 仓库/微服务
- **成员权限**：角色（项目负责人/开发）、Token 限额、知识库读写权限、Skill 权限、MCP 访问
- **Skill 配置**：项目级 Skill 启用/禁用
- **项目设置**：基础信息、Sprint 周期、Token 配额、原子能力关联

### 3.3 代码服务 (Service)

#### 3.3.1 服务模型

```
Service {
  id: UUID
  name: string                // 如 mall-backend
  techStack: string           // 如 Spring Boot 3, React 18
  gitRepo: string             // Git 仓库地址
  mainBranch: string          // 主干分支
  environments: Environment[] // DEV / STAGING / PROD
  mcpServer: MCPConfig        // 服务级 MCP 配置
  cicdPipeline: Pipeline      // CI/CD 流水线
  healthStatus: enum(正常/构建中/异常)
}
```

#### 3.3.2 服务详情页（Tab 结构）

| Tab | 内容 |
|-----|------|
| 概览 | 今日构建数、P99 延迟、测试覆盖率、代码行数（含 AI 贡献比）、最近 PR、AI 代码质量分析 |
| CI/CD | 流水线记录，阶段可视化（构建 → 单测 → 扫描 → 部署） |
| 环境管理 | DEV / STAGING / PROD 三环境卡片，版本、部署策略、健康状态 |
| MCP 配置 | 服务专属 MCP Server 地址 + Token，暴露的工具列表 |

#### 3.3.3 添加服务方式

1. 从模板创建（公司标准项目模板）
2. 关联已有 Git 仓库（自动识别技术栈）
3. 从 GitHub / GitLab 导入

### 3.4 CI/CD 流水线

#### 3.4.1 流水线阶段

```
构建 (Build) → 单元测试 (Unit Test) → 代码扫描 (Scan) → 部署 (Deploy)
```

每个阶段状态：`成功 (success)` | `运行中 (running)` | `失败 (failed)` | `待执行 (pending)`

#### 3.4.2 AI 能力集成

- 构建失败时 AI 自动分析根因并给出修复建议
- 单测失败时定位到具体代码行并提供修复方案
- 支持在 IDE 中一键修复（通过 MCP 工具 `report_bug`）

### 3.5 环境管理

三级环境体系：

| 环境 | 部署策略 | 审批要求 |
|------|---------|---------|
| DEV | 自动部署（每次 feature 分支 push） | 无 |
| STAGING | 手动触发 | Tech Lead 审批 |
| PROD | 灰度发布 | 2人审批 + 变更单 |

每个环境展示：健康状态、当前版本/分支、实例数（pods）、部署历史。

### 3.6 事故中心

#### 3.6.1 事故分级

| 级别 | 标识 | 说明 |
|------|------|------|
| 严重 | 🔴 红色 | 线上核心功能不可用（如支付异常） |
| 警告 | 🟡 黄色 | 性能劣化（如 P99 超阈值） |
| 提示 | 🔵 蓝色 | 质量问题（如打包体积超限） |

#### 3.6.2 AI 诊断流程

```
事故报告 → AI 读取错误堆栈/日志 → 分析根因 → 定位代码行 → 生成修复建议
    → 开发者在 IDE 中一键领取 → AI 辅助修复 → 提交 PR → 标记已解决
```

### 3.7 Agent 工作流

可视化 Agent 流程编排，支持以下节点类型：

| 节点类型 | 颜色标识 | 说明 |
|---------|---------|------|
| Trigger（触发器） | 蓝色 | 工作流触发条件（如 PR 创建、事故上报） |
| LLM（大模型调用） | 紫色 | 调用 LLM 执行推理任务 |
| Tool（工具调用） | 绿色 | 调用外部工具/API |
| Condition（条件分支） | 黄色 | 逻辑判断，支持多分支 |
| Human（人工审核） | 红色 | 需要人工介入确认 |

预置 Agent 工作流：

1. **代码 Review Agent**：PR 触发 → Diff 分析 → LLM 审查 → 条件判断（通过/不通过）→ 发布 Review 意见
2. **Bug 诊断修复 Agent**：事故触发 → 日志收集 → 根因分析 → 修复方案生成 → 人工确认
3. **需求拆分 Agent**：PRD 上传 → 文档解析 → 拆分 Epic/Story/Task → 估算 SP → 人工评审

每个工作流记录运行统计：执行次数、成功率、平均耗时、Token 消耗。

### 3.8 Function 管理

管理 Agent 可调用的函数/工具定义：

```
Function {
  name: string          // 如 search_codebase
  description: string   // 自然语言描述
  parameters: [{
    name: string
    type: string        // string / boolean / integer
    required: boolean
    description: string
  }]
  returnType: string
  category: enum(搜索/代码分析/知识库/部署/事故)
}
```

预置 Functions：`search_codebase`、`read_file`、`run_tests`、`search_knowledge`、`create_issue`、`deploy_to_env` 等。

### 3.9 AI 执行监控

实时监控 AI Agent 执行情况：

- Token 用量趋势图
- 工具调用成功率
- 各 Function 调用频次排行
- 执行日志追踪（Agent 调用链）

### 3.10 AI 评估中心

评估 AI 能力质量：

| 评估维度 | 指标 |
|---------|------|
| Code Review 质量 | 准确率、误报率 |
| 故障诊断 | 根因定位准确率 |
| 文档生成 | 完整度评分 |
| 需求拆分 | 拆分合理度 |

支持版本对比（不同模型/Prompt 版本的效果对比）、按 Sprint 趋势查看。

### 3.11 原子能力库

#### 3.11.1 能力模型

```
AtomicCapability {
  id: UUID
  name: string            // 如 "统一短信服务"
  category: enum(基础设施/业务中台/数据服务)
  description: string
  gitRepo: string         // Git 仓库地址（AI 自动读取文档）
  branch: string
  version: string
  sdkLanguages: string[]  // 支持的语言 SDK (Java / Node.js / Python)
  projectCount: number    // 已接入项目数
}
```

#### 3.11.2 已注册能力清单

**基础设施**：统一短信服务、邮件推送服务、对象存储 OSS

**业务中台**：统一身份认证 SSO（OIDC/OAuth2）、统一支付网关（微信/支付宝/银联）、BI 数据查询服务

#### 3.11.3 AI 自动接入流程

```
开发者在 IDE 输入 "接入短信服务"
  → MCP 调用 get_atomic_capability("sms")
  → AI 读取 Git 仓库 README + 接入文档
  → 分析当前项目技术栈
  → 自动生成：依赖配置 + Service 代码 + 配置项 + 单元测试
```

### 3.12 知识库

两级知识库体系：

| 级别 | 范围 | 内容 |
|------|------|------|
| 全局知识库 | 所有项目共享 | 代码规范、安全手册、UI 设计规范、微服务架构指南 |
| 项目知识库 | 项目内可见 | 需求文档、原型图、接口文档（AI 生成）、业务文档 |

项目可选择性启用全局知识库条目。知识库通过 MCP 工具 `search_knowledge` 暴露给 IDE 中的 AI。

### 3.13 Skill 库

| 类型 | Skill | 功能 |
|------|-------|------|
| 内置 | Code Review | 自动审查代码质量、安全、性能 |
| 内置 | 接口文档生成 | 代码 → OpenAPI 文档自动生成 |
| 内置 | 故障诊断 | 日志分析、根因定位、修复建议 |
| 内置 | 单元测试生成 | 根据代码自动生成单元测试用例 |
| 自定义 | SSO 集成助手 | 一键生成公司 SSO 对接代码 |
| 自定义 | Git 提交规范检查 | 确保 commit message 符合公司规范 |
| 自定义 | BI 数据查询 | 自然语言查询公司 BI 数据 |

Skill 可在全局或项目级别启用/禁用。

### 3.14 模板库

| 模板 | 技术栈 | 内置配置 |
|------|--------|---------|
| React + TypeScript 前端 | React 18, Vite, Tailwind | 路由、状态管理、组件库、CI/CD、ESLint、单测 |
| Spring Boot 微服务 | Spring Boot 3, MySQL | SSO 对接、统一异常处理、日志规范、Swagger、Docker |
| Node.js BFF | Node 20, Fastify | 接口聚合、鉴权中间件、Redis 缓存、限流、Jest |
| Python 数据服务 | Python 3.12, FastAPI | 数据处理管道、Celery 异步任务、Pytest |

支持上传自定义模板。

### 3.15 Key 管理

- **多模型支持**：Claude / GPT / 文心，主模型 + 备用模型（超限自动切换）
- **配额层级**：公司总配额 → 部门配额 → 员工个人配额
- **超额策略**：降速（切换低价模型） / 暂停使用 / 通知管理员
- **用量监控**：按员工维度展示 Token 使用率，超额预警

### 3.16 审计安全

#### 3.16.1 安全规则

| 规则 | 说明 | 默认状态 |
|------|------|---------|
| 敏感信息过滤 | 自动检测并屏蔽 API Key、密码、身份证号 | 已启用 |
| 代码外传检测 | 阻止核心代码被发送到外部 AI 服务 | 已启用 |
| Prompt 注入防护 | 检测并阻断恶意 Prompt 注入攻击 | 已启用 |
| 合规审计日志 | 记录所有 AI 对话，保留 180 天 | 待启用 |

#### 3.16.2 审计日志

记录所有用户操作：AI 对话（含敏感词过滤结果）、权限变更、MCP 接入、文档上传等。

### 3.17 效能看板

研发效能度量指标：

| 指标 | 说明 |
|------|------|
| AI 代码贡献率 | AI 生成代码占总提交比例 |
| PR 平均合并时间 | 从创建到合并的平均时长 |
| Bug 平均修复时间 | 从事故创建到标记解决的平均时长 |
| Sprint 完成率 | 每个 Sprint 实际完成 SP / 计划 SP |
| 人均 Token 效率 | 每消耗 1K Token 产出的代码行数/解决的任务数 |

---

## 四、数据模型关系

```
Company
  ├── Departments[]
  │     └── Members[]          (每个成员有 Token 配额)
  ├── Projects[]
  │     ├── Services[]         (每个服务有 Git 仓库)
  │     │     ├── Environments[] (DEV / STAGING / PROD)
  │     │     ├── Pipelines[]    (CI/CD 流水线)
  │     │     └── MCPServer      (服务级 MCP endpoint)
  │     ├── Sprints[]
  │     │     └── Tasks[]        (Kanban 任务卡)
  │     ├── KnowledgeBase[]      (项目知识库文档)
  │     ├── Incidents[]          (事故列表)
  │     ├── Members[]            (项目成员 + 权限)
  │     └── SkillConfigs[]       (项目 Skill 启用配置)
  ├── GlobalKnowledgeBase[]      (全局知识库)
  ├── AtomicCapabilities[]       (原子能力注册表)
  ├── Skills[]                   (Skill 定义)
  ├── Templates[]                (项目模板)
  ├── AgentWorkflows[]           (Agent 工作流定义)
  │     └── WorkflowNodes[]      (工作流节点)
  ├── Functions[]                (Function/Tool 定义)
  ├── APIKeys[]                  (多模型 Key 管理)
  └── AuditLogs[]                (审计日志)
```

---

## 五、技术选型建议

### 5.1 前端

| 层面 | 推荐方案                       | 说明 |
|------|----------------------------|------|
| 框架 | Vue3 + TypeScript          | 组件化开发，生态成熟 |
| 构建工具 | Vite                       | 开发体验优、HMR 快 |
| UI 组件库 | Ant Design 5               | 企业级 UI 组件，表格/表单/图表丰富 |
| 状态管理 | Zustand / Redux Toolkit    | 轻量灵活 |
| 路由 | 暂定                         | 嵌套路由支持项目→服务多级导航 |
| 图表 | ECharts / Recharts         | 数据可视化（Token 趋势、燃尽图） |
| 看板 | 暂定                         | Kanban 拖拽交互 |
| 代码展示 | Monaco Editor / CodeMirror | 错误堆栈、代码片段展示 |
| 工作流编辑 | 暂定                         | Agent 工作流可视化编排 |

### 5.2 后端

| 层面 | 推荐方案                       | 说明 |
|------|----------------------------|------|
| 框架 | Spring Boot 3 (Java)       | 企业级稳定性 |
| API 协议 | RESTful + WebSocket        | WebSocket 用于实时推送（构建状态、AI 执行流） |
| MCP Server | Node.js / Python (MCP SDK) | 基于 MCP 协议为每个项目/服务生成 endpoint |
| LLM 集成 | Anthropic SDK + OpenAI SDK | 多模型网关，支持降级切换 |
| 任务队列 | kafkaMq / Redis Stream     | 异步处理 CI/CD 触发、AI 任务执行 |
| 搜索引擎 | Elasticsearch              | 知识库语义搜索 |
| 向量数据库 | pgvector / Milvus          | 知识库文档 Embedding 存储 |

### 5.3 基础设施

| 层面 | 推荐方案                                 |
|------|--------------------------------------|
| 数据库 | Mysql（主数据） + Redis（缓存/会话）            |
| 对象存储 | MinIO / 云 OSS（文档、原型图存储）              |
| 容器编排 | Kubernetes（管理 DEV/STAGING/PROD 环境）   |
| CI/CD 引擎 | GitLab CI / GitHub Actions / Jenkins |
| 监控 | Prometheus + Grafana（平台自身监控）         |
| 日志 | ELK Stack / Loki（审计日志存储）             |
| SSO | 公司内部 OIDC/LDAP 对接                    |

---

## 六、核心 API 设计

### 6.1 项目管理

```
POST   /api/projects                    创建项目（含自动生成 MCP Server）
GET    /api/projects                    项目列表（支持状态/类型筛选）
GET    /api/projects/:id                项目详情
PUT    /api/projects/:id                更新项目配置
DELETE /api/projects/:id                归档项目

POST   /api/projects/:id/services       添加代码服务
GET    /api/projects/:id/services       服务列表
GET    /api/projects/:id/services/:sid   服务详情

POST   /api/projects/:id/members        添加成员
PUT    /api/projects/:id/members/:uid    更新成员权限
```

### 6.2 Sprint & 研发流程

```
POST   /api/projects/:id/sprints        创建 Sprint
GET    /api/projects/:id/sprints/current 当前 Sprint（含看板任务）
PUT    /api/sprints/:sid/tasks/:tid      更新任务状态（拖拽看板）
POST   /api/sprints/:sid/ai-split       AI 拆分 PRD 为 User Story
GET    /api/sprints/:sid/burndown       燃尽图数据
POST   /api/sprints/:sid/retro          AI 生成迭代回顾
```

### 6.3 CI/CD & 环境

```
GET    /api/pipelines                   流水线列表（跨项目）
GET    /api/pipelines/:pid              流水线详情（含各阶段状态）
POST   /api/pipelines/:pid/retry        重新触发流水线

POST   /api/services/:sid/deploy        触发部署
GET    /api/services/:sid/envs          环境列表
GET    /api/services/:sid/envs/:env/logs 环境日志
```

### 6.4 事故中心

```
GET    /api/incidents                   事故列表（支持项目/级别/状态筛选）
POST   /api/incidents                   创建事故（可通过 MCP 触发）
GET    /api/incidents/:iid              事故详情 + AI 诊断结果
PUT    /api/incidents/:iid/resolve      标记已解决
POST   /api/incidents/:iid/ai-diagnose  触发 AI 诊断
```

### 6.5 AI 能力

```
GET    /api/workflows                   Agent 工作流列表
GET    /api/workflows/:wid              工作流详情（含节点定义）
POST   /api/workflows/:wid/execute      手动执行工作流
GET    /api/workflows/:wid/stats        工作流运行统计

GET    /api/functions                   Function 列表
POST   /api/functions                   注册新 Function
GET    /api/functions/:fid              Function 详情（含参数 Schema）

GET    /api/ai/monitor                  AI 执行监控数据
GET    /api/ai/evals                    AI 评估报告
```

### 6.6 资源管理

```
GET    /api/atomic-capabilities          原子能力列表
POST   /api/atomic-capabilities          注册原子能力
GET    /api/atomic-capabilities/:aid/doc  获取能力接入文档（AI 读取）

GET    /api/knowledge/global             全局知识库
GET    /api/knowledge/project/:pid       项目知识库
POST   /api/knowledge/upload             上传文档
POST   /api/knowledge/search             语义搜索

GET    /api/skills                       Skill 列表
POST   /api/projects/:id/skills/:sid/enable  启用 Skill
POST   /api/projects/:id/skills/:sid/disable 禁用 Skill

GET    /api/templates                    模板列表
POST   /api/templates                    上传自定义模板
```

### 6.7 管理

```
GET    /api/keys                        Key 列表（员工维度）
PUT    /api/keys/:uid/quota             调整 Token 配额
GET    /api/keys/usage                  用量统计

GET    /api/audit/logs                  审计日志（支持时间/用户/操作筛选）
PUT    /api/audit/rules/:rid            更新安全规则开关

GET    /api/settings                    全局设置
PUT    /api/settings/model              更新模型配置（主/备模型、API Key）
PUT    /api/settings/token-policy       更新 Token 策略
```

### 6.8 MCP Server

```
POST   /api/mcp/generate/:projectId     为项目生成 MCP Server
GET    /api/mcp/:projectId/config       获取 MCP 接入配置（含 URL + Token）
POST   /api/mcp/:projectId/reset-token  重置 MCP Token

# MCP Protocol Endpoints (供 IDE 调用)
GET    /mcp/svc/:serviceName/tools      列出可用工具
POST   /mcp/svc/:serviceName/execute    执行工具调用
```

---

## 七、权限模型

### 7.1 角色体系

| 角色 | 范围 | 权限 |
|------|------|------|
| 超级管理员 | 平台 | 全局配置、模型管理、安全规则、全局知识库 |
| 部门管理员 | 部门 | 部门 Token 分配、成员管理 |
| 项目负责人 | 项目 | Token 无限制、知识库读写、全部 Skill、成员管理 |
| 开发 | 项目 | Token 有限额、知识库只读、代码相关 Skill |

### 7.2 MCP 访问控制

每个 MCP Server 使用独立 Token 认证，权限继承项目成员角色设置。

---

## 八、实施路线图建议

### Phase 1 - 基础平台（MVP）
- 项目管理 CRUD
- 代码服务关联（Git 仓库绑定）
- Key/Token 配额管理
- 全局知识库
- 基础 MCP Server 生成（search_knowledge）

### Phase 2 - AI 能力
- Agent 工作流引擎（Code Review Agent 先行）
- AI 事故诊断
- Skill 框架 + 内置 Skill
- Function 注册与管理

### Phase 3 - 研发流程
- Sprint/Kanban 看板
- CI/CD 流水线集成
- 环境管理
- AI 需求拆分

### Phase 4 - 治理与度量
- 审计安全规则
- 效能看板
- AI 评估中心
- 原子能力市场
