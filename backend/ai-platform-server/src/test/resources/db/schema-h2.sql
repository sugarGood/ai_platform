CREATE TABLE IF NOT EXISTS projects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    code VARCHAR(64) NOT NULL,
    project_type VARCHAR(32) NOT NULL,
    branch_strategy VARCHAR(32) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS services (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    service_type VARCHAR(32) NOT NULL,
    default_branch VARCHAR(64) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS project_members (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    role VARCHAR(32) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT uk_project_member_email UNIQUE (project_id, email)
);

CREATE TABLE IF NOT EXISTS project_ai_keys (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    provider VARCHAR(32) NOT NULL,
    secret_key VARCHAR(255) NOT NULL,
    masked_key VARCHAR(255) NOT NULL,
    monthly_quota BIGINT NOT NULL,
    used_quota BIGINT NOT NULL,
    alert_threshold_percent INT NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT uk_project_ai_key_name UNIQUE (project_id, name)
);

CREATE TABLE IF NOT EXISTS project_workspaces (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    code VARCHAR(64) NOT NULL,
    workspace_type VARCHAR(32) NOT NULL,
    description VARCHAR(500),
    default_provider_id BIGINT,
    default_model_id BIGINT,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_project_workspaces_project_code UNIQUE (project_id, code),
    CONSTRAINT uk_project_workspaces_project_name UNIQUE (project_id, name)
);

CREATE TABLE IF NOT EXISTS ai_capabilities (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(64) NOT NULL,
    name VARCHAR(128) NOT NULL,
    capability_type VARCHAR(32) NOT NULL,
    request_mode VARCHAR(32) NOT NULL,
    description VARCHAR(500),
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_ai_capabilities_code UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS workspace_ai_capabilities (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    workspace_id BIGINT NOT NULL,
    ai_capability_id BIGINT NOT NULL,
    provider_id BIGINT NOT NULL DEFAULT 0,
    model_id BIGINT NOT NULL DEFAULT 0,
    monthly_request_quota INT NOT NULL DEFAULT 0,
    monthly_token_quota BIGINT NOT NULL DEFAULT 0,
    monthly_cost_quota DECIMAL(14, 2) NOT NULL DEFAULT 0.00,
    over_quota_strategy VARCHAR(32) NOT NULL DEFAULT 'BLOCK',
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_workspace_ai_capabilities_scope UNIQUE (workspace_id, ai_capability_id, provider_id, model_id)
);

CREATE TABLE IF NOT EXISTS platform_access_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    workspace_id BIGINT NOT NULL,
    project_member_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    role_snapshot VARCHAR(32) NOT NULL,
    token_prefix VARCHAR(32) NOT NULL,
    token_hash VARCHAR(64) NOT NULL,
    allowed_capability_codes VARCHAR(500),
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    expires_at TIMESTAMP NOT NULL,
    last_used_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_platform_access_token_hash UNIQUE (token_hash)
);

MERGE INTO ai_capabilities (id, code, name, capability_type, request_mode, description, status)
KEY (id)
VALUES
    (1, 'GENERAL_CHAT', 'General Chat', 'CHAT', 'CHAT', 'General conversational assistance for workspace members.', 'ACTIVE'),
    (2, 'CODE_GENERATION', 'Code Generation', 'CODE', 'CODE', 'Generate, refactor, and explain code for engineering teams.', 'ACTIVE'),
    (3, 'CODE_REVIEW', 'Code Review', 'CODE', 'CODE', 'Analyze diffs and provide engineering review suggestions.', 'ACTIVE'),
    (4, 'TEST_CASE_GENERATION', 'Test Case Generation', 'TEST', 'CODE', 'Generate test cases, test scripts, and validation plans.', 'ACTIVE'),
    (5, 'TEST_REPORT_ANALYSIS', 'Test Report Analysis', 'TEST', 'CHAT', 'Summarize test reports and suggest regression focus areas.', 'ACTIVE'),
    (6, 'OPS_DIAGNOSIS', 'Ops Diagnosis', 'OPS', 'CHAT', 'Analyze logs, incidents, and deployment symptoms.', 'ACTIVE'),
    (7, 'RUNBOOK_ASSISTANT', 'Runbook Assistant', 'OPS', 'MCP_TOOL', 'Call approved tools and execute standard operational runbooks.', 'ACTIVE'),
    (8, 'PRD_DRAFTING', 'PRD Drafting', 'PRODUCT', 'CHAT', 'Draft product requirements, release notes, and feature briefs.', 'ACTIVE'),
    (9, 'DATA_QUERY_ASSISTANT', 'Data Query Assistant', 'DATA', 'CODE', 'Generate and explain SQL and analytics queries.', 'ACTIVE');
