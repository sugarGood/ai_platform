# Enterprise AI Workspace Frontend Rebuild Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 将当前前端原型重构为以“项目下 AI 工作区”为核心的信息架构，替换旧的 Key 中心化表达，并产出可演示的新工作区原型界面。

**Architecture:** 本计划只覆盖前端信息架构、页面模块与原型数据重构，不覆盖后台网关、真实权限引擎或供应商接入实现。实现方式延续现有 Vue 3 + mock data + `ModuleContent` 渲染模式，在保留壳层结构的前提下，将项目层与工作区层导航、模块配置、展示文案、测试用例统一改造成“AI 工作区接入与治理”模型。

**Tech Stack:** Vue 3、TypeScript、Vue Router、Vitest、现有 mock data 与模块化页面配置

---

## Scope Note

本设计文档覆盖企业平台、项目治理、工作区接入、客户端边界、额度与审计等多个子系统。为避免单份计划过大，本计划仅负责以下前端子范围：

- 企业层、项目层、工作区层的信息架构重构
- 工作区页面模块与接入方式展示
- 旧 Key 中心化页面和监控 mock 的移除/替换
- 相关 mock 数据、路由、导航与测试更新

以下内容应在后续单独计划中处理：

- 后台领域模型与数据库结构
- 网关转发与供应商接入
- 审批流与审计中心后端实现
- 服务账号与凭证生命周期后端实现

---

## File Structure

### Frontend shell and navigation

- Modify: `frontend/src/mocks/navigation.ts`
  - 将全局导航与项目导航改造成企业层 / 项目层 / 工作区层的新结构。
- Modify: `frontend/src/router/index.ts`
  - 对齐新导航结构，补充工作区级路由与默认跳转。
- Modify: `frontend/src/components/shell/ProjectSidebar.vue`
  - 展示工作区相关导航，不再暴露旧 `keymanagement` 语义。
- Modify: `frontend/src/components/shell/GlobalSidebar.vue`
  - 调整企业层模块命名，使其与新设计一致。

### Domain types and mock data

- Modify: `frontend/src/types/project.ts`
  - 增加 `workspace`、`ability set`、`connection method`、`quota` 等前端展示所需类型。
- Modify: `frontend/src/mocks/projects.ts`
  - 将项目 mock 从“成员/服务/Token”模型扩展为“项目 + AI 工作区 + 角色/能力 + 接入方式”模型。
- Modify: `frontend/src/types/module-page.ts`
  - 如有必要，补充工作区接入卡片、能力摘要、治理状态等展示结构。

### Workspace and project feature pages

- Modify: `frontend/src/features/project/ProjectOverviewPage.vue`
  - 将项目首页改造成项目总览 + 工作区摘要入口。
- Modify: `frontend/src/features/project/ProjectModulePage.vue`
  - 重写项目级模块配置与工作区级模块内容，移除旧 Key 管理模块表达。
- Create: `frontend/src/features/project/WorkspaceDetailPage.vue`
  - 承载工作区概览、接入方式、我的 AI 能力、额度与使用等核心页面。
- Create: `frontend/src/features/project/WorkspaceModuleFactory.ts`
  - 拆出工作区模块配置构建逻辑，避免 `ProjectModulePage.vue` 继续膨胀。

### Legacy key-management cleanup

- Modify or Delete: `frontend/src/components/ui/KeyManagementMonitor.vue`
  - 如不再复用，删除；如保留骨架，则重命名并调整为工作区使用监控组件。
- Modify or Delete: `frontend/src/composables/useKeyMonitoring.ts`
  - 移除旧“成员 Key 分配”语义，改为工作区使用监控 mock，或删除并由新 composable 替代。
- Modify or Delete: `frontend/src/composables/usePageNavigation.ts`
  - 删除围绕旧 `keymanagement` 路由的特化逻辑。
- Create: `frontend/src/composables/useWorkspaceMonitoring.ts`
  - 如果保留实时演示数据，提供工作区用量、告警、客户端接入状态等 mock。

### Tests

- Modify: `frontend/src/test/router.spec.ts`
- Modify: `frontend/src/test/project-shell.spec.ts`
- Modify: `frontend/src/test/project-entry.spec.ts`
- Modify: `frontend/src/test/prototype-menu.spec.ts`
- Modify: `frontend/src/test/topbar-actions.spec.ts`
- Modify: `frontend/src/test/module-actions.spec.ts`
- Create: `frontend/src/test/workspace-detail.spec.ts`
- Modify or Delete: `frontend/src/tests/key-monitoring.test.ts`

### Documentation

- Modify: `docs/superpowers/specs/2026-03-18-enterprise-ai-workspace-platform-design.md`
  - 如实现中有小幅命名收敛，补充术语说明。
- Create: `docs/superpowers/plans/2026-03-18-enterprise-ai-workspace-frontend-rebuild.md`
  - 当前实施计划。

---

## Chunk 1: 信息架构与路由重构

### Task 1: 重构项目与工作区导航模型

**Files:**
- Modify: `frontend/src/mocks/navigation.ts`
- Modify: `frontend/src/types/navigation.ts`
- Test: `frontend/src/test/router.spec.ts`
- Test: `frontend/src/test/project-shell.spec.ts`

- [ ] **Step 1: 写出导航结构变更清单**

记录新导航最小集合：
- 企业层：企业 AI 资源、企业治理、企业能力资产、项目与工作区总览
- 项目层：项目概览、AI 工作区、项目成员、项目知识资产、项目治理
- 工作区层：工作区概览、接入方式、我的 AI 能力、额度与使用、成员与角色、知识与工具、服务账号、审计与审批、工作区设置

- [ ] **Step 2: 在 `navigation.ts` 中移除旧 `keymanagement` 入口并加入工作区入口**

要求：
- 项目导航不再包含“Key 管理中心”语义
- 新导航明确区分项目层与工作区层入口
- 保留当前 sidebar 结构风格，不引入额外 UI 框架

- [ ] **Step 3: 更新导航类型定义以支持工作区入口**

在 `frontend/src/types/navigation.ts` 中补充：
- 工作区标识字段
- 项目级与工作区级导航项可选元数据

- [ ] **Step 4: 更新路由测试以反映新导航**

Run: `npm test -- src/test/router.spec.ts src/test/project-shell.spec.ts`
Expected: 与旧 `keymanagement` 相关断言失败，提示路由或导航文本不匹配

- [ ] **Step 5: 提交当前变更**

```bash
git add frontend/src/mocks/navigation.ts frontend/src/types/navigation.ts frontend/src/test/router.spec.ts frontend/src/test/project-shell.spec.ts
git commit -m "feat: reshape project navigation around ai workspaces"
```

### Task 2: 调整路由入口与默认落点

**Files:**
- Modify: `frontend/src/router/index.ts`
- Modify: `frontend/src/features/project/ProjectOverviewPage.vue`
- Test: `frontend/src/test/project-entry.spec.ts`
- Test: `frontend/src/test/router.spec.ts`

- [ ] **Step 1: 先写失败用例描述新的默认访问路径**

新增/更新测试，明确：
- 进入项目后默认展示项目概览
- 从项目概览可以进入默认 AI 工作区
- 工作区详情路由应独立于旧 section 模型

- [ ] **Step 2: 运行单测验证旧路由行为已不满足需求**

Run: `npm test -- src/test/project-entry.spec.ts src/test/router.spec.ts`
Expected: FAIL，提示缺少工作区详情路由或默认跳转仍指向旧页面结构

- [ ] **Step 3: 在 `router/index.ts` 中增加工作区详情路由**

要求：
- 保持现有 AppShell 结构
- 使用项目 ID + workspace ID 路径
- 为默认工作区提供显式入口

- [ ] **Step 4: 在 `ProjectOverviewPage.vue` 中增加工作区摘要入口**

至少展示：
- 默认工作区名称
- 工作区数量
- 接入方式数量
- 当前风险/额度摘要

- [ ] **Step 5: 重新运行测试并确认通过**

Run: `npm test -- src/test/project-entry.spec.ts src/test/router.spec.ts`
Expected: PASS

- [ ] **Step 6: 提交当前变更**

```bash
git add frontend/src/router/index.ts frontend/src/features/project/ProjectOverviewPage.vue frontend/src/test/project-entry.spec.ts frontend/src/test/router.spec.ts
git commit -m "feat: add workspace-aware project routes"
```

---

## Chunk 2: 工作区核心页面重建

### Task 3: 扩展项目与工作区 mock 数据模型

**Files:**
- Modify: `frontend/src/types/project.ts`
- Modify: `frontend/src/mocks/projects.ts`
- Test: `frontend/src/test/project-entry.spec.ts`
- Test: `frontend/src/test/module-actions.spec.ts`

- [ ] **Step 1: 在类型文件中定义工作区展示模型**

至少增加以下类型：
- `ProjectWorkspaceSummary`
- `WorkspaceRoleSummary`
- `WorkspaceAbilitySummary`
- `WorkspaceConnectionMethod`
- `WorkspaceQuotaSummary`

- [ ] **Step 2: 在 `projects.ts` 中为每个项目补齐默认工作区 mock**

每个工作区最少包含：
- 名称与说明
- 成员数
- 默认角色摘要
- 已分配能力摘要
- 支持接入方式
- 额度与最近告警

- [ ] **Step 3: 更新依赖 mock 数据的测试**

Run: `npm test -- src/test/project-entry.spec.ts src/test/module-actions.spec.ts`
Expected: FAIL，提示缺少新增字段或页面渲染文案变化

- [ ] **Step 4: 对 mock 数据做最小补充，避免页面逻辑依赖旧字段**

要求：
- 尽量复用现有项目数据
- 旧 `tokenLabel` 等字段如仍被其他页面使用，可暂时保留但不再作为主语义

- [ ] **Step 5: 提交当前变更**

```bash
git add frontend/src/types/project.ts frontend/src/mocks/projects.ts frontend/src/test/project-entry.spec.ts frontend/src/test/module-actions.spec.ts
git commit -m "feat: add workspace domain mock data"
```

### Task 4: 新建工作区详情页与模块工厂

**Files:**
- Create: `frontend/src/features/project/WorkspaceDetailPage.vue`
- Create: `frontend/src/features/project/WorkspaceModuleFactory.ts`
- Modify: `frontend/src/types/module-page.ts`
- Test: `frontend/src/test/workspace-detail.spec.ts`

- [ ] **Step 1: 编写工作区详情页失败测试**

测试至少断言页面展示：
- 工作区概览
- 接入方式
- 我的 AI 能力
- 额度与使用
- 成员与角色

- [ ] **Step 2: 运行测试确认新页面尚不存在**

Run: `npm test -- src/test/workspace-detail.spec.ts`
Expected: FAIL，提示组件或路由不存在

- [ ] **Step 3: 在 `module-page.ts` 中补充新模块类型**

如需要增加：
- 接入方式卡片组
- AI 能力摘要组
- 工作区治理状态区块

- [ ] **Step 4: 创建 `WorkspaceModuleFactory.ts` 负责拼装工作区模块配置**

要求：
- 将工作区页面配置逻辑从页面组件中抽离
- 保持与 `ModuleContent` 的现有契约一致
- 不在页面中堆叠超长 `computed` 配置

- [ ] **Step 5: 创建 `WorkspaceDetailPage.vue` 最小实现并接入 `ModuleContent`**

页面至少渲染：
- Hero 区
- 接入方式区
- 我的 AI 能力区
- 额度与使用区
- 成员与角色区

- [ ] **Step 6: 运行测试验证通过**

Run: `npm test -- src/test/workspace-detail.spec.ts`
Expected: PASS

- [ ] **Step 7: 提交当前变更**

```bash
git add frontend/src/features/project/WorkspaceDetailPage.vue frontend/src/features/project/WorkspaceModuleFactory.ts frontend/src/types/module-page.ts frontend/src/test/workspace-detail.spec.ts
git commit -m "feat: add workspace detail experience"
```

### Task 5: 重写项目模块页的工作区治理表达

**Files:**
- Modify: `frontend/src/features/project/ProjectModulePage.vue`
- Modify: `frontend/src/components/ui/ModuleContent.vue`
- Test: `frontend/src/test/module-actions.spec.ts`
- Test: `frontend/src/test/topbar-actions.spec.ts`

- [ ] **Step 1: 写出失败测试覆盖新模块文案与操作**

至少覆盖：
- “成员权限”调整为“成员与角色”
- “Key 管理中心”相关文案消失
- 新增“接入方式”“我的 AI 能力”操作入口

- [ ] **Step 2: 运行测试确认旧文案仍存在导致失败**

Run: `npm test -- src/test/module-actions.spec.ts src/test/topbar-actions.spec.ts`
Expected: FAIL，提示仍渲染旧 `Key` 语义文案或缺少新按钮

- [ ] **Step 3: 精简 `ProjectModulePage.vue`，仅承担项目层模块与工作区跳转职责**

要求：
- 删除旧 `keymanagement` section
- 不再直接包含成员 Key 分配、Key 使用监控等结构
- 将工作区高频体验迁移至 `WorkspaceDetailPage.vue`

- [ ] **Step 4: 如 `ModuleContent.vue` 无法承载新模块，做最小扩展**

要求：
- 仅增加工作区所需的新 section 类型
- 不对现有 section 类型做破坏性重写

- [ ] **Step 5: 重新运行测试验证通过**

Run: `npm test -- src/test/module-actions.spec.ts src/test/topbar-actions.spec.ts`
Expected: PASS

- [ ] **Step 6: 提交当前变更**

```bash
git add frontend/src/features/project/ProjectModulePage.vue frontend/src/components/ui/ModuleContent.vue frontend/src/test/module-actions.spec.ts frontend/src/test/topbar-actions.spec.ts
git commit -m "feat: replace legacy key pages with workspace governance modules"
```

---

## Chunk 3: 旧 Key 原型清理与监控 mock 重命名

### Task 6: 清理旧 Key 监控组件和专用导航逻辑

**Files:**
- Modify or Delete: `frontend/src/components/ui/KeyManagementMonitor.vue`
- Modify or Delete: `frontend/src/composables/useKeyMonitoring.ts`
- Modify or Delete: `frontend/src/composables/usePageNavigation.ts`
- Create: `frontend/src/composables/useWorkspaceMonitoring.ts`
- Test: `frontend/src/tests/key-monitoring.test.ts`
- Test: `frontend/src/test/prototype-menu.spec.ts`

- [ ] **Step 1: 判断旧 Key 监控资产是重命名复用还是直接删除**

判定规则：
- 若界面仍需“工作区使用监控”演示，则重命名并改语义
- 若新页面已不需要独立监控组件，则删除旧文件并更新引用

- [ ] **Step 2: 先修改测试，声明不能再出现成员 Key 分配语义**

Run: `npm test -- src/tests/key-monitoring.test.ts src/test/prototype-menu.spec.ts`
Expected: FAIL，提示仍包含旧 `Key` 监控或菜单关键字

- [ ] **Step 3: 完成清理或重命名实现**

要求：
- 文件名、变量名、日志文案都切换到 `workspace` 语义
- 清除旧 `keymanagement` 路由监听逻辑
- 若创建 `useWorkspaceMonitoring.ts`，其数据应围绕工作区用量、接入状态、告警摘要

- [ ] **Step 4: 重新运行测试验证通过**

Run: `npm test -- src/tests/key-monitoring.test.ts src/test/prototype-menu.spec.ts`
Expected: PASS

- [ ] **Step 5: 提交当前变更**

```bash
git add frontend/src/components/ui frontend/src/composables frontend/src/tests/key-monitoring.test.ts frontend/src/test/prototype-menu.spec.ts
git commit -m "refactor: remove legacy key management monitoring"
```

### Task 7: 更新壳层导航与全局模块命名

**Files:**
- Modify: `frontend/src/components/shell/GlobalSidebar.vue`
- Modify: `frontend/src/components/shell/ProjectSidebar.vue`
- Modify: `frontend/src/features/global/GlobalModulePage.vue`
- Test: `frontend/src/test/app-shell.spec.ts`
- Test: `frontend/src/test/shell.spec.ts`

- [ ] **Step 1: 在测试中更新企业层与项目层导航断言**

至少覆盖：
- 企业层不再出现旧“Key 管理”主语义
- 项目层出现“AI 工作区”入口
- 工作区层入口可达

- [ ] **Step 2: 运行测试确认旧导航造成失败**

Run: `npm test -- src/test/app-shell.spec.ts src/test/shell.spec.ts`
Expected: FAIL

- [ ] **Step 3: 更新侧边栏与全局模块文案**

要求：
- GlobalSidebar 聚焦企业 AI 资源、治理、能力资产
- ProjectSidebar 聚焦项目概览、工作区、项目成员、项目知识资产、项目治理
- 不再出现孤立的旧“Key 管理”入口

- [ ] **Step 4: 重新运行测试验证通过**

Run: `npm test -- src/test/app-shell.spec.ts src/test/shell.spec.ts`
Expected: PASS

- [ ] **Step 5: 提交当前变更**

```bash
git add frontend/src/components/shell/GlobalSidebar.vue frontend/src/components/shell/ProjectSidebar.vue frontend/src/features/global/GlobalModulePage.vue frontend/src/test/app-shell.spec.ts frontend/src/test/shell.spec.ts
git commit -m "feat: align shell navigation with enterprise workspace architecture"
```

---

## Chunk 4: 验证与文档收尾

### Task 8: 补充页面级需求映射并校正文档术语

**Files:**
- Modify: `docs/superpowers/specs/2026-03-18-enterprise-ai-workspace-platform-design.md`
- Modify: `docs/superpowers/plans/2026-03-18-enterprise-ai-workspace-frontend-rebuild.md`

- [ ] **Step 1: 对照实现计划补充页面级术语说明**

至少说明：
- 项目层与工作区层的边界
- 接入方式卡片的展示原则
- 旧 Key 语义为何被移除

- [ ] **Step 2: 确认计划中的文件路径与模块名称与代码保持一致**

Expected: 计划中所有文件路径均真实存在或将在实施中创建

- [ ] **Step 3: 提交文档更新**

```bash
git add docs/superpowers/specs/2026-03-18-enterprise-ai-workspace-platform-design.md docs/superpowers/plans/2026-03-18-enterprise-ai-workspace-frontend-rebuild.md
git commit -m "docs: finalize workspace frontend rebuild plan"
```

### Task 9: 运行定向测试与构建验证

**Files:**
- Modify: `frontend/src/test/router.spec.ts`
- Modify: `frontend/src/test/project-shell.spec.ts`
- Modify: `frontend/src/test/project-entry.spec.ts`
- Modify: `frontend/src/test/prototype-menu.spec.ts`
- Modify: `frontend/src/test/topbar-actions.spec.ts`
- Modify: `frontend/src/test/module-actions.spec.ts`
- Create: `frontend/src/test/workspace-detail.spec.ts`
- Modify or Delete: `frontend/src/tests/key-monitoring.test.ts`

- [ ] **Step 1: 运行工作区相关测试集合**

Run: `npm test -- src/test/router.spec.ts src/test/project-shell.spec.ts src/test/project-entry.spec.ts src/test/prototype-menu.spec.ts src/test/topbar-actions.spec.ts src/test/module-actions.spec.ts src/test/workspace-detail.spec.ts`
Expected: PASS

- [ ] **Step 2: 如保留监控 composable，运行对应测试**

Run: `npm test -- src/tests/key-monitoring.test.ts`
Expected: PASS 或测试文件已删除且无残留引用

- [ ] **Step 3: 运行前端构建**

Run: `npm run build`
Expected: BUILD SUCCESS，产物可生成

- [ ] **Step 4: 记录未覆盖风险**

至少确认：
- 仍未实现后台真实网关
- 当前接入方式仅为前端原型表达
- 工作区监控数据仍为 mock

- [ ] **Step 5: 提交最终实现**

```bash
git add frontend docs
git commit -m "feat: rebuild frontend around enterprise ai workspaces"
```
