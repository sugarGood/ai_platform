# Key管理原型实现计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 在AI平台原型中实现完整的项目级key管理功能，确保所有按钮和交互完全可用

**Architecture:** 基于现有HTML原型扩展，新增项目级key管理页面，增强JavaScript数据管理和交互功能

**Tech Stack:** HTML5, CSS3, JavaScript (ES6+), 现有原型架构

---

## Task 1: 扩展数据模型和Mock数据

**Files:**
- Modify: `ai-platform-prototype.html` (在JavaScript数据区域2800行附近)

**实现要求:**
添加成员key分配关系和使用日志的完整数据模型，包括：
- `memberKeyAssignments` 对象：项目-成员-key的分配关系
- `keyUsageLogs` 数组：key使用记录日志
- 支持多项目、多成员、多key的复杂关系
- 模拟真实的使用统计数据

**验收标准:**
- 数据结构完整，支持商城系统项目的3个key和4个成员
- 包含最近7天的使用日志数据
- 在控制台可以正确访问所有数据
- 提交到git

## Task 2: 添加项目侧边栏Key管理入口

**Files:**
- Modify: `ai-platform-prototype.html` (项目侧边栏区域427-437行)
- Modify: `ai-platform-prototype.html` (JavaScript projPageTitles对象)

**实现要求:**
在项目侧边栏的"配置"区域添加"Key管理中心"入口，确保：
- 在成员权限和Skill配置之间插入
- 图标使用🔑，文本为"Key管理中心"
- 点击可正确跳转到keymanagement页面
- 页面标题正确显示

**验收标准:**
- 项目侧边栏显示Key管理中心入口
- 点击可正确切换页面
- 页面标题显示"项目名 · Key管理中心"
- 侧边栏活跃状态正确切换

## Task 3: 创建Key管理中心主页面

**Files:**
- Modify: `ai-platform-prototype.html` (在项目页面区域添加新页面)

**实现要求:**
创建完整的Key管理中心页面，包含4个核心区域：
- A. Key池总览区：4个统计卡片（总配额、已分配、本月消耗、预估费用）
- B. 成员分配区：成员列表表格，显示分配状态和操作按钮
- C. Key使用监控区：实时使用情况、Top活跃成员、异常告警
- D. 快捷操作区：批量分配、导出报告等功能按钮

**验收标准:**
- 页面结构完整，4个区域布局合理
- 所有文本内容为中文
- 样式与现有页面保持一致
- 表格和卡片结构正确

## Task 4: 实现成员Key分配表格动态填充

**Files:**
- Modify: `ai-platform-prototype.html` (JavaScript函数区域)

**实现要求:**
实现动态渲染成员key分配表格的功能：
- `renderMemberKeyTable()` 函数：根据项目ID渲染成员列表
- 显示每个成员的分配状态、配额、使用量、进度条
- 根据角色显示不同的操作按钮（分配/调整/暂停）
- 页面加载时自动调用渲染函数

**验收标准:**
- 表格正确显示所有成员信息
- 分配状态、配额、使用量数据准确
- 进度条颜色根据使用率变化
- 操作按钮根据成员状态动态显示

## Task 5: 创建成员个人Key视图

**Files:**
- Modify: `ai-platform-prototype.html` (成员管理页面1035行附近)

**实现要求:**
在项目成员管理页面添加"我的Key配置"区域：
- 显示当前用户分配的key信息（脱敏处理）
- 提供Claude/Cursor/Copilot三种工具的配置按钮
- 显示个人使用统计（本月消耗、费用、使用率）
- 智能使用建议和注意事项

**验收标准:**
- 个人key信息正确显示
- 三种工具配置按钮完全可点击
- 点击后能复制对应的配置代码到剪贴板
- 使用统计数据准确显示

## Task 6: 实现Key分配Modal和交互

**Files:**
- Modify: `ai-platform-prototype.html` (页面底部Modal区域)
- Modify: `ai-platform-prototype.html` (JavaScript交互函数)

**实现要求:**
创建完整的Key分配Modal系统：
- 单个分配Modal：选择成员、选择key、设置配额
- 批量分配Modal：按角色分配策略
- 完整的表单验证和数据提交逻辑
- Modal打开/关闭/提交的完整交互

**验收标准:**
- 所有分配相关按钮完全可点击
- Modal正确打开和关闭
- 表单数据正确填充和验证
- 分配成功后数据正确更新并重新渲染

## Task 7: 实现使用监控和统计功能

**Files:**
- Modify: `ai-platform-prototype.html` (JavaScript监控函数)

**实现要求:**
实现完整的使用监控系统：
- 实时使用数据更新函数
- Top活跃成员排行计算和显示
- 异常告警检测和显示
- 定时刷新机制（30秒间隔）
- 导出报告和生成指南功能

**验收标准:**
- 实时监控区域数据每30秒自动更新
- Top活跃成员排行正确计算并显示
- 异常告警根据实际使用情况动态生成
- 导出和生成按钮完全可点击并生成文件

## Task 8: 实现所有按钮的完整交互功能

**Files:**
- Modify: `ai-platform-prototype.html` (JavaScript交互函数)

**实现要求:**
确保页面中每个按钮都有完整的交互功能：
- 分配Key、批量分配、调整、暂停等操作按钮
- 复制配置、查看统计、刷新等功能按钮
- 生成指南、导出报告、设置等工具按钮
- 所有按钮点击都有实际功能或合理的提示

**验收标准:**
- 页面中所有按钮都可以点击
- 每个按钮点击都有明确的功能实现
- 操作结果有适当的用户反馈
- 无任何死链接或无效按钮

## Task 9: 优化样式和响应式设计

**Files:**
- Modify: `ai-platform-prototype.html` (CSS样式区域)

**实现要求:**
优化Key管理相关的样式和布局：
- 添加Key管理专用组件样式
- 实现响应式布局支持
- 增强表格、Modal、进度条等组件视觉效果
- 添加悬停、加载、过渡等交互动画

**验收标准:**
- 所有新增组件样式与现有设计保持一致
- 在不同屏幕尺寸下布局正确
- 交互动画流畅自然
- 视觉层次清晰，用户体验良好

## Task 10: 集成测试和功能验证

**Files:**
- Test: `ai-platform-prototype.html` (完整功能测试)

**实现要求:**
进行完整的端到端功能测试：
- 测试所有用户操作流程
- 验证数据一致性和准确性
- 检查浏览器兼容性
- 修复发现的任何问题

**验收标准:**
- 所有功能流程测试通过
- 数据操作前后一致
- 无JavaScript错误
- 在主流浏览器中正常运行