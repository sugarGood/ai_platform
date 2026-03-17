SET NAMES utf8mb4;
USE `ai_platform`;

-- =========================================================
-- AI Platform 核心库表（单租户 MVP）
-- 范围：
-- 1. 组织 / 用户 / 项目 / 服务 / 文档
-- 2. 项目级 MCP 接入
-- 3. AI 厂商 / 模型 / 平台托管密钥
-- 4. 项目 AI 策略 / 成员额度 / 用量监控
-- 5. Cursor / Claude Code / Codex / Gemini CLI / OpenCode 适配
-- =========================================================

CREATE TABLE IF NOT EXISTS `departments` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(64) NOT NULL COMMENT '部门名称',
  `code` VARCHAR(64) DEFAULT NULL COMMENT '部门编码',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '部门描述',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '部门状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_departments_code` (`code`),
  UNIQUE KEY `uk_departments_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='部门表';

CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `department_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '所属部门ID',
  `username` VARCHAR(64) NOT NULL COMMENT '登录用户名',
  `real_name` VARCHAR(64) NOT NULL COMMENT '真实姓名',
  `email` VARCHAR(128) DEFAULT NULL COMMENT '邮箱',
  `mobile` VARCHAR(32) DEFAULT NULL COMMENT '手机号',
  `job_title` VARCHAR(64) DEFAULT NULL COMMENT '岗位名称',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '用户状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_username` (`username`),
  UNIQUE KEY `uk_users_email` (`email`),
  KEY `idx_users_department_id` (`department_id`),
  CONSTRAINT `fk_users_department_id`
    FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台用户表';

CREATE TABLE IF NOT EXISTS `projects` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(128) NOT NULL COMMENT '项目名称',
  `code` VARCHAR(64) NOT NULL COMMENT '项目编码',
  `project_type` ENUM('PRODUCT', 'INTERNAL_SYSTEM', 'TECH_PLATFORM', 'DATA_PRODUCT') NOT NULL COMMENT '项目类型',
  `description` TEXT DEFAULT NULL COMMENT '项目描述',
  `icon` VARCHAR(32) DEFAULT NULL COMMENT '项目图标或表情',
  `status` ENUM('ACTIVE', 'PENDING_LAUNCH', 'COMPLETED', 'ARCHIVED') NOT NULL DEFAULT 'ACTIVE' COMMENT '项目状态',
  `branch_strategy` ENUM('GIT_FLOW', 'TRUNK_BASED', 'FEATURE_BRANCH') NOT NULL DEFAULT 'TRUNK_BASED' COMMENT '分支策略',
  `owner_user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '项目负责人用户ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_projects_code` (`code`),
  UNIQUE KEY `uk_projects_name` (`name`),
  KEY `idx_projects_owner_user_id` (`owner_user_id`),
  CONSTRAINT `fk_projects_owner_user_id`
    FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目表';

CREATE TABLE IF NOT EXISTS `project_members` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `user_id` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
  `role` ENUM('PROJECT_OWNER', 'PRODUCT_MANAGER', 'TECH_LEAD', 'DEVELOPER', 'TESTER', 'VIEWER') NOT NULL COMMENT '项目角色',
  `status` ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE' COMMENT '成员状态',
  `joined_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_members_project_user` (`project_id`, `user_id`),
  KEY `idx_project_members_user_id` (`user_id`),
  KEY `idx_project_members_role` (`role`),
  CONSTRAINT `fk_project_members_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_members_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目成员与固定角色表';

CREATE TABLE IF NOT EXISTS `services` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '所属项目ID',
  `name` VARCHAR(128) NOT NULL COMMENT '服务名称',
  `service_type` ENUM('FRONTEND', 'BACKEND', 'MOBILE', 'BFF', 'DATA_SERVICE', 'OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '服务类型',
  `tech_stack` VARCHAR(255) DEFAULT NULL COMMENT '技术栈',
  `git_repo_url` VARCHAR(255) DEFAULT NULL COMMENT '代码仓库地址',
  `default_branch` VARCHAR(64) NOT NULL DEFAULT 'main' COMMENT '默认分支',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '服务描述',
  `status` ENUM('ACTIVE', 'DISABLED', 'ARCHIVED') NOT NULL DEFAULT 'ACTIVE' COMMENT '服务状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_services_project_name` (`project_id`, `name`),
  KEY `idx_services_project_id` (`project_id`),
  CONSTRAINT `fk_services_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目服务与代码仓库表';

CREATE TABLE IF NOT EXISTS `knowledge_documents` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `scope_type` ENUM('GLOBAL', 'PROJECT') NOT NULL COMMENT '知识库范围',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '项目范围下的项目ID',
  `title` VARCHAR(255) NOT NULL COMMENT '文档标题',
  `document_type` ENUM('REQUIREMENT', 'PROTOTYPE', 'TECHNICAL', 'BUSINESS', 'SPEC', 'OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '文档类型',
  `source_type` ENUM('MANUAL_UPLOAD', 'AI_GENERATED', 'SYNCED') NOT NULL DEFAULT 'MANUAL_UPLOAD' COMMENT '文档来源',
  `storage_url` VARCHAR(500) NOT NULL COMMENT '对象存储地址或路径',
  `file_name` VARCHAR(255) DEFAULT NULL COMMENT '原始文件名',
  `file_ext` VARCHAR(32) DEFAULT NULL COMMENT '文件扩展名',
  `size_bytes` BIGINT UNSIGNED DEFAULT NULL COMMENT '文件字节大小',
  `uploaded_by` BIGINT UNSIGNED DEFAULT NULL COMMENT '上传人用户ID',
  `status` ENUM('ACTIVE', 'ARCHIVED') NOT NULL DEFAULT 'ACTIVE' COMMENT '文档状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_knowledge_documents_project_id` (`project_id`),
  KEY `idx_knowledge_documents_scope_type` (`scope_type`),
  KEY `idx_knowledge_documents_document_type` (`document_type`),
  KEY `idx_knowledge_documents_uploaded_by` (`uploaded_by`),
  CONSTRAINT `fk_knowledge_documents_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_knowledge_documents_uploaded_by`
    FOREIGN KEY (`uploaded_by`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='全局与项目知识文档表';

CREATE TABLE IF NOT EXISTS `client_apps` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` VARCHAR(64) NOT NULL COMMENT '客户端编码',
  `name` VARCHAR(128) NOT NULL COMMENT '客户端名称',
  `supports_mcp` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否支持模型上下文协议',
  `supports_custom_gateway` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否支持自定义网关',
  `supports_usage_sync` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否支持用量同步',
  `supports_oauth` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否支持开放授权认证',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '客户端状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_client_apps_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='支持接入的研发客户端表';

CREATE TABLE IF NOT EXISTS `project_client_policies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `client_app_id` BIGINT UNSIGNED NOT NULL COMMENT '客户端ID',
  `control_mode` ENUM('FULLY_MANAGED', 'FEDERATED_MANAGED', 'ACCOUNT_MANAGED') NOT NULL DEFAULT 'ACCOUNT_MANAGED' COMMENT '客户端治理模式',
  `usage_source` ENUM('PLATFORM_GATEWAY', 'CLIENT_ADMIN_API', 'VENDOR_USAGE_API', 'MANUAL') NOT NULL DEFAULT 'MANUAL' COMMENT '用量来源',
  `auth_mode` ENUM('PLATFORM_TOKEN', 'WORKSPACE_LOGIN', 'PROVIDER_API_KEY', 'CUSTOM_GATEWAY', 'VERTEX_AI', 'AWS_BEDROCK', 'OAUTH') NOT NULL DEFAULT 'PLATFORM_TOKEN' COMMENT '认证方式',
  `mcp_enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用项目协议接入',
  `external_workspace_id` VARCHAR(128) DEFAULT NULL COMMENT '外部团队或工作区ID',
  `external_workspace_name` VARCHAR(128) DEFAULT NULL COMMENT '外部团队或工作区名称',
  `extra_config` TEXT DEFAULT NULL COMMENT '额外配置文本',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '策略状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_client_policies_project_client` (`project_id`, `client_app_id`),
  KEY `idx_project_client_policies_client_app_id` (`client_app_id`),
  CONSTRAINT `fk_project_client_policies_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_client_policies_client_app_id`
    FOREIGN KEY (`client_app_id`) REFERENCES `client_apps` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目客户端接入策略表';

CREATE TABLE IF NOT EXISTS `user_client_bindings` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
  `client_app_id` BIGINT UNSIGNED NOT NULL COMMENT '客户端ID',
  `auth_mode` ENUM('PLATFORM_TOKEN', 'WORKSPACE_LOGIN', 'PROVIDER_API_KEY', 'CUSTOM_GATEWAY', 'VERTEX_AI', 'AWS_BEDROCK', 'OAUTH') NOT NULL DEFAULT 'PLATFORM_TOKEN' COMMENT '用户认证方式',
  `external_account_id` VARCHAR(128) DEFAULT NULL COMMENT '外部账号ID',
  `external_workspace_id` VARCHAR(128) DEFAULT NULL COMMENT '外部工作区或团队ID',
  `binding_status` ENUM('PENDING', 'ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'PENDING' COMMENT '绑定状态',
  `last_authenticated_at` DATETIME DEFAULT NULL COMMENT '最近成功认证时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_client_bindings_user_client` (`user_id`, `client_app_id`),
  KEY `idx_user_client_bindings_client_app_id` (`client_app_id`),
  KEY `idx_user_client_bindings_external_workspace_id` (`external_workspace_id`),
  CONSTRAINT `fk_user_client_bindings_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_user_client_bindings_client_app_id`
    FOREIGN KEY (`client_app_id`) REFERENCES `client_apps` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户与研发客户端绑定表';

CREATE TABLE IF NOT EXISTS `ai_providers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `code` VARCHAR(64) NOT NULL COMMENT '厂商编码',
  `name` VARCHAR(128) NOT NULL COMMENT '厂商名称',
  `provider_type` ENUM('OPENAI', 'ANTHROPIC', 'GOOGLE', 'AZURE_OPENAI', 'AWS_BEDROCK', 'OPENAI_COMPATIBLE', 'OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '厂商类别',
  `base_url` VARCHAR(255) DEFAULT NULL COMMENT '基础访问地址',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '厂商状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ai_providers_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI厂商表';

CREATE TABLE IF NOT EXISTS `ai_models` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `provider_id` BIGINT UNSIGNED NOT NULL COMMENT '厂商ID',
  `code` VARCHAR(128) NOT NULL COMMENT '模型编码',
  `name` VARCHAR(128) NOT NULL COMMENT '模型名称',
  `model_family` VARCHAR(64) DEFAULT NULL COMMENT '模型家族',
  `context_window` INT UNSIGNED DEFAULT NULL COMMENT '上下文窗口大小',
  `input_price_per_1m` DECIMAL(12, 6) DEFAULT NULL COMMENT '每百万输入令牌价格',
  `output_price_per_1m` DECIMAL(12, 6) DEFAULT NULL COMMENT '每百万输出令牌价格',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '模型状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ai_models_provider_code` (`provider_id`, `code`),
  KEY `idx_ai_models_model_family` (`model_family`),
  CONSTRAINT `fk_ai_models_provider_id`
    FOREIGN KEY (`provider_id`) REFERENCES `ai_providers` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI模型表';

CREATE TABLE IF NOT EXISTS `provider_api_keys` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `provider_id` BIGINT UNSIGNED NOT NULL COMMENT '厂商ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '项目专属时绑定的项目ID',
  `name` VARCHAR(128) NOT NULL COMMENT '密钥名称',
  `secret_ciphertext` TEXT NOT NULL COMMENT '加密后的厂商接口密钥',
  `secret_masked` VARCHAR(64) NOT NULL COMMENT '用于展示的脱敏密钥',
  `key_scope` ENUM('PLATFORM', 'PROJECT_EXCLUSIVE') NOT NULL DEFAULT 'PLATFORM' COMMENT '密钥作用域',
  `status` ENUM('ACTIVE', 'DISABLED', 'REVOKED') NOT NULL DEFAULT 'ACTIVE' COMMENT '密钥状态',
  `last_used_at` DATETIME DEFAULT NULL COMMENT '最近使用时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_provider_api_keys_provider_name` (`provider_id`, `name`),
  KEY `idx_provider_api_keys_project_id` (`project_id`),
  CONSTRAINT `fk_provider_api_keys_provider_id`
    FOREIGN KEY (`provider_id`) REFERENCES `ai_providers` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_provider_api_keys_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='平台托管上游API密钥表';

CREATE TABLE IF NOT EXISTS `project_ai_policies` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `default_provider_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '默认厂商ID',
  `default_model_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '默认模型ID',
  `fallback_provider_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '降级厂商ID',
  `fallback_model_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '降级模型ID',
  `monthly_token_quota` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '项目月度令牌额度',
  `monthly_cost_quota` DECIMAL(14, 2) NOT NULL DEFAULT 0.00 COMMENT '项目月度费用额度',
  `over_quota_strategy` ENUM('BLOCK', 'ALLOW_WITH_ALERT', 'DOWNGRADE_MODEL') NOT NULL DEFAULT 'BLOCK' COMMENT '超额处理策略',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '策略状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_ai_policies_project_id` (`project_id`),
  KEY `idx_project_ai_policies_default_provider_id` (`default_provider_id`),
  KEY `idx_project_ai_policies_default_model_id` (`default_model_id`),
  KEY `idx_project_ai_policies_fallback_provider_id` (`fallback_provider_id`),
  KEY `idx_project_ai_policies_fallback_model_id` (`fallback_model_id`),
  CONSTRAINT `fk_project_ai_policies_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_ai_policies_default_provider_id`
    FOREIGN KEY (`default_provider_id`) REFERENCES `ai_providers` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_project_ai_policies_default_model_id`
    FOREIGN KEY (`default_model_id`) REFERENCES `ai_models` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_project_ai_policies_fallback_provider_id`
    FOREIGN KEY (`fallback_provider_id`) REFERENCES `ai_providers` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_project_ai_policies_fallback_model_id`
    FOREIGN KEY (`fallback_model_id`) REFERENCES `ai_models` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目级AI路由与额度策略表';

CREATE TABLE IF NOT EXISTS `project_member_ai_quotas` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `user_id` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
  `monthly_token_quota` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '成员月度令牌额度',
  `monthly_cost_quota` DECIMAL(14, 2) NOT NULL DEFAULT 0.00 COMMENT '成员月度费用额度',
  `enforcement_level` ENUM('HARD_ENFORCED', 'SOFT_LIMITED', 'OBSERVE_ONLY') NOT NULL DEFAULT 'HARD_ENFORCED' COMMENT '额度控制级别',
  `is_enabled` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用成员AI能力',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_member_ai_quotas_project_user` (`project_id`, `user_id`),
  KEY `idx_project_member_ai_quotas_user_id` (`user_id`),
  CONSTRAINT `fk_project_member_ai_quotas_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_project_member_ai_quotas_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目成员AI额度表';

CREATE TABLE IF NOT EXISTS `platform_access_tokens` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '项目范围令牌对应的项目ID',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '用户范围令牌对应的用户ID',
  `client_app_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '客户端专属令牌对应的客户端ID',
  `token_name` VARCHAR(128) NOT NULL COMMENT '令牌名称',
  `token_type` ENUM('PROJECT_MCP', 'AI_GATEWAY', 'CLIENT_BOOTSTRAP') NOT NULL COMMENT '令牌类型',
  `token_prefix` VARCHAR(32) NOT NULL COMMENT '展示用令牌前缀',
  `token_hash` CHAR(64) NOT NULL COMMENT '令牌哈希值',
  `expires_at` DATETIME DEFAULT NULL COMMENT '过期时间',
  `last_used_at` DATETIME DEFAULT NULL COMMENT '最近使用时间',
  `status` ENUM('ACTIVE', 'REVOKED', 'EXPIRED') NOT NULL DEFAULT 'ACTIVE' COMMENT '令牌状态',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_platform_access_tokens_token_prefix` (`token_prefix`),
  UNIQUE KEY `uk_platform_access_tokens_token_hash` (`token_hash`),
  KEY `idx_platform_access_tokens_project_id` (`project_id`),
  KEY `idx_platform_access_tokens_user_id` (`user_id`),
  KEY `idx_platform_access_tokens_client_app_id` (`client_app_id`),
  CONSTRAINT `fk_platform_access_tokens_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_platform_access_tokens_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_platform_access_tokens_client_app_id`
    FOREIGN KEY (`client_app_id`) REFERENCES `client_apps` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='公司平台访问令牌表';

CREATE TABLE IF NOT EXISTS `project_mcp_configs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED NOT NULL COMMENT '项目ID',
  `endpoint_url` VARCHAR(255) NOT NULL COMMENT '项目协议接入地址',
  `transport_type` ENUM('STREAMABLE_HTTP', 'SSE', 'STDIO_PROXY') NOT NULL DEFAULT 'STREAMABLE_HTTP' COMMENT '协议传输方式',
  `auth_mode` ENUM('TOKEN', 'OAUTH') NOT NULL DEFAULT 'TOKEN' COMMENT '协议认证方式',
  `status` ENUM('ACTIVE', 'DISABLED') NOT NULL DEFAULT 'ACTIVE' COMMENT '协议状态',
  `last_used_at` DATETIME DEFAULT NULL COMMENT '最近使用时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_project_mcp_configs_project_id` (`project_id`),
  CONSTRAINT `fk_project_mcp_configs_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='项目级MCP配置表';

CREATE TABLE IF NOT EXISTS `ai_usage_events` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '项目ID',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '用户ID',
  `client_app_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '客户端ID',
  `provider_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '厂商ID',
  `model_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '模型ID',
  `source_type` ENUM('PLATFORM_GATEWAY', 'PLATFORM_MCP', 'CLIENT_ADMIN_API', 'VENDOR_USAGE_API', 'MANUAL_IMPORT') NOT NULL COMMENT '用量来源',
  `request_mode` ENUM('CHAT', 'CODE', 'MCP_TOOL', 'EMBEDDING', 'OTHER') NOT NULL DEFAULT 'OTHER' COMMENT '请求类型',
  `enforcement_level` ENUM('HARD_ENFORCED', 'SOFT_LIMITED', 'OBSERVE_ONLY') NOT NULL DEFAULT 'OBSERVE_ONLY' COMMENT '控制级别',
  `request_id` VARCHAR(128) DEFAULT NULL COMMENT '上游或内部请求ID',
  `conversation_id` VARCHAR(128) DEFAULT NULL COMMENT '会话ID',
  `input_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '输入令牌数',
  `output_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '输出令牌数',
  `total_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '总令牌数',
  `cost_amount` DECIMAL(16, 6) NOT NULL DEFAULT 0.000000 COMMENT '费用金额',
  `currency` CHAR(3) NOT NULL DEFAULT 'USD' COMMENT '币种',
  `status` ENUM('SUCCESS', 'FAILED', 'BLOCKED') NOT NULL DEFAULT 'SUCCESS' COMMENT '事件状态',
  `error_message` VARCHAR(500) DEFAULT NULL COMMENT '失败或阻断原因',
  `occurred_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '业务发生时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_ai_usage_events_project_time` (`project_id`, `occurred_at`),
  KEY `idx_ai_usage_events_user_time` (`user_id`, `occurred_at`),
  KEY `idx_ai_usage_events_client_time` (`client_app_id`, `occurred_at`),
  KEY `idx_ai_usage_events_provider_model_time` (`provider_id`, `model_id`, `occurred_at`),
  KEY `idx_ai_usage_events_request_id` (`request_id`),
  CONSTRAINT `fk_ai_usage_events_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_events_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_events_client_app_id`
    FOREIGN KEY (`client_app_id`) REFERENCES `client_apps` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_events_provider_id`
    FOREIGN KEY (`provider_id`) REFERENCES `ai_providers` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_events_model_id`
    FOREIGN KEY (`model_id`) REFERENCES `ai_models` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='统一AI用量明细表';

CREATE TABLE IF NOT EXISTS `ai_usage_daily` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `stat_date` DATE NOT NULL COMMENT '统计日期',
  `dimension_key` VARCHAR(255) NOT NULL COMMENT '由应用或任务生成的稳定维度键',
  `project_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '项目ID',
  `user_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '用户ID',
  `client_app_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '客户端ID',
  `provider_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '厂商ID',
  `model_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '模型ID',
  `source_type` ENUM('PLATFORM_GATEWAY', 'PLATFORM_MCP', 'CLIENT_ADMIN_API', 'VENDOR_USAGE_API', 'MANUAL_IMPORT') NOT NULL COMMENT '用量来源',
  `total_requests` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '请求总数',
  `success_requests` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '成功请求数',
  `blocked_requests` INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '阻断请求数',
  `input_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合输入令牌数',
  `output_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合输出令牌数',
  `total_tokens` BIGINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '聚合总令牌数',
  `cost_amount` DECIMAL(16, 6) NOT NULL DEFAULT 0.000000 COMMENT '聚合费用金额',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ai_usage_daily_dimensions` (`stat_date`, `dimension_key`),
  KEY `idx_ai_usage_daily_project_date` (`project_id`, `stat_date`),
  KEY `idx_ai_usage_daily_user_date` (`user_id`, `stat_date`),
  KEY `idx_ai_usage_daily_client_date` (`client_app_id`, `stat_date`),
  CONSTRAINT `fk_ai_usage_daily_project_id`
    FOREIGN KEY (`project_id`) REFERENCES `projects` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_daily_user_id`
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_daily_client_app_id`
    FOREIGN KEY (`client_app_id`) REFERENCES `client_apps` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_daily_provider_id`
    FOREIGN KEY (`provider_id`) REFERENCES `ai_providers` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ai_usage_daily_model_id`
    FOREIGN KEY (`model_id`) REFERENCES `ai_models` (`id`)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI日用量聚合表';

INSERT INTO `client_apps` (`code`, `name`, `supports_mcp`, `supports_custom_gateway`, `supports_usage_sync`, `supports_oauth`, `status`)
VALUES
  ('CURSOR', 'Cursor', 1, 0, 1, 1, 'ACTIVE'),
  ('CLAUDE_CODE', 'Claude Code', 1, 1, 0, 1, 'ACTIVE'),
  ('CODEX', 'Codex', 1, 0, 1, 0, 'ACTIVE'),
  ('GEMINI_CLI', 'Gemini CLI', 1, 0, 0, 1, 'ACTIVE'),
  ('OPENCODE', 'OpenCode', 1, 1, 0, 0, 'ACTIVE')
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `supports_mcp` = VALUES(`supports_mcp`),
  `supports_custom_gateway` = VALUES(`supports_custom_gateway`),
  `supports_usage_sync` = VALUES(`supports_usage_sync`),
  `supports_oauth` = VALUES(`supports_oauth`),
  `status` = VALUES(`status`),
  `updated_at` = CURRENT_TIMESTAMP;

INSERT INTO `ai_providers` (`code`, `name`, `provider_type`, `base_url`, `status`)
VALUES
  ('OPENAI', 'OpenAI', 'OPENAI', 'https://api.openai.com', 'ACTIVE'),
  ('ANTHROPIC', 'Anthropic', 'ANTHROPIC', 'https://api.anthropic.com', 'ACTIVE'),
  ('GOOGLE_GEMINI', 'Google Gemini', 'GOOGLE', 'https://generativelanguage.googleapis.com', 'ACTIVE'),
  ('AZURE_OPENAI', 'Azure OpenAI', 'AZURE_OPENAI', NULL, 'ACTIVE'),
  ('AWS_BEDROCK', 'AWS Bedrock', 'AWS_BEDROCK', NULL, 'ACTIVE'),
  ('OPENAI_COMPATIBLE', 'OpenAI Compatible Gateway', 'OPENAI_COMPATIBLE', NULL, 'ACTIVE')
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `provider_type` = VALUES(`provider_type`),
  `base_url` = VALUES(`base_url`),
  `status` = VALUES(`status`),
  `updated_at` = CURRENT_TIMESTAMP;
