SET NAMES utf8mb4;
USE `ai_platform`;

-- =========================================================
-- AI Platform 完整库表 v2（基于原型 ai-platform-prototype.html 全量梳理）
-- 日期：2026-03-16
--
-- 结构说明：
--   第一部分：对已有18张表的字段补充（ALTER TABLE）
--   第二部分：新增缺失的业务表（CREATE TABLE）
--
-- 模块划分：
--   A. 组织与用户（departments, users）
--   B. 项目管理（projects, project_members, services）
--   C. 敏捷研发（sprints, epics, tasks）
--   D. CI/CD 与环境（environments, pipeline_runs, pipeline_stages, deployments）
--   E. 事故管理（incidents）
--   F. 知识库（knowledge_documents, project_knowledge_globals）
--   G. AI 能力 - Skill（skills, project_skills）
--   H. AI 能力 - 原子能力（atomic_capabilities, project_atomic_capabilities）
--   I. AI 能力 - 工作流（workflow_definitions, workflow_nodes, workflow_executions, workflow_execution_steps）
--   J. AI 能力 - Tool/Function（tool_definitions, tool_invocation_logs）
--   K. AI 能力 - 评估（ai_eval_scores）
--   L. 模板库（project_templates）
--   M. MCP 配置（project_mcp_configs → 扩展支持服务级）
--   N. 审计安全（security_rules, security_events, audit_logs）
--   O. 活动日志（activity_logs）
--   P. 平台全局设置（platform_settings）
-- =========================================================


-- =============================================================
-- 第一部分：已有表字段补充
-- =============================================================

-- ----- A. users：补充头像、密码、平台角色 -----
ALTER TABLE `users`
  ADD COLUMN `avatar_url` VARCHAR(500) DEFAULT NULL COMMENT '头像URL' AFTER `email`,
  ADD COLUMN `password_hash` VARCHAR(255) DEFAULT NULL COMMENT '登录密码哈希值' AFTER `avatar_url`,
  ADD COLUMN `platform_role` ENUM('SUPER_ADMIN','ADMIN','USER') NOT NULL DEFAULT 'USER' COMMENT '平台角色：超级管理员/管理员/普通用户' AFTER `password_hash`;

-- ----- B. projects：补充部门归属、迭代周期 -----
ALTER TABLE `projects`
  ADD COLUMN `department_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '所属部门ID' AFTER `id`,
  ADD COLUMN `sprint_cycle_weeks` TINYINT UNSIGNED NOT NULL DEFAULT 2 COMMENT '迭代周期（周）：1/2/3' AFTER `branch_strategy`,
  ADD KEY `idx_projects_department_id` (`department_id`),
  ADD CONSTRAINT `fk_projects_department_id`
    FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- ----- B. project_members：补充权限维度 -----
ALTER TABLE `project_members`
  ADD COLUMN `knowledge_access` ENUM('READ_WRITE','READ_ONLY','NONE') NOT NULL DEFAULT 'READ_ONLY' COMMENT '知识库访问权限' AFTER `role`,
  ADD COLUMN `skill_access_scope` VARCHAR(64) NOT NULL DEFAULT 'ALL' COMMENT 'Skill访问范围：ALL/CODE_RELATED/NONE等' AFTER `knowledge_access`,
  ADD COLUMN `mcp_access_enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否允许MCP访问' AFTER `skill_access_scope`;

-- ----- B. services：补充图标字段 -----
ALTER TABLE `services`
  ADD COLUMN `icon` VARCHAR(32) DEFAULT NULL COMMENT '服务图标（emoji或图标名称）' AFTER `name`;

-- ----- M. project_mcp_configs：扩展支持服务级MCP -----
--   原表 project_id UNIQUE，但原型服务详情页每个 service 有独立 MCP 配置
--   方案：去掉 project_id 唯一约束，增加 service_id 字段
ALTER TABLE `project_mcp_configs`
  DROP INDEX `uk_project_mcp_configs_project_id`,
  ADD COLUMN `service_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '服务ID（为空则为项目级MCP）' AFTER `project_id`,
  ADD UNIQUE KEY `uk_project_mcp_configs_project_service` (`project_id`, `service_id`),
  ADD KEY `idx_project_mcp_configs_service_id` (`service_id`),
  ADD CONSTRAINT `fk_project_mcp_configs_service_id`
    FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE;


-- =============================================================
-- 第二部分：新增业务表
-- =============================================================


-- ----- C. 敏捷研发 - 迭代表 -----
-- 原型页面：page-proj-agile（Sprint看板/燃尽图/迭代回顾）
-- 每个项目按迭代周期创建 Sprint，跟踪完成率
CREATE TABLE IF NOT EXISTS `sprints` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` VARCHAR(64) NOT NULL COMMENT '迭代名称，如 Sprint 8',
  `sprint_number` INT UNSIGNED NOT NULL COMMENT '迭代序号',
  `goal` TEXT DEFAULT NULL COMMENT '迭代目标描述',
  `start_date` DATE NOT NULL COMMENT '开始日期',
  `end_date` DATE NOT NULL COMMENT '结束日期',
  `total_story_points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '总故事点数',
  `completed_story_points` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '已完成故事点数',
  `status` ENUM('PLANNING','ACTIVE','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PLANNING' COMMENT '迭代状态',
  `retro_good` TEXT DEFAULT NULL COMMENT '回顾-做得好的（AI生成或手工填写）',
  `retro_improve` TEXT DEFAULT NULL COMMENT '回顾-需改进的',
  `retro_action` TEXT DEFAULT NULL COMMENT '回顾-下Sprint行动项',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sprints_project_number` (`project_id`, `sprint_number`),
  KEY `idx_sprints_status` (`status`),
  CONSTRAINT `fk_sprints_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='迭代（Sprint）表';


-- ----- C. 敏捷研发 - Epic表 -----
-- 原型页面：page-proj-agile Backlog标签页，每个User Story归属一个Epic
CREATE TABLE IF NOT EXISTS `epics` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` VARCHAR(128) NOT NULL COMMENT 'Epic名称，如"搜索优化""购物车""促销系统"',
  `description` TEXT DEFAULT NULL COMMENT 'Epic描述',
  `status` ENUM('OPEN','IN_PROGRESS','DONE','CANCELLED') NOT NULL DEFAULT 'OPEN' COMMENT 'Epic状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_epics_project_name` (`project_id`, `name`),
  CONSTRAINT `fk_epics_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Epic（史诗）表';


-- ----- C. 敏捷研发 - 任务/用户故事表 -----
-- 原型页面：page-proj-agile 看板卡片 + Backlog表格
-- 看板列：待办/进行中/Code Review/测试/完成
CREATE TABLE IF NOT EXISTS `tasks` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID',
  `sprint_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '所属迭代ID（NULL表示在Backlog中）',
  `epic_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '所属Epic ID',
  `title` VARCHAR(255) NOT NULL COMMENT '任务标题/User Story描述',
  `description` TEXT DEFAULT NULL COMMENT '任务详细描述',
  `task_type` ENUM('USER_STORY','TASK','BUG','TECH_DEBT','SPIKE') NOT NULL DEFAULT 'USER_STORY' COMMENT '任务类型',
  `priority` ENUM('P0','P1','P2','P3') NOT NULL DEFAULT 'P1' COMMENT '优先级',
  `story_points` INT UNSIGNED DEFAULT NULL COMMENT '故事点数（SP）',
  `assignee_user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '负责人用户ID',
  `category` VARCHAR(32) DEFAULT NULL COMMENT '分类标签：前端/后端/测试等',
  `kanban_status` ENUM('BACKLOG','TODO','IN_PROGRESS','CODE_REVIEW','TESTING','DONE','CANCELLED') NOT NULL DEFAULT 'BACKLOG' COMMENT '看板列状态',
  `progress_pct` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '进度百分比 0-100',
  `estimated_hours` DECIMAL(6,1) DEFAULT NULL COMMENT '预估工时（小时）',
  `ai_review_status` ENUM('NONE','REVIEWING','APPROVED','ISSUES_FOUND') NOT NULL DEFAULT 'NONE' COMMENT 'AI Review状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_tasks_project_sprint` (`project_id`, `sprint_id`),
  KEY `idx_tasks_epic_id` (`epic_id`),
  KEY `idx_tasks_assignee_user_id` (`assignee_user_id`),
  KEY `idx_tasks_kanban_status` (`kanban_status`),
  CONSTRAINT `fk_tasks_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_sprint_id`
    FOREIGN KEY (`sprint_id`) REFERENCES `sprints` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_epic_id`
    FOREIGN KEY (`epic_id`) REFERENCES `epics` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_tasks_assignee_user_id`
    FOREIGN KEY (`assignee_user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='任务/用户故事表（看板卡片）';


-- ----- D. 环境管理 -----
-- 原型页面：page-envs（全局环境管理）、svc-envs（服务环境tab）
-- 每个环境归属一个服务（DEV/STAGING/PROD各一套）
CREATE TABLE IF NOT EXISTS `environments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `service_id` BIGINT UNSIGNED NOT NULL COMMENT '所属服务ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID（冗余，便于查询）',
  `name` VARCHAR(64) NOT NULL COMMENT '环境名称，如"开发环境""预发布环境""生产环境"',
  `env_type` ENUM('DEV','STAGING','PROD','OTHER') NOT NULL COMMENT '环境类型',
  `url` VARCHAR(255) DEFAULT NULL COMMENT '环境访问地址',
  `current_branch` VARCHAR(128) DEFAULT NULL COMMENT '当前部署的分支',
  `current_version` VARCHAR(64) DEFAULT NULL COMMENT '当前部署的版本号',
  `current_commit` VARCHAR(40) DEFAULT NULL COMMENT '当前部署的commit SHA',
  `deploy_strategy` VARCHAR(128) DEFAULT NULL COMMENT '部署策略描述，如"自动部署·每次Push""手动·需审批"',
  `instance_count` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '实例数（pods数量）',
  `health_status` ENUM('HEALTHY','WARNING','UNHEALTHY','UNKNOWN') NOT NULL DEFAULT 'UNKNOWN' COMMENT '健康状态',
  `last_deploy_at` DATETIME DEFAULT NULL COMMENT '最近部署时间',
  `last_deploy_by` BIGINT UNSIGNED DEFAULT NULL COMMENT '最近部署人用户ID',
  `status` ENUM('ACTIVE','DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '环境状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_environments_service_env_type` (`service_id`, `env_type`),
  KEY `idx_environments_project_id` (`project_id`),
  CONSTRAINT `fk_environments_service_id`
    FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_environments_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_environments_last_deploy_by`
    FOREIGN KEY (`last_deploy_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='服务运行环境表';


-- ----- D. CI/CD 流水线运行记录 -----
-- 原型页面：page-cicd（全局CI/CD）、svc-cicd（服务CI/CD tab）
-- 记录每次构建/部署的流水线整体信息
CREATE TABLE IF NOT EXISTS `pipeline_runs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `service_id` BIGINT UNSIGNED NOT NULL COMMENT '所属服务ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID（冗余，便于全局查询）',
  `branch` VARCHAR(128) NOT NULL COMMENT '触发分支',
  `commit_sha` VARCHAR(40) DEFAULT NULL COMMENT '触发的commit SHA',
  `trigger_type` ENUM('PUSH','MERGE_PR','MANUAL','SCHEDULE','TAG') NOT NULL COMMENT '触发方式',
  `trigger_user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '触发人用户ID',
  `trigger_description` VARCHAR(255) DEFAULT NULL COMMENT '触发描述，如"Merge PR#45"',
  `duration_seconds` INT UNSIGNED DEFAULT NULL COMMENT '总耗时（秒）',
  `status` ENUM('QUEUED','RUNNING','SUCCESS','FAILED','CANCELLED') NOT NULL DEFAULT 'QUEUED' COMMENT '流水线状态',
  `started_at` DATETIME DEFAULT NULL COMMENT '开始执行时间',
  `finished_at` DATETIME DEFAULT NULL COMMENT '完成时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_pipeline_runs_service_id` (`service_id`),
  KEY `idx_pipeline_runs_project_id` (`project_id`),
  KEY `idx_pipeline_runs_status` (`status`),
  KEY `idx_pipeline_runs_trigger_user_id` (`trigger_user_id`),
  CONSTRAINT `fk_pipeline_runs_service_id`
    FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pipeline_runs_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pipeline_runs_trigger_user_id`
    FOREIGN KEY (`trigger_user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CI/CD流水线运行记录表';


-- ----- D. CI/CD 流水线阶段 -----
-- 原型中流水线有多个阶段：构建 → 单测 → 扫描 → 部署，每阶段独立状态
CREATE TABLE IF NOT EXISTS `pipeline_stages` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `pipeline_run_id` BIGINT UNSIGNED NOT NULL COMMENT '所属流水线运行ID',
  `stage_name` VARCHAR(64) NOT NULL COMMENT '阶段名称：构建/单测/扫描/部署等',
  `stage_order` TINYINT UNSIGNED NOT NULL COMMENT '阶段顺序（从1开始）',
  `status` ENUM('PENDING','RUNNING','SUCCESS','FAILED','SKIPPED') NOT NULL DEFAULT 'PENDING' COMMENT '阶段状态',
  `duration_seconds` INT UNSIGNED DEFAULT NULL COMMENT '阶段耗时（秒）',
  `log_url` VARCHAR(500) DEFAULT NULL COMMENT '日志地址',
  `error_message` TEXT DEFAULT NULL COMMENT '失败时的错误信息',
  `started_at` DATETIME DEFAULT NULL COMMENT '开始时间',
  `finished_at` DATETIME DEFAULT NULL COMMENT '完成时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_pipeline_stages_run_order` (`pipeline_run_id`, `stage_order`),
  CONSTRAINT `fk_pipeline_stages_pipeline_run_id`
    FOREIGN KEY (`pipeline_run_id`) REFERENCES `pipeline_runs` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='CI/CD流水线阶段表';


-- ----- D. 部署记录 -----
-- 原型页面：page-envs 部署历史表格
-- 记录每次向某个环境的部署操作
CREATE TABLE IF NOT EXISTS `deployments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `environment_id` BIGINT UNSIGNED NOT NULL COMMENT '目标环境ID',
  `service_id` BIGINT UNSIGNED NOT NULL COMMENT '所属服务ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID（冗余，便于查询）',
  `pipeline_run_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联的流水线ID（手动部署时可为空）',
  `version` VARCHAR(64) DEFAULT NULL COMMENT '部署版本号或分支名',
  `commit_sha` VARCHAR(40) DEFAULT NULL COMMENT '部署的commit SHA',
  `deploy_user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '部署人用户ID',
  `change_description` VARCHAR(500) DEFAULT NULL COMMENT '变更内容描述',
  `duration_seconds` INT UNSIGNED DEFAULT NULL COMMENT '部署耗时（秒）',
  `status` ENUM('PENDING','DEPLOYING','SUCCESS','FAILED','ROLLED_BACK') NOT NULL DEFAULT 'PENDING' COMMENT '部署状态',
  `deployed_at` DATETIME DEFAULT NULL COMMENT '部署完成时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_deployments_environment_id` (`environment_id`),
  KEY `idx_deployments_service_id` (`service_id`),
  KEY `idx_deployments_project_id` (`project_id`),
  KEY `idx_deployments_deploy_user_id` (`deploy_user_id`),
  CONSTRAINT `fk_deployments_environment_id`
    FOREIGN KEY (`environment_id`) REFERENCES `environments` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_deployments_service_id`
    FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_deployments_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_deployments_pipeline_run_id`
    FOREIGN KEY (`pipeline_run_id`) REFERENCES `pipeline_runs` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_deployments_deploy_user_id`
    FOREIGN KEY (`deploy_user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部署记录表';


-- ----- E. 事故管理 -----
-- 原型页面：page-incidents（全局事故中心）、page-proj-incidents（项目事故）
-- 包含错误堆栈、AI诊断结果、处理状态
CREATE TABLE IF NOT EXISTS `incidents` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID',
  `service_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联服务ID',
  `title` VARCHAR(255) NOT NULL COMMENT '事故标题，如"支付服务NullPointerException"',
  `severity` ENUM('CRITICAL','WARNING','INFO') NOT NULL COMMENT '严重级别：严重/警告/提示',
  `status` ENUM('PENDING','IN_PROGRESS','RESOLVED','CLOSED') NOT NULL DEFAULT 'PENDING' COMMENT '处理状态',
  `error_stack` TEXT DEFAULT NULL COMMENT '错误堆栈信息',
  `error_request` VARCHAR(500) DEFAULT NULL COMMENT '触发错误的请求信息',
  `ai_diagnosis` TEXT DEFAULT NULL COMMENT 'AI诊断结果（根因+影响范围+修复建议，JSON或文本）',
  `ai_diagnosis_status` ENUM('NONE','ANALYZING','COMPLETED','FAILED') NOT NULL DEFAULT 'NONE' COMMENT 'AI诊断状态',
  `assignee_user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '负责人用户ID',
  `github_issue_url` VARCHAR(500) DEFAULT NULL COMMENT '关联的GitHub Issue地址',
  `resolved_at` DATETIME DEFAULT NULL COMMENT '解决时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_incidents_project_id` (`project_id`),
  KEY `idx_incidents_service_id` (`service_id`),
  KEY `idx_incidents_severity` (`severity`),
  KEY `idx_incidents_status` (`status`),
  KEY `idx_incidents_assignee_user_id` (`assignee_user_id`),
  CONSTRAINT `fk_incidents_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_incidents_service_id`
    FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_incidents_assignee_user_id`
    FOREIGN KEY (`assignee_user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='事故/告警表';


-- ----- F. 项目启用全局知识库文档（关联表） -----
-- 原型页面：新建项目模态框中勾选全局知识库（代码规范/安全手册等）
-- 记录项目启用了哪些全局知识库文档
CREATE TABLE IF NOT EXISTS `project_knowledge_globals` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `document_id` BIGINT UNSIGNED NOT NULL COMMENT '全局知识库文档ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_knowledge_globals_proj_doc` (`project_id`, `document_id`),
  CONSTRAINT `fk_project_knowledge_globals_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_knowledge_globals_document_id`
    FOREIGN KEY (`document_id`) REFERENCES `knowledge_documents` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目启用的全局知识库文档关联表';


-- ----- G. Skill 定义表 -----
-- 原型页面：page-skills（Skill库，含内置Skill和公司自定义Skill）
-- 如：Code Review、接口文档生成、故障诊断、单元测试生成、SSO集成助手等
CREATE TABLE IF NOT EXISTS `skills` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT 'Skill名称',
  `code` VARCHAR(64) NOT NULL COMMENT 'Skill编码（唯一标识）',
  `description` VARCHAR(500) DEFAULT NULL COMMENT 'Skill描述',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '图标（emoji或图标名称）',
  `skill_type` ENUM('BUILTIN','CUSTOM') NOT NULL DEFAULT 'CUSTOM' COMMENT '类型：内置/公司自定义',
  `scope` ENUM('GLOBAL','PROJECT') NOT NULL DEFAULT 'GLOBAL' COMMENT '作用域：全局可用/项目级',
  `status` ENUM('ACTIVE','DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT 'Skill状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_skills_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Skill（AI技能）定义表';


-- ----- G. 项目-Skill 关联表 -----
-- 原型页面：page-proj-skillconfig（项目Skill配置，启用/禁用Skill）
CREATE TABLE IF NOT EXISTS `project_skills` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `skill_id` BIGINT UNSIGNED NOT NULL COMMENT 'Skill ID',
  `is_enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_skills_proj_skill` (`project_id`, `skill_id`),
  CONSTRAINT `fk_project_skills_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_skills_skill_id`
    FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目Skill启用配置表';


-- ----- H. 原子能力表 -----
-- 原型页面：page-atomic（原子能力库）
-- 如：统一短信服务、邮件推送、OSS存储、SSO认证、支付网关、BI查询
CREATE TABLE IF NOT EXISTS `atomic_capabilities` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT '能力名称',
  `code` VARCHAR(64) NOT NULL COMMENT '能力编码（唯一标识）',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '能力描述',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '图标（emoji或图标名称）',
  `category` ENUM('INFRASTRUCTURE','BUSINESS_PLATFORM','DATA_SERVICE','OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '分类：基础设施/业务中台/数据服务',
  `git_repo_url` VARCHAR(255) DEFAULT NULL COMMENT 'SDK Git仓库地址',
  `git_branch` VARCHAR(64) DEFAULT NULL COMMENT 'Git分支',
  `version` VARCHAR(32) DEFAULT NULL COMMENT '当前版本号',
  `supported_languages` VARCHAR(255) DEFAULT NULL COMMENT '支持的语言/SDK，逗号分隔，如"Java,Node.js,Python"',
  `integration_count` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '已接入项目数（可定期聚合更新）',
  `is_standardized` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已标准化',
  `status` ENUM('ACTIVE','DEPRECATED','DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '能力状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_atomic_capabilities_code` (`code`),
  KEY `idx_atomic_capabilities_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='原子能力库表';


-- ----- H. 项目-原子能力关联表 -----
-- 原型页面：新建项目模态框"关联原子能力"、项目设置页"关联原子能力"
CREATE TABLE IF NOT EXISTS `project_atomic_capabilities` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `capability_id` BIGINT UNSIGNED NOT NULL COMMENT '原子能力ID',
  `integration_status` ENUM('PENDING','INTEGRATED','FAILED') NOT NULL DEFAULT 'PENDING' COMMENT '接入状态',
  `integrated_by` ENUM('MANUAL','AI_GENERATED') NOT NULL DEFAULT 'MANUAL' COMMENT '接入方式：手动/AI自动生成',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_atomic_capabilities_proj_cap` (`project_id`, `capability_id`),
  CONSTRAINT `fk_project_atomic_capabilities_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_atomic_capabilities_capability_id`
    FOREIGN KEY (`capability_id`) REFERENCES `atomic_capabilities` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目关联原子能力表';


-- ----- I. Agent工作流定义表 -----
-- 原型页面：page-workflows（Agent工作流列表+可视化流程图）
-- 如：代码Review Agent、Bug诊断修复Agent、需求拆分Agent、Sprint日报Agent
CREATE TABLE IF NOT EXISTS `workflow_definitions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT '工作流名称',
  `code` VARCHAR(64) NOT NULL COMMENT '工作流编码（唯一标识）',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '工作流描述（展示流程步骤概要）',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '图标',
  `engine_type` VARCHAR(64) NOT NULL DEFAULT 'LANGGRAPH' COMMENT '编排引擎类型，如LangGraph',
  `default_model_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '默认使用的AI模型ID',
  `status` ENUM('ACTIVE','STOPPED','DRAFT') NOT NULL DEFAULT 'DRAFT' COMMENT '工作流状态：运行中/已停用/草稿',
  `created_by` BIGINT UNSIGNED DEFAULT NULL COMMENT '创建人用户ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_definitions_code` (`code`),
  KEY `idx_workflow_definitions_status` (`status`),
  CONSTRAINT `fk_workflow_definitions_default_model_id`
    FOREIGN KEY (`default_model_id`) REFERENCES `ai_models` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_workflow_definitions_created_by`
    FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Agent工作流定义表';


-- ----- I. 工作流节点表 -----
-- 原型中工作流可视化流程图的每个节点
-- 节点类型：触发器/LLM节点/Tool调用/条件分支/Human-in-the-loop
CREATE TABLE IF NOT EXISTS `workflow_nodes` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `workflow_id` BIGINT UNSIGNED NOT NULL COMMENT '所属工作流ID',
  `node_key` VARCHAR(64) NOT NULL COMMENT '节点唯一键（同一工作流内唯一）',
  `node_type` ENUM('TRIGGER','LLM','TOOL','CONDITION','HUMAN','PARALLEL','MERGE') NOT NULL COMMENT '节点类型',
  `label` VARCHAR(128) NOT NULL COMMENT '节点展示标签',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '节点图标',
  `node_order` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '节点排序',
  `config_json` TEXT DEFAULT NULL COMMENT '节点配置（JSON格式，包含模型选择、工具名、条件表达式等）',
  `parent_node_key` VARCHAR(64) DEFAULT NULL COMMENT '父节点键（用于分支结构）',
  `branch_label` VARCHAR(64) DEFAULT NULL COMMENT '分支标签，如"YES·深度审查""NO·标准审查"',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_nodes_wf_key` (`workflow_id`, `node_key`),
  CONSTRAINT `fk_workflow_nodes_workflow_id`
    FOREIGN KEY (`workflow_id`) REFERENCES `workflow_definitions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工作流节点表';


-- ----- I. 工作流执行记录表 -----
-- 原型页面：page-ai-monitor（执行监控 - 实时列表+执行历史）
-- 每次工作流被触发后生成一条执行记录
CREATE TABLE IF NOT EXISTS `workflow_executions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `execution_no` VARCHAR(32) NOT NULL COMMENT '执行编号，如 EX-1042',
  `workflow_id` BIGINT UNSIGNED NOT NULL COMMENT '所属工作流ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联项目ID',
  `trigger_source` VARCHAR(255) DEFAULT NULL COMMENT '触发来源描述，如"mall-backend PR#51""支付服务NPE报警"',
  `current_node_key` VARCHAR(64) DEFAULT NULL COMMENT '当前执行到的节点键',
  `total_steps` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '总步骤数',
  `completed_steps` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '已完成步骤数',
  `total_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '累计消耗Token数',
  `total_cost` DECIMAL(12,4) NOT NULL DEFAULT 0.0000 COMMENT '累计费用',
  `duration_seconds` INT UNSIGNED DEFAULT NULL COMMENT '总耗时（秒）',
  `status` ENUM('RUNNING','WAITING_APPROVAL','SUCCESS','FAILED','CANCELLED','TIMEOUT') NOT NULL DEFAULT 'RUNNING' COMMENT '执行状态',
  `error_message` TEXT DEFAULT NULL COMMENT '失败时的错误信息',
  `started_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开始时间',
  `finished_at` DATETIME DEFAULT NULL COMMENT '完成时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_executions_execution_no` (`execution_no`),
  KEY `idx_workflow_executions_workflow_id` (`workflow_id`),
  KEY `idx_workflow_executions_project_id` (`project_id`),
  KEY `idx_workflow_executions_status` (`status`),
  CONSTRAINT `fk_workflow_executions_workflow_id`
    FOREIGN KEY (`workflow_id`) REFERENCES `workflow_definitions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_workflow_executions_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工作流执行记录表';


-- ----- I. 工作流执行步骤追踪表 -----
-- 原型页面：page-ai-monitor 执行追踪面板（每步有类型、模型、Token、耗时、输出）
CREATE TABLE IF NOT EXISTS `workflow_execution_steps` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `execution_id` BIGINT UNSIGNED NOT NULL COMMENT '所属执行记录ID',
  `node_key` VARCHAR(64) NOT NULL COMMENT '对应的工作流节点键',
  `step_order` INT UNSIGNED NOT NULL COMMENT '步骤执行顺序',
  `node_type` ENUM('TRIGGER','LLM','TOOL','CONDITION','HUMAN','PARALLEL','MERGE') NOT NULL COMMENT '节点类型（冗余，便于查询）',
  `label` VARCHAR(128) DEFAULT NULL COMMENT '步骤标签',
  `model_code` VARCHAR(128) DEFAULT NULL COMMENT '使用的模型编码（LLM节点时有值）',
  `input_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '输入Token数',
  `output_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '输出Token数',
  `duration_ms` INT UNSIGNED DEFAULT NULL COMMENT '耗时（毫秒）',
  `output_text` TEXT DEFAULT NULL COMMENT '步骤输出内容/AI回复/工具调用结果',
  `tool_name` VARCHAR(128) DEFAULT NULL COMMENT 'Tool调用节点的工具名称',
  `tool_input` TEXT DEFAULT NULL COMMENT 'Tool调用的入参（JSON）',
  `status` ENUM('PENDING','RUNNING','SUCCESS','FAILED','SKIPPED','WAITING') NOT NULL DEFAULT 'PENDING' COMMENT '步骤状态',
  `error_message` TEXT DEFAULT NULL COMMENT '失败时的错误信息',
  `started_at` DATETIME DEFAULT NULL COMMENT '开始时间',
  `finished_at` DATETIME DEFAULT NULL COMMENT '完成时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_workflow_execution_steps_execution_id` (`execution_id`),
  KEY `idx_workflow_execution_steps_status` (`status`),
  CONSTRAINT `fk_workflow_execution_steps_execution_id`
    FOREIGN KEY (`execution_id`) REFERENCES `workflow_executions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工作流执行步骤追踪表';


-- ----- J. Tool/Function 定义表 -----
-- 原型页面：page-functions（Function管理台）
-- 如：search_knowledge、get_atomic_capability、create_task、post_review_comment、trigger_deploy、query_metrics
CREATE TABLE IF NOT EXISTS `tool_definitions` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT '工具名称（snake_case），如 search_knowledge',
  `display_name` VARCHAR(128) DEFAULT NULL COMMENT '展示名称',
  `description` TEXT DEFAULT NULL COMMENT '功能描述（AI依据此描述决策是否调用本工具）',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '图标',
  `category` VARCHAR(64) DEFAULT NULL COMMENT '分类：知识库/项目管理/代码操作/部署/监控等',
  `parameters_schema` TEXT DEFAULT NULL COMMENT '入参定义（JSON Schema格式）',
  `return_schema` TEXT DEFAULT NULL COMMENT '返回值结构描述（JSON Schema格式）',
  `requires_approval` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '调用是否需要人工审批（如trigger_deploy生产部署）',
  `quality_score` TINYINT UNSIGNED DEFAULT NULL COMMENT 'Tool描述质量评分 0-100',
  `status` ENUM('ACTIVE','DISABLED','DEPRECATED') NOT NULL DEFAULT 'ACTIVE' COMMENT '工具状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tool_definitions_name` (`name`),
  KEY `idx_tool_definitions_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tool/Function定义表';


-- ----- J. Tool 调用日志表 -----
-- 原型页面：page-functions 调用日志tab
-- 记录每次Tool被Agent/工作流调用的详情
CREATE TABLE IF NOT EXISTS `tool_invocation_logs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tool_id` BIGINT UNSIGNED NOT NULL COMMENT '工具ID',
  `execution_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联工作流执行ID（从工作流调用时）',
  `caller_name` VARCHAR(128) DEFAULT NULL COMMENT '调用来源名称，如"代码Review Agent""Bug诊断Agent"',
  `input_params` TEXT DEFAULT NULL COMMENT '调用入参（JSON）',
  `output_result` TEXT DEFAULT NULL COMMENT '调用返回结果',
  `duration_ms` INT UNSIGNED DEFAULT NULL COMMENT '调用耗时（毫秒）',
  `status` ENUM('SUCCESS','FAILED','TIMEOUT') NOT NULL DEFAULT 'SUCCESS' COMMENT '调用状态',
  `error_message` TEXT DEFAULT NULL COMMENT '失败时的错误信息',
  `invoked_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '调用时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_tool_invocation_logs_tool_id` (`tool_id`),
  KEY `idx_tool_invocation_logs_execution_id` (`execution_id`),
  KEY `idx_tool_invocation_logs_invoked_at` (`invoked_at`),
  KEY `idx_tool_invocation_logs_status` (`status`),
  CONSTRAINT `fk_tool_invocation_logs_tool_id`
    FOREIGN KEY (`tool_id`) REFERENCES `tool_definitions` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_tool_invocation_logs_execution_id`
    FOREIGN KEY (`execution_id`) REFERENCES `workflow_executions` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tool调用日志表';


-- ----- K. AI 评估分数表 -----
-- 原型页面：page-evals（AI评估中心）
-- 记录每个Agent/Skill在每个评估周期的质量分数
-- 如：Code Review准确率91%、Bug诊断准确率87%、需求拆分质量76%、Sprint预测68%
CREATE TABLE IF NOT EXISTS `ai_eval_scores` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `eval_target_type` ENUM('WORKFLOW','SKILL','MODEL') NOT NULL COMMENT '评估对象类型：工作流/Skill/模型',
  `eval_target_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '评估对象ID（workflow_id/skill_id/model_id）',
  `eval_target_name` VARCHAR(128) NOT NULL COMMENT '评估对象名称（冗余，便于展示）',
  `eval_period` VARCHAR(32) NOT NULL COMMENT '评估周期，如"2026-03"',
  `overall_score` DECIMAL(5,2) DEFAULT NULL COMMENT '综合评分 0-100',
  `grade` ENUM('A','B','C','D','F') DEFAULT NULL COMMENT '评级',
  `detail_json` TEXT DEFAULT NULL COMMENT '详细评分维度（JSON格式，如安全漏洞识别率94%，规范违反识别率96%等）',
  `improvement_suggestion` TEXT DEFAULT NULL COMMENT 'AI给出的改进建议',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ai_eval_scores_target_period` (`eval_target_type`, `eval_target_id`, `eval_period`),
  KEY `idx_ai_eval_scores_period` (`eval_period`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI评估分数表';


-- ----- L. 项目模板表 -----
-- 原型页面：page-templates（模板库）
-- 如：React+TypeScript前端模板、Spring Boot微服务模板、Node.js BFF模板、Python数据服务模板
CREATE TABLE IF NOT EXISTS `project_templates` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT '模板名称',
  `code` VARCHAR(64) NOT NULL COMMENT '模板编码（唯一标识）',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '模板描述',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '图标',
  `tech_tags` VARCHAR(255) DEFAULT NULL COMMENT '技术标签，逗号分隔，如"React 18,Vite,Tailwind"',
  `git_repo_url` VARCHAR(255) DEFAULT NULL COMMENT '模板Git仓库地址',
  `template_type` ENUM('BUILTIN','CUSTOM') NOT NULL DEFAULT 'BUILTIN' COMMENT '模板类型：内置/自定义上传',
  `status` ENUM('ACTIVE','DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '模板状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_templates_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目模板库表';


-- ----- N. 安全规则表 -----
-- 原型页面：page-audit 安全规则列表
-- 如：敏感信息过滤、代码外传检测、Prompt注入防护、合规审计日志
CREATE TABLE IF NOT EXISTS `security_rules` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT '规则名称',
  `code` VARCHAR(64) NOT NULL COMMENT '规则编码（唯一标识）',
  `description` VARCHAR(500) DEFAULT NULL COMMENT '规则描述',
  `rule_type` ENUM('CONTENT_FILTER','LEAK_DETECTION','INJECTION_PROTECTION','COMPLIANCE_LOG','OTHER') NOT NULL COMMENT '规则类型',
  `is_enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用',
  `config_json` TEXT DEFAULT NULL COMMENT '规则配置（JSON格式）',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_security_rules_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='安全规则表';


-- ----- N. 安全事件表 -----
-- 原型页面：page-audit 近7日安全事件列表
-- 如：API Key泄露风险、非常用地点登录、Token异常突增
CREATE TABLE IF NOT EXISTS `security_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `rule_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '触发的安全规则ID',
  `title` VARCHAR(255) NOT NULL COMMENT '事件标题',
  `severity` ENUM('CRITICAL','WARNING','INFO') NOT NULL COMMENT '严重级别',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联用户ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联项目ID',
  `description` TEXT DEFAULT NULL COMMENT '事件详情',
  `resolution_status` ENUM('PENDING','AUTO_HANDLED','MANUALLY_VERIFIED','DISMISSED') NOT NULL DEFAULT 'PENDING' COMMENT '处理状态',
  `resolution_note` VARCHAR(500) DEFAULT NULL COMMENT '处理说明，如"已自动屏蔽""已验证通过"',
  `occurred_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '事件发生时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_security_events_rule_id` (`rule_id`),
  KEY `idx_security_events_user_id` (`user_id`),
  KEY `idx_security_events_project_id` (`project_id`),
  KEY `idx_security_events_severity` (`severity`),
  KEY `idx_security_events_occurred_at` (`occurred_at`),
  CONSTRAINT `fk_security_events_rule_id`
    FOREIGN KEY (`rule_id`) REFERENCES `security_rules` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_security_events_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_security_events_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='安全事件表';


-- ----- N. 操作审计日志表 -----
-- 原型页面：page-audit 操作审计日志表格
-- 记录所有平台操作（AI对话含敏感词、新增成员、MCP接入、上传文档等）
CREATE TABLE IF NOT EXISTS `audit_logs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '操作用户ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联项目ID',
  `action` VARCHAR(128) NOT NULL COMMENT '操作类型，如"AI对话含敏感词""新增成员权限""MCP接入""上传文档"',
  `target_type` VARCHAR(64) DEFAULT NULL COMMENT '操作对象类型，如"project_member""knowledge_document"',
  `target_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '操作对象ID',
  `detail` TEXT DEFAULT NULL COMMENT '操作详情（JSON或文本）',
  `result` ENUM('SUCCESS','FILTERED','BLOCKED','FAILED') NOT NULL DEFAULT 'SUCCESS' COMMENT '操作结果',
  `ip_address` VARCHAR(45) DEFAULT NULL COMMENT '操作IP地址',
  `user_agent` VARCHAR(500) DEFAULT NULL COMMENT '客户端信息',
  `occurred_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_audit_logs_user_id` (`user_id`),
  KEY `idx_audit_logs_project_id` (`project_id`),
  KEY `idx_audit_logs_action` (`action`),
  KEY `idx_audit_logs_occurred_at` (`occurred_at`),
  CONSTRAINT `fk_audit_logs_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_audit_logs_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作审计日志表';


-- ----- O. 活动日志表 -----
-- 原型页面：page-dashboard 项目活动时间线、page-proj-overview 项目活动时间线
-- 记录用户和AI的各类操作活动，用于时间线展示
CREATE TABLE IF NOT EXISTS `activity_logs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '关联项目ID',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '操作用户ID（AI操作时为空）',
  `actor_name` VARCHAR(64) DEFAULT NULL COMMENT '操作者名称（冗余，含AI名称）',
  `action_type` VARCHAR(64) NOT NULL COMMENT '动作类型：push_code/upload_doc/mcp_connect/create_project/ai_review/deploy等',
  `summary` VARCHAR(500) NOT NULL COMMENT '活动摘要，如"李四推送代码到mall-backend/feature/search"',
  `target_type` VARCHAR(64) DEFAULT NULL COMMENT '目标对象类型，如 service/document/project',
  `target_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '目标对象ID',
  `target_name` VARCHAR(128) DEFAULT NULL COMMENT '目标对象名称（冗余，便于展示）',
  `occurred_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '活动发生时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_activity_logs_project_id` (`project_id`),
  KEY `idx_activity_logs_user_id` (`user_id`),
  KEY `idx_activity_logs_occurred_at` (`occurred_at`),
  CONSTRAINT `fk_activity_logs_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_activity_logs_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动日志表（时间线）';


-- ----- P. 平台全局设置表 -----
-- 原型页面：page-settings（全局设置-大模型接入配置、全局Token策略）
-- 使用 key-value 方式存储全局配置项
CREATE TABLE IF NOT EXISTS `platform_settings` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `setting_key` VARCHAR(128) NOT NULL COMMENT '配置键，如"primary_model_id""monthly_total_quota""default_user_quota""over_quota_strategy"',
  `setting_value` TEXT DEFAULT NULL COMMENT '配置值',
  `setting_group` VARCHAR(64) NOT NULL DEFAULT 'GENERAL' COMMENT '配置分组：MODEL_CONFIG/TOKEN_POLICY/GENERAL',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '配置项说明',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_platform_settings_key` (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台全局设置表';


-- =============================================================
-- 第三部分：初始数据
-- =============================================================

-- 初始化内置Skill
INSERT INTO `skills` (`name`, `code`, `description`, `icon`, `skill_type`, `scope`, `status`)
VALUES
  ('Code Review', 'CODE_REVIEW', '自动审查代码质量、安全、性能', '🔍', 'BUILTIN', 'GLOBAL', 'ACTIVE'),
  ('接口文档生成', 'API_DOC_GEN', '代码→OpenAPI文档自动生成', '📝', 'BUILTIN', 'GLOBAL', 'ACTIVE'),
  ('故障诊断', 'BUG_DIAGNOSIS', '日志分析、根因定位、修复建议', '🚨', 'BUILTIN', 'GLOBAL', 'ACTIVE'),
  ('单元测试生成', 'UNIT_TEST_GEN', '根据代码自动生成单元测试用例', '✅', 'BUILTIN', 'GLOBAL', 'ACTIVE'),
  ('SSO 集成助手', 'SSO_INTEGRATION', '一键生成公司SSO对接代码', '🔐', 'CUSTOM', 'GLOBAL', 'ACTIVE'),
  ('Git提交规范检查', 'GIT_COMMIT_CHECK', '确保commit message符合公司规范', '🏷️', 'CUSTOM', 'GLOBAL', 'ACTIVE'),
  ('BI 数据查询', 'BI_QUERY', '用自然语言查询公司BI数据', '📊', 'CUSTOM', 'GLOBAL', 'ACTIVE')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `updated_at` = CURRENT_TIMESTAMP;

-- 初始化内置项目模板
INSERT INTO `project_templates` (`name`, `code`, `description`, `icon`, `tech_tags`, `template_type`, `status`)
VALUES
  ('React + TypeScript 前端模板', 'REACT_TS', '含路由、状态管理、组件库、CI/CD、ESLint、单元测试', '⚛️', 'React 18,Vite,Tailwind', 'BUILTIN', 'ACTIVE'),
  ('Spring Boot 微服务模板', 'SPRING_BOOT', '含SSO对接、统一异常处理、日志规范、Swagger、Docker', '🍃', 'Spring Boot 3,MySQL', 'BUILTIN', 'ACTIVE'),
  ('Node.js BFF 模板', 'NODE_BFF', '含接口聚合、鉴权中间件、Redis缓存、限流、Jest测试', '🟢', 'Node 20,Fastify', 'BUILTIN', 'ACTIVE'),
  ('Python 数据服务模板', 'PYTHON_DATA', '含FastAPI、数据处理管道、Celery异步任务、Pytest', '🐍', 'Python 3.12,FastAPI', 'BUILTIN', 'ACTIVE')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `updated_at` = CURRENT_TIMESTAMP;

-- 初始化原子能力
INSERT INTO `atomic_capabilities` (`name`, `code`, `description`, `icon`, `category`, `git_repo_url`, `git_branch`, `version`, `supported_languages`, `integration_count`, `is_standardized`, `status`)
VALUES
  ('统一短信服务', 'SMS', '支持阿里云/腾讯云短信，统一接口，自动降级切换', '📨', 'INFRASTRUCTURE', 'git.company.com/platform/sms-sdk', 'main', 'v2.3.1', 'Java,Node.js,Python', 12, 0, 'ACTIVE'),
  ('邮件推送服务', 'MAIL', '模板邮件、HTML邮件、附件支持，自动重试机制', '📧', 'INFRASTRUCTURE', 'git.company.com/platform/mail-sdk', 'main', 'v1.8.0', 'Java,Node.js', 8, 0, 'ACTIVE'),
  ('对象存储 OSS', 'OSS', '文件上传下载、CDN加速、图片压缩裁剪、权限控制', '🗄️', 'INFRASTRUCTURE', 'git.company.com/platform/oss-sdk', 'main', 'v3.1.2', 'Java,Node.js,Python', 15, 0, 'ACTIVE'),
  ('统一身份认证 SSO', 'SSO', 'OIDC/OAuth2标准，支持MFA，会话管理，RBAC权限', '🔐', 'BUSINESS_PLATFORM', 'git.company.com/platform/sso-client', 'main', 'v4.0.3', 'Java,Node.js,React,Vue', 18, 1, 'ACTIVE'),
  ('统一支付网关', 'PAYMENT', '微信/支付宝/银联，退款、对账、风控一体化', '💳', 'BUSINESS_PLATFORM', 'git.company.com/platform/pay-sdk', 'release-2.x', 'v2.5.1', 'Java,Node.js', 6, 0, 'ACTIVE'),
  ('BI 数据查询服务', 'BI_QUERY', '自然语言查询业务数据，自动生成SQL，结果可视化', '📊', 'DATA_SERVICE', 'git.company.com/platform/bi-query', 'main', 'v1.2.0', 'REST API,GraphQL', 9, 0, 'ACTIVE')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `updated_at` = CURRENT_TIMESTAMP;

-- 初始化安全规则
INSERT INTO `security_rules` (`name`, `code`, `description`, `rule_type`, `is_enabled`)
VALUES
  ('敏感信息过滤', 'SENSITIVE_FILTER', '自动检测并屏蔽API Key、密码、身份证号等敏感信息', 'CONTENT_FILTER', 1),
  ('代码外传检测', 'CODE_LEAK_DETECT', '阻止核心业务代码被发送到外部AI服务', 'LEAK_DETECTION', 1),
  ('Prompt 注入防护', 'PROMPT_INJECTION', '检测并阻断恶意Prompt注入攻击', 'INJECTION_PROTECTION', 1),
  ('合规审计日志', 'COMPLIANCE_LOG', '记录所有AI对话，保留180天，支持合规审查', 'COMPLIANCE_LOG', 0)
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `updated_at` = CURRENT_TIMESTAMP;

-- 初始化内置Tool定义
INSERT INTO `tool_definitions` (`name`, `display_name`, `description`, `icon`, `category`, `requires_approval`, `status`)
VALUES
  ('search_knowledge', '知识库搜索', '语义搜索项目知识库、全局规范文档和历史技术方案。当需要查找需求文档、代码规范、架构说明时调用此工具。', '🔍', '知识库', 0, 'ACTIVE'),
  ('get_atomic_capability', '获取原子能力', '根据能力名称获取Git地址、接入文档和示例代码', '⚛️', '原子能力', 0, 'ACTIVE'),
  ('create_task', '创建任务', '在指定项目和Sprint中创建任务，支持负责人、优先级、Story Points', '📋', '项目管理', 0, 'ACTIVE'),
  ('post_review_comment', '发布Review评论', '向指定PR发布Code Review评论，支持行内评论和总体评论', '💬', '代码操作', 0, 'ACTIVE'),
  ('trigger_deploy', '触发部署', '触发指定服务在指定环境的部署，生产环境走Human-in-the-loop审批节点', '🚀', '部署', 1, 'ACTIVE'),
  ('query_metrics', '查询监控指标', '查询服务运行指标：错误率、P99延迟、QPS、日志关键词', '📊', '监控', 0, 'ACTIVE'),
  ('report_bug', '上报Bug', '在IDE中直接创建事故任务', '🚨', '项目管理', 0, 'ACTIVE')
ON DUPLICATE KEY UPDATE `display_name` = VALUES(`display_name`), `updated_at` = CURRENT_TIMESTAMP;

-- 初始化工作流定义
INSERT INTO `workflow_definitions` (`name`, `code`, `description`, `icon`, `engine_type`, `status`)
VALUES
  ('代码 Review Agent', 'CODE_REVIEW_AGENT', 'PR创建→理解变更→搜索规范→条件审查→发布评论→人工确认', '🔍', 'LANGGRAPH', 'ACTIVE'),
  ('Bug 诊断修复 Agent', 'BUG_FIX_AGENT', '报警触发→日志分析→定位根因→生成修复代码→人工确认→提PR', '🐛', 'LANGGRAPH', 'ACTIVE'),
  ('需求拆分 Agent', 'PRD_SPLIT_AGENT', 'PRD上传→解析需求→识别模块→并行拆分Story→估算SP→写入Backlog', '📋', 'LANGGRAPH', 'ACTIVE'),
  ('AI 接入原子能力 Agent', 'ATOMIC_INTEGRATION_AGENT', '读取能力文档→分析技术栈→生成接入代码→写入单测→人工确认', '🚀', 'LANGGRAPH', 'ACTIVE'),
  ('Sprint 日报 Agent', 'SPRINT_DAILY_AGENT', '定时触发→汇聚各项目数据→生成摘要→并行发送通知', '📊', 'LANGGRAPH', 'ACTIVE'),
  ('接口文档同步 Agent', 'API_DOC_SYNC_AGENT', '代码变更检测→解析注解→生成OpenAPI→推送知识库', '🔌', 'LANGGRAPH', 'STOPPED')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `updated_at` = CURRENT_TIMESTAMP;

-- 初始化全局设置
INSERT INTO `platform_settings` (`setting_key`, `setting_value`, `setting_group`, `description`)
VALUES
  ('primary_provider_id', NULL, 'MODEL_CONFIG', '主模型厂商ID'),
  ('primary_model_id', NULL, 'MODEL_CONFIG', '主模型ID'),
  ('fallback_provider_id', NULL, 'MODEL_CONFIG', '备用模型厂商ID'),
  ('fallback_model_id', NULL, 'MODEL_CONFIG', '备用模型ID'),
  ('monthly_total_quota_tokens', '10000000', 'TOKEN_POLICY', '公司月总Token配额'),
  ('default_user_monthly_quota_tokens', '500000', 'TOKEN_POLICY', '默认员工月Token配额'),
  ('over_quota_strategy', 'DOWNGRADE_MODEL', 'TOKEN_POLICY', '超配额策略：BLOCK/DOWNGRADE_MODEL/NOTIFY_ADMIN')
ON DUPLICATE KEY UPDATE `description` = VALUES(`description`), `updated_at` = CURRENT_TIMESTAMP;
