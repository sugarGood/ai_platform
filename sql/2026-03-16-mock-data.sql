SET NAMES utf8mb4;
USE `ai_platform`;

-- =========================================================
-- AI Platform 仿真数据（贴近生产环境）
-- 日期：2026-03-16
-- =========================================================


-- =============================================================
-- 1. 部门 departments（5个部门）
-- =============================================================
INSERT INTO `departments` (`id`, `name`, `code`, `parent_id`, `status`, `created_at`) VALUES
(1, '技术研发部', 'TECH_DEV',    NULL, 'ACTIVE', '2024-06-01 09:00:00'),
(2, '产品设计部', 'PRODUCT',     NULL, 'ACTIVE', '2024-06-01 09:00:00'),
(3, '数据智能部', 'DATA_AI',     NULL, 'ACTIVE', '2024-06-01 09:00:00'),
(4, '质量保障部', 'QA',          NULL, 'ACTIVE', '2024-06-01 09:00:00'),
(5, '基础架构部', 'INFRA',       NULL, 'ACTIVE', '2024-06-01 09:00:00');


-- =============================================================
-- 2. 用户 users（18人，模拟真实组织架构）
-- password_hash 统一为 bcrypt('Abc@123456')
-- =============================================================
INSERT INTO `users` (`id`, `department_id`, `username`, `real_name`, `email`, `avatar_url`, `password_hash`, `platform_role`, `mobile`, `job_title`, `status`, `created_at`) VALUES
( 1, 5, 'zhangwei',   '张伟', 'zhangwei@company.com',   '/avatars/zhangwei.jpg',   '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'SUPER_ADMIN', '13800000001', 'CTO',               'ACTIVE', '2024-06-15 10:00:00'),
( 2, 2, 'lina',       '李娜', 'lina@company.com',       '/avatars/lina.jpg',       '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'ADMIN',       '13800000002', '产品总监',           'ACTIVE', '2024-06-15 10:00:00'),
( 3, 1, 'wangqiang',  '王强', 'wangqiang@company.com',  '/avatars/wangqiang.jpg',  '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000003', '后端技术负责人',     'ACTIVE', '2024-07-01 09:00:00'),
( 4, 1, 'liuyang',    '刘洋', 'liuyang@company.com',    '/avatars/liuyang.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000004', '前端技术负责人',     'ACTIVE', '2024-07-01 09:00:00'),
( 5, 2, 'chensi',     '陈思', 'chensi@company.com',     '/avatars/chensi.jpg',     '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000005', '高级产品经理',       'ACTIVE', '2024-07-15 09:00:00'),
( 6, 1, 'zhaolei',    '赵磊', 'zhaolei@company.com',    '/avatars/zhaolei.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000006', '高级后端工程师',     'ACTIVE', '2024-08-01 09:00:00'),
( 7, 1, 'sunyue',     '孙悦', 'sunyue@company.com',     '/avatars/sunyue.jpg',     '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000007', '前端工程师',         'ACTIVE', '2024-08-01 09:00:00'),
( 8, 3, 'zhoujie',    '周杰', 'zhoujie@company.com',    '/avatars/zhoujie.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000008', '数据工程师',         'ACTIVE', '2024-08-15 09:00:00'),
( 9, 4, 'wuhao',      '吴昊', 'wuhao@company.com',      '/avatars/wuhao.jpg',      '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000009', '测试负责人',         'ACTIVE', '2024-08-15 09:00:00'),
(10, 1, 'zhengkai',   '郑凯', 'zhengkai@company.com',   '/avatars/zhengkai.jpg',   '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000010', '后端工程师',         'ACTIVE', '2024-09-01 09:00:00'),
(11, 2, 'huanglei',   '黄蕾', 'huanglei@company.com',   '/avatars/huanglei.jpg',   '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000011', '产品经理',           'ACTIVE', '2024-09-01 09:00:00'),
(12, 5, 'mafei',      '马飞', 'mafei@company.com',      '/avatars/mafei.jpg',      '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000012', 'DevOps工程师',       'ACTIVE', '2024-09-15 09:00:00'),
(13, 3, 'linxiao',    '林晓', 'linxiao@company.com',    '/avatars/linxiao.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000013', 'AI算法工程师',       'ACTIVE', '2024-09-15 09:00:00'),
(14, 4, 'huting',     '胡婷', 'huting@company.com',     '/avatars/huting.jpg',     '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000014', '测试工程师',         'ACTIVE', '2024-10-01 09:00:00'),
(15, 1, 'gaoming',    '高明', 'gaoming@company.com',    '/avatars/gaoming.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000015', '全栈工程师',         'ACTIVE', '2024-10-01 09:00:00'),
(16, 5, 'xiefeng',    '谢峰', 'xiefeng@company.com',    '/avatars/xiefeng.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'ADMIN',       '13800000016', '平台架构师',         'ACTIVE', '2024-07-01 09:00:00'),
(17, 3, 'hanxue',     '韩雪', 'hanxue@company.com',     '/avatars/hanxue.jpg',     '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000017', '数据分析师',         'ACTIVE', '2024-10-15 09:00:00'),
(18, 1, 'yangfan',    '杨帆', 'yangfan@company.com',    '/avatars/yangfan.jpg',    '$2a$10$xK8v3QZl0J5G8dQmF7RzUOeZb0Gk3W1H4p6rYtN2sVjA9cLmX7a5q', 'USER',        '13800000018', '移动端工程师',       'ACTIVE', '2024-11-01 09:00:00');


-- =============================================================
-- 3. AI模型 ai_models（覆盖主流厂商旗舰+经济模型）
-- =============================================================
INSERT INTO `ai_models` (`id`, `provider_id`, `code`, `name`, `model_family`, `context_window`, `input_price_per_1m`, `output_price_per_1m`, `status`) VALUES
( 1, 2, 'claude-sonnet-4-6',    'Claude Sonnet 4.6',   'Claude 4',  200000,  3.000000, 15.000000, 'ACTIVE'),
( 2, 2, 'claude-haiku-4-5',     'Claude Haiku 4.5',    'Claude 4',  200000,  0.800000,  4.000000, 'ACTIVE'),
( 3, 2, 'claude-opus-4-6',      'Claude Opus 4.6',     'Claude 4',  200000, 15.000000, 75.000000, 'ACTIVE'),
( 4, 1, 'gpt-4.1',              'GPT-4.1',             'GPT-4',     128000,  2.000000,  8.000000, 'ACTIVE'),
( 5, 1, 'gpt-4.1-mini',         'GPT-4.1 Mini',        'GPT-4',     128000,  0.400000,  1.600000, 'ACTIVE'),
( 6, 1, 'o3-mini',              'o3-mini',             'o3',        200000,  1.100000,  4.400000, 'ACTIVE'),
( 7, 3, 'gemini-2.5-pro',       'Gemini 2.5 Pro',      'Gemini 2',  1000000, 1.250000,  5.000000, 'ACTIVE'),
( 8, 3, 'gemini-2.5-flash',     'Gemini 2.5 Flash',    'Gemini 2',  1000000, 0.150000,  0.600000, 'ACTIVE'),
( 9, 6, 'deepseek-v3',          'DeepSeek V3',         'DeepSeek',  128000,  0.270000,  1.100000, 'ACTIVE'),
(10, 6, 'deepseek-r1',          'DeepSeek R1',         'DeepSeek',  128000,  0.550000,  2.190000, 'ACTIVE');


-- =============================================================
-- 4. 平台密钥 provider_api_keys（3把平台级Key）
-- =============================================================
INSERT INTO `provider_api_keys` (`id`, `provider_id`, `project_id`, `name`, `secret_ciphertext`, `secret_masked`, `key_scope`, `status`, `last_used_at`, `created_at`) VALUES
(1, 2, NULL, 'Anthropic 主密钥',      'enc_v1:aHR0cHM6Ly9hbnRocm9waWMuY29t...cipher', 'sk-ant-****GkN2', 'PLATFORM', 'ACTIVE', '2026-03-16 09:30:00', '2025-01-10 10:00:00'),
(2, 1, NULL, 'OpenAI 主密钥',         'enc_v1:c2stcHJvai0wMTIzNDU2Nzg5...cipher',     'sk-proj-****f8Zq', 'PLATFORM', 'ACTIVE', '2026-03-16 09:28:00', '2025-01-10 10:00:00'),
(3, 6, NULL, 'DeepSeek 平台密钥',     'enc_v1:ZHNrLTEyMzQ1Njc4OTBhYmNk...cipher',     'dsk-****m9Xp',     'PLATFORM', 'ACTIVE', '2026-03-16 08:15:00', '2025-06-01 14:00:00'),
(4, 2, 2,   'Anthropic 智能客服专用', 'enc_v1:cHJvamVjdC1leGNsdXNpdmU=...cipher',      'sk-ant-****Kp3R', 'PROJECT_EXCLUSIVE', 'ACTIVE', '2026-03-15 22:10:00', '2025-09-01 10:00:00');


-- =============================================================
-- 5. 项目 projects（5个项目，涵盖不同类型和阶段）
-- =============================================================
INSERT INTO `projects` (`id`, `department_id`, `name`, `code`, `project_type`, `description`, `icon`, `status`, `branch_strategy`, `sprint_cycle_weeks`, `owner_user_id`, `created_at`) VALUES
(1, 1, '商城中台',        'mall-platform',   'PRODUCT',       '新一代电商中台系统，包含商品、订单、支付、搜索、营销等核心模块，日均PV 200万+', '🛒', 'ACTIVE',         'GIT_FLOW',       2, 3,  '2025-01-15 09:00:00'),
(2, 3, '智能客服系统',    'smart-cs',        'PRODUCT',       '基于LLM的多轮对话客服系统，支持意图识别、知识库RAG、人机协作，接入商城和App', '🤖', 'ACTIVE',         'TRUNK_BASED',    2, 13, '2025-03-01 09:00:00'),
(3, 3, '数据分析平台',    'data-analytics',  'DATA_PRODUCT',  '企业级BI看板+自然语言查询，支持SQL自动生成、图表推荐、定时报表邮件推送',       '📊', 'ACTIVE',         'FEATURE_BRANCH', 3, 8,  '2025-06-01 09:00:00'),
(4, 1, '移动商城App',     'mobile-app',      'PRODUCT',       'React Native跨端商城App，iOS/Android双端，对接商城中台API，含直播+AR试穿',   '📱', 'ACTIVE',         'GIT_FLOW',       2, 4,  '2025-04-01 09:00:00'),
(5, 5, '基础设施平台',    'infra-platform',  'TECH_PLATFORM', '内部DevOps自助平台，集成CI/CD、容器编排、监控告警、日志中心、服务网格管理',     '⚙️', 'ACTIVE',         'TRUNK_BASED',    3, 16, '2025-02-01 09:00:00');


-- =============================================================
-- 6. 项目成员 project_members（每个项目5-8人，角色分布合理）
-- =============================================================
INSERT INTO `project_members` (`project_id`, `user_id`, `role`, `knowledge_access`, `skill_access_scope`, `mcp_access_enabled`, `status`, `joined_at`) VALUES
-- 商城中台
(1, 3,  'TECH_LEAD',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-01-15 09:00:00'),
(1, 5,  'PRODUCT_MANAGER', 'READ_WRITE', 'ALL', 0, 'ACTIVE', '2025-01-15 09:00:00'),
(1, 6,  'DEVELOPER',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-01-20 09:00:00'),
(1, 7,  'DEVELOPER',       'READ_ONLY',  'ALL', 1, 'ACTIVE', '2025-01-20 09:00:00'),
(1, 10, 'DEVELOPER',       'READ_ONLY',  'ALL', 1, 'ACTIVE', '2025-02-01 09:00:00'),
(1, 9,  'TESTER',          'READ_ONLY',  'CODE_REVIEW,UNIT_TEST_GEN', 0, 'ACTIVE', '2025-01-20 09:00:00'),
(1, 12, 'DEVELOPER',       'READ_ONLY',  'ALL', 1, 'ACTIVE', '2025-03-01 09:00:00'),
-- 智能客服系统
(2, 13, 'TECH_LEAD',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-03-01 09:00:00'),
(2, 11, 'PRODUCT_MANAGER', 'READ_WRITE', 'ALL', 0, 'ACTIVE', '2025-03-01 09:00:00'),
(2, 8,  'DEVELOPER',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-03-05 09:00:00'),
(2, 15, 'DEVELOPER',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-03-10 09:00:00'),
(2, 14, 'TESTER',          'READ_ONLY',  'CODE_REVIEW,BUG_DIAGNOSIS', 0, 'ACTIVE', '2025-03-10 09:00:00'),
-- 数据分析平台
(3, 8,  'TECH_LEAD',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-06-01 09:00:00'),
(3, 17, 'DEVELOPER',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-06-05 09:00:00'),
(3, 7,  'DEVELOPER',       'READ_ONLY',  'ALL', 1, 'ACTIVE', '2025-06-10 09:00:00'),
(3, 11, 'PRODUCT_MANAGER', 'READ_WRITE', 'ALL', 0, 'ACTIVE', '2025-06-01 09:00:00'),
-- 移动商城App
(4, 4,  'TECH_LEAD',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-04-01 09:00:00'),
(4, 18, 'DEVELOPER',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-04-05 09:00:00'),
(4, 5,  'PRODUCT_MANAGER', 'READ_WRITE', 'ALL', 0, 'ACTIVE', '2025-04-01 09:00:00'),
(4, 15, 'DEVELOPER',       'READ_ONLY',  'ALL', 1, 'ACTIVE', '2025-04-10 09:00:00'),
(4, 14, 'TESTER',          'READ_ONLY',  'CODE_REVIEW,UNIT_TEST_GEN', 0, 'ACTIVE', '2025-04-10 09:00:00'),
-- 基础设施平台
(5, 16, 'TECH_LEAD',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-02-01 09:00:00'),
(5, 12, 'DEVELOPER',       'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-02-01 09:00:00'),
(5, 1,  'PROJECT_OWNER',   'READ_WRITE', 'ALL', 1, 'ACTIVE', '2025-02-01 09:00:00'),
(5, 10, 'DEVELOPER',       'READ_ONLY',  'ALL', 1, 'ACTIVE', '2025-03-01 09:00:00');


-- =============================================================
-- 7. 服务 services（13个微服务）
-- =============================================================
INSERT INTO `services` (`id`, `project_id`, `name`, `icon`, `service_type`, `tech_stack`, `git_repo_url`, `default_branch`, `description`, `status`, `created_at`) VALUES
-- 商城中台（4个服务）
( 1, 1, 'mall-backend',    '☕', 'BACKEND',      'Spring Boot 3,MySQL 8,Redis 7,RabbitMQ',     'git.company.com/mall/mall-backend',    'main',    '商城后端核心服务（商品/订单/库存）', 'ACTIVE', '2025-01-15 10:00:00'),
( 2, 1, 'mall-frontend',   '⚛️', 'FRONTEND',     'React 18,Vite 5,TypeScript,Ant Design 5',    'git.company.com/mall/mall-frontend',   'main',    '商城管理后台前端',                   'ACTIVE', '2025-01-15 10:00:00'),
( 3, 1, 'mall-bff',        '🟢', 'BFF',          'Node.js 20,Fastify 4,GraphQL',               'git.company.com/mall/mall-bff',        'main',    'C端接口聚合层BFF',                   'ACTIVE', '2025-02-01 10:00:00'),
( 4, 1, 'pay-service',     '💳', 'BACKEND',      'Spring Boot 3,MySQL 8,分布式事务Seata',       'git.company.com/mall/pay-service',     'main',    '支付核心服务（微信/支付宝/银联）',   'ACTIVE', '2025-02-15 10:00:00'),
-- 智能客服系统（3个服务）
( 5, 2, 'cs-engine',       '🧠', 'BACKEND',      'Python 3.12,FastAPI,LangChain,pgvector',     'git.company.com/cs/cs-engine',         'main',    '客服AI引擎（意图识别+RAG对话）',     'ACTIVE', '2025-03-01 10:00:00'),
( 6, 2, 'cs-frontend',     '🖥️', 'FRONTEND',     'Vue 3,Element Plus,TypeScript',              'git.company.com/cs/cs-frontend',       'main',    '客服工作台前端',                     'ACTIVE', '2025-03-01 10:00:00'),
( 7, 2, 'cs-knowledge-worker', '⚙️', 'DATA_SERVICE', 'Python 3.12,Celery,Redis,Milvus',        'git.company.com/cs/cs-knowledge-worker','main',   '知识库向量化处理Worker',             'ACTIVE', '2025-03-15 10:00:00'),
-- 数据分析平台（2个服务）
( 8, 3, 'analytics-api',       '🐍', 'BACKEND',      'Python 3.12,FastAPI,Pandas,SQLAlchemy',  'git.company.com/data/analytics-api',       'main', '数据分析后端API',                    'ACTIVE', '2025-06-01 10:00:00'),
( 9, 3, 'analytics-dashboard', '📈', 'FRONTEND',     'React 18,ECharts 5,Ant Design Pro',      'git.company.com/data/analytics-dashboard', 'main', 'BI可视化看板前端',                    'ACTIVE', '2025-06-01 10:00:00'),
-- 移动商城App（2个服务）
(10, 4, 'mobile-rn',       '📲', 'MOBILE',       'React Native 0.76,TypeScript,Reanimated',    'git.company.com/mobile/mobile-rn',     'main',    'React Native跨端App',                'ACTIVE', '2025-04-01 10:00:00'),
(11, 4, 'mobile-gateway',  '🔀', 'BFF',          'Node.js 20,Express,JWT',                     'git.company.com/mobile/mobile-gateway','main',    '移动端API网关',                      'ACTIVE', '2025-04-15 10:00:00'),
-- 基础设施平台（2个服务）
(12, 5, 'infra-console',   '🖥️', 'FRONTEND',     'React 18,Ant Design Pro,TypeScript',         'git.company.com/infra/infra-console',  'main',    'DevOps自助控制台前端',               'ACTIVE', '2025-02-01 10:00:00'),
(13, 5, 'infra-api',       '🔧', 'BACKEND',      'Go 1.22,Gin,GORM,K8s client-go',            'git.company.com/infra/infra-api',      'main',    '平台后端API（CI/CD编排+K8s管理）',   'ACTIVE', '2025-02-01 10:00:00');


-- =============================================================
-- 8. 迭代 sprints（每个活跃项目2-3个Sprint）
-- =============================================================
INSERT INTO `sprints` (`id`, `project_id`, `name`, `goal`, `sprint_order`, `status`, `start_date`, `end_date`, `total_story_points`, `completed_story_points`) VALUES
-- 商城中台
( 1, 1, 'Sprint 23', '完成搜索推荐V2和订单履约优化',           23, 'COMPLETED', '2026-02-17', '2026-02-28', 42, 42),
( 2, 1, 'Sprint 24', '会员等级体系上线+支付宝小程序对接',       24, 'ACTIVE',    '2026-03-03', '2026-03-14', 38, 29),
( 3, 1, 'Sprint 25', '营销活动引擎+秒杀服务重构',              25, 'PLANNING',  '2026-03-17', '2026-03-28', 0,  0),
-- 智能客服系统
( 4, 2, 'Sprint 8',  '多轮对话引擎优化+情感分析接入',           8,  'COMPLETED', '2026-02-17', '2026-02-28', 34, 34),
( 5, 2, 'Sprint 9',  '知识库RAG 2.0+客服质检',                  9,  'ACTIVE',    '2026-03-03', '2026-03-14', 30, 22),
-- 数据分析平台
( 6, 3, 'Sprint 5',  '自然语言查询优化+定时报表邮件推送',        5,  'ACTIVE',    '2026-03-03', '2026-03-21', 28, 15),
-- 移动商城App
( 7, 4, 'Sprint 12', 'AR试穿功能+直播间弹幕优化',              12, 'COMPLETED', '2026-02-17', '2026-02-28', 36, 36),
( 8, 4, 'Sprint 13', '性能优化+推送通知+深链跳转',             13, 'ACTIVE',    '2026-03-03', '2026-03-14', 32, 18),
-- 基础设施平台
( 9, 5, 'Sprint 4',  'Kubernetes多集群管理+日志中心V2',          4,  'ACTIVE',    '2026-03-03', '2026-03-21', 26, 12);


-- =============================================================
-- 9. Epic epics
-- =============================================================
INSERT INTO `epics` (`id`, `project_id`, `name`, `description`, `status`, `created_at`) VALUES
(1, 1, '搜索推荐系统',   '商品搜索+个性化推荐+搜索联想，ES+向量检索双引擎',       'IN_PROGRESS', '2025-11-01 09:00:00'),
(2, 1, '会员体系',       '会员等级/积分/权益/成长值体系',                         'IN_PROGRESS', '2025-12-01 09:00:00'),
(3, 1, '支付中心',       '多渠道支付/退款/对账/风控',                             'DONE',        '2025-06-01 09:00:00'),
(4, 2, 'RAG对话引擎',    '基于知识库的检索增强生成对话系统',                       'IN_PROGRESS', '2025-05-01 09:00:00'),
(5, 2, '客服质检',       'AI自动质检+人工抽检+质检报表',                          'NOT_STARTED', '2026-01-15 09:00:00'),
(6, 3, 'NL2SQL引擎',     '自然语言转SQL查询+结果可视化',                          'IN_PROGRESS', '2025-09-01 09:00:00'),
(7, 4, 'AR购物体验',     'AR试穿/试戴+3D商品展示',                               'IN_PROGRESS', '2025-10-01 09:00:00'),
(8, 5, 'K8s多集群管理',  '多集群纳管+跨集群调度+统一监控',                         'IN_PROGRESS', '2025-12-01 09:00:00');


-- =============================================================
-- 10. 任务 tasks（约40条，覆盖各种状态和看板列）
-- =============================================================
INSERT INTO `tasks` (`id`, `project_id`, `sprint_id`, `epic_id`, `title`, `description`, `task_type`, `priority`, `story_points`, `assignee_user_id`, `category`, `kanban_status`, `progress_pct`, `estimated_hours`, `ai_review_status`, `created_at`) VALUES
-- 商城中台 Sprint 24 任务
( 1, 1, 2, 2, '会员等级计算引擎',                   '根据消费金额和频次计算等级，支持自动升降级',         'USER_STORY', 'P0', 8,  6,  '后端', 'DONE',         100, 16.0, 'APPROVED',      '2026-03-03 09:00:00'),
( 2, 1, 2, 2, '会员权益配置后台',                   '管理后台配置不同等级权益（折扣/包邮/专属客服）',     'USER_STORY', 'P1', 5,  7,  '前端', 'DONE',         100, 10.0, 'APPROVED',      '2026-03-03 09:00:00'),
( 3, 1, 2, 2, '积分兑换接口开发',                   'REST API: 积分查询、兑换商品、兑换记录',             'USER_STORY', 'P1', 5,  10, '后端', 'CODE_REVIEW',  85,  10.0, 'REVIEWING',     '2026-03-03 09:00:00'),
( 4, 1, 2, NULL, '支付宝小程序SDK对接',              '接入支付宝小程序登录+支付，复用现有支付中心',         'USER_STORY', 'P0', 8,  6,  '后端', 'IN_PROGRESS',  60,  16.0, 'NONE',          '2026-03-03 09:00:00'),
( 5, 1, 2, 1, '搜索联想词接口',                     'ElasticSearch completion suggester + 热词排序',      'USER_STORY', 'P1', 3,  10, '后端', 'DONE',         100, 6.0,  'APPROVED',      '2026-03-03 09:00:00'),
( 6, 1, 2, NULL, '订单列表性能优化',                 '大表分页查询优化，引入游标分页替代offset',            'TECH_DEBT',  'P1', 5,  3,  '后端', 'IN_PROGRESS',  40,  10.0, 'NONE',          '2026-03-05 09:00:00'),
( 7, 1, 2, 2, '会员等级前端展示',                   '个人中心展示等级徽章、进度条、距下一等级差额',       'USER_STORY', 'P2', 3,  7,  '前端', 'TODO',         0,   6.0,  'NONE',          '2026-03-05 09:00:00'),
( 8, 1, 2, NULL, '修复优惠券叠加计算Bug',           'P0: 满减+折扣券叠加时金额计算错误',                  'BUG',        'P0', 1,  6,  '后端', 'DONE',         100, 3.0,  'APPROVED',      '2026-03-04 14:00:00'),
-- 商城中台 Backlog
( 9, 1, NULL, 1, '商品图片AI生成描述',              '调用AI接口自动生成商品SEO描述',                       'USER_STORY', 'P2', 5,  NULL, '后端', 'BACKLOG',      0,   NULL, 'NONE',          '2026-03-10 09:00:00'),
(10, 1, NULL, NULL, '接入统一短信服务通知',          '订单状态变更通过短信原子能力通知用户',                'USER_STORY', 'P2', 3,  NULL, '后端', 'BACKLOG',      0,   NULL, 'NONE',          '2026-03-12 09:00:00'),
-- 智能客服 Sprint 9 任务
(11, 2, 5, 4, '知识库分段策略优化',                 '改进文档切分策略：语义切分替代固定长度，提升召回率',   'USER_STORY', 'P0', 8,  13, '后端', 'DONE',         100, 16.0, 'APPROVED',      '2026-03-03 09:00:00'),
(12, 2, 5, 4, 'RAG重排序模型集成',                  '引入bge-reranker-v2对检索结果重排序',                'USER_STORY', 'P0', 8,  13, '后端', 'IN_PROGRESS',  65,  16.0, 'NONE',          '2026-03-03 09:00:00'),
(13, 2, 5, NULL, '客服对话上下文管理',              '多轮对话context window管理+摘要压缩',                 'USER_STORY', 'P1', 5,  15, '后端', 'CODE_REVIEW',  90,  10.0, 'REVIEWING',     '2026-03-03 09:00:00'),
(14, 2, 5, 5, '质检规则引擎设计',                   '设计自动质检规则：敏感词/情绪/解决率/响应时长',        'SPIKE',      'P1', 3,  8,  '后端', 'TODO',         0,   6.0,  'NONE',          '2026-03-05 09:00:00'),
(15, 2, 5, NULL, '客服工作台消息列表优化',          '虚拟滚动+消息懒加载，解决千条消息卡顿',              'TECH_DEBT',  'P1', 3,  15, '前端', 'IN_PROGRESS',  30,  6.0,  'NONE',          '2026-03-05 09:00:00'),
(16, 2, 5, 4, '多模态图片理解',                     '客户发送截图时AI自动OCR+理解图片内容',               'USER_STORY', 'P2', 3,  13, '后端', 'TODO',         0,   8.0,  'NONE',          '2026-03-07 09:00:00'),
-- 数据分析平台 Sprint 5 任务
(17, 3, 6, 6, 'NL2SQL多表JOIN支持',                '支持跨表关联查询的自然语言转SQL',                      'USER_STORY', 'P0', 8,  8,  '后端', 'IN_PROGRESS',  55,  16.0, 'NONE',          '2026-03-03 09:00:00'),
(18, 3, 6, 6, 'SQL安全审计拦截',                    '防SQL注入+禁止DROP/TRUNCATE等危险操作',               'USER_STORY', 'P0', 5,  8,  '后端', 'DONE',         100, 10.0, 'APPROVED',      '2026-03-03 09:00:00'),
(19, 3, 6, NULL, '定时报表邮件推送',                '支持Cron定时执行查询+ECharts图片截图+邮件推送',       'USER_STORY', 'P1', 8,  17, '后端', 'TODO',         0,   16.0, 'NONE',          '2026-03-05 09:00:00'),
(20, 3, 6, NULL, 'ECharts图表类型自动推荐',          '根据查询结果字段类型自动推荐合适的图表类型',          'USER_STORY', 'P2', 5,  7,  '前端', 'BACKLOG',      0,   10.0, 'NONE',          '2026-03-07 09:00:00'),
-- 移动商城App Sprint 13 任务
(21, 4, 8, 7, 'AR试穿模型加载优化',                 '模型预加载+LOD策略，3G网络下3秒内加载完成',           'USER_STORY', 'P0', 8,  18, '移动端', 'IN_PROGRESS',  70,  16.0, 'NONE',        '2026-03-03 09:00:00'),
(22, 4, 8, NULL, '推送通知SDK集成',                 '集成极光推送，支持消息分类+免打扰时段',               'USER_STORY', 'P1', 5,  18, '移动端', 'DONE',         100, 10.0, 'APPROVED',    '2026-03-03 09:00:00'),
(23, 4, 8, NULL, '深链跳转+Universal Links',        '支持从H5/短信/分享卡片直接打开App对应页面',           'USER_STORY', 'P1', 5,  4,  '移动端', 'IN_PROGRESS',  50,  10.0, 'NONE',        '2026-03-03 09:00:00'),
(24, 4, 8, NULL, 'FlatList渲染性能优化',             '商品瀑布流FlatList memo化+图片渐进加载',              'TECH_DEBT',  'P1', 5,  18, '移动端', 'TODO',         0,   8.0,  'NONE',        '2026-03-05 09:00:00'),
(25, 4, 8, NULL, '修复iOS键盘遮挡输入框Bug',        '搜索框和评论输入时被键盘遮挡',                       'BUG',        'P0', 2,  18, '移动端', 'DONE',         100, 3.0,  'APPROVED',    '2026-03-04 10:00:00'),
-- 基础设施平台 Sprint 4 任务
(26, 5, 9, 8, 'K8s多集群纳管API',                   'Go client-go 接入多个K8s集群并统一管理',              'USER_STORY', 'P0', 8,  16, '后端', 'IN_PROGRESS',  45,  16.0, 'NONE',          '2026-03-03 09:00:00'),
(27, 5, 9, 8, '集群拓扑可视化',                     '展示Node/Pod/Service拓扑关系图',                     'USER_STORY', 'P1', 5,  12, '前端', 'TODO',         0,   10.0, 'NONE',          '2026-03-05 09:00:00'),
(28, 5, 9, NULL, '日志中心Loki集成',                '替换ELK，接入Grafana Loki实现日志聚合查询',           'USER_STORY', 'P1', 5,  16, '后端', 'TODO',         0,   12.0, 'NONE',          '2026-03-05 09:00:00'),
(29, 5, 9, NULL, '监控告警规则配置页面',             '前端页面配置Prometheus告警规则+通知渠道',             'USER_STORY', 'P2', 5,  12, '前端', 'BACKLOG',      0,   10.0, 'NONE',          '2026-03-07 09:00:00');


-- =============================================================
-- 11. 环境 environments（每个核心服务3-4个环境）
-- =============================================================
INSERT INTO `environments` (`id`, `service_id`, `name`, `env_type`, `url`, `k8s_namespace`, `replicas`, `cpu_limit`, `memory_limit`, `health_status`, `status`, `last_deployed_at`) VALUES
-- mall-backend 环境
( 1, 1, 'mall-backend DEV',     'DEV',     'http://mall-backend.dev.internal:8080',     'mall-dev',     1, '1000m', '2Gi',  'HEALTHY',     'ACTIVE', '2026-03-15 10:30:00'),
( 2, 1, 'mall-backend TEST',    'TEST',    'http://mall-backend.test.internal:8080',    'mall-test',    2, '2000m', '4Gi',  'HEALTHY',     'ACTIVE', '2026-03-14 16:20:00'),
( 3, 1, 'mall-backend STAGING', 'STAGING', 'http://mall-backend.staging.internal:8080', 'mall-staging', 2, '2000m', '4Gi',  'HEALTHY',     'ACTIVE', '2026-03-13 14:00:00'),
( 4, 1, 'mall-backend PROD',    'PROD',    'https://api.mall.company.com',              'mall-prod',    6, '4000m', '8Gi',  'HEALTHY',     'ACTIVE', '2026-03-12 22:00:00'),
-- mall-frontend 环境
( 5, 2, 'mall-frontend DEV',    'DEV',     'http://mall-fe.dev.internal:3000',          'mall-dev',     1, '500m',  '512Mi', 'HEALTHY',    'ACTIVE', '2026-03-15 11:00:00'),
( 6, 2, 'mall-frontend PROD',   'PROD',    'https://admin.mall.company.com',            'mall-prod',    3, '1000m', '1Gi',   'HEALTHY',    'ACTIVE', '2026-03-13 20:00:00'),
-- cs-engine 环境
( 7, 5, 'cs-engine DEV',        'DEV',     'http://cs-engine.dev.internal:8000',        'cs-dev',       1, '2000m', '4Gi',  'HEALTHY',     'ACTIVE', '2026-03-16 09:00:00'),
( 8, 5, 'cs-engine PROD',       'PROD',    'https://cs-api.company.com',                'cs-prod',      4, '4000m', '8Gi',  'HEALTHY',     'ACTIVE', '2026-03-14 21:00:00'),
-- analytics-api 环境
( 9, 8, 'analytics-api DEV',    'DEV',     'http://analytics.dev.internal:8000',        'data-dev',     1, '1000m', '2Gi',  'HEALTHY',     'ACTIVE', '2026-03-15 14:00:00'),
(10, 8, 'analytics-api PROD',   'PROD',    'https://bi-api.company.com',                'data-prod',    3, '2000m', '4Gi',  'HEALTHY',     'ACTIVE', '2026-03-11 20:00:00'),
-- infra-api 环境
(11, 13, 'infra-api DEV',       'DEV',     'http://infra-api.dev.internal:8080',        'infra-dev',    1, '1000m', '1Gi',  'HEALTHY',     'ACTIVE', '2026-03-15 16:00:00'),
(12, 13, 'infra-api PROD',      'PROD',    'https://infra-api.company.com',             'infra-prod',   3, '2000m', '4Gi',  'DEGRADED',    'ACTIVE', '2026-03-10 22:00:00');


-- =============================================================
-- 12. 流水线运行 pipeline_runs（近期CI/CD运行记录）
-- =============================================================
INSERT INTO `pipeline_runs` (`id`, `service_id`, `pipeline_name`, `run_number`, `trigger_type`, `trigger_ref`, `commit_sha`, `commit_message`, `triggered_by`, `status`, `duration_seconds`, `started_at`, `finished_at`) VALUES
( 1, 1, 'mall-backend CI/CD',  1087, 'PUSH',         'refs/heads/feature/member-v2',      'a3b7c9d2', 'feat: 会员等级计算引擎核心逻辑',          6,  'SUCCESS',  326, '2026-03-15 10:10:00', '2026-03-15 10:15:26'),
( 2, 1, 'mall-backend CI/CD',  1088, 'PUSH',         'refs/heads/feature/alipay-mini',    'e5f1a8b4', 'feat: 支付宝小程序SDK登录对接',            6,  'SUCCESS',  298, '2026-03-15 14:30:00', '2026-03-15 14:34:58'),
( 3, 1, 'mall-backend CI/CD',  1089, 'MERGE_REQUEST','refs/heads/main',                   'f2d9e1c6', 'Merge: 积分兑换接口 (#PR-312)',            10, 'RUNNING',  NULL,'2026-03-16 09:20:00', NULL),
( 4, 2, 'mall-frontend CI/CD', 523,  'PUSH',         'refs/heads/feature/member-ui',      'b8c4d6e2', 'feat: 会员中心页面+等级进度条组件',        7,  'SUCCESS',  185, '2026-03-15 11:00:00', '2026-03-15 11:03:05'),
( 5, 5, 'cs-engine CI/CD',     234,  'PUSH',         'refs/heads/feature/rag-v2',         'c1d3e5f7', 'feat: 语义分段+bge-reranker集成',         13, 'SUCCESS',  412, '2026-03-15 17:00:00', '2026-03-15 17:06:52'),
( 6, 5, 'cs-engine CI/CD',     235,  'PUSH',         'refs/heads/feature/context-mgmt',   'd4e6f8a0', 'feat: 多轮对话context管理+摘要压缩',     15, 'FAILED',   198, '2026-03-16 08:45:00', '2026-03-16 08:48:18'),
( 7, 8, 'analytics-api CI/CD', 98,   'PUSH',         'refs/heads/feature/nl2sql-join',    '1a2b3c4d', 'feat: NL2SQL多表JOIN+安全审计',            8,  'SUCCESS',  245, '2026-03-15 14:00:00', '2026-03-15 14:04:05'),
( 8, 13,'infra-api CI/CD',     312,  'PUSH',         'refs/heads/feature/multi-cluster',  '5e6f7a8b', 'feat: K8s多集群纳管client-go封装',       16, 'SUCCESS',  178, '2026-03-15 16:00:00', '2026-03-15 16:02:58'),
( 9, 10,'mobile-rn CI/CD',     187,  'PUSH',         'refs/heads/feature/ar-optimize',    '9c0d1e2f', 'perf: AR模型LOD预加载策略',               18, 'SUCCESS',  534, '2026-03-15 15:00:00', '2026-03-15 15:08:54'),
(10, 4, 'pay-service CI/CD',   445,  'MERGE_REQUEST','refs/heads/main',                   '3a4b5c6d', 'fix: 修复优惠券叠加金额计算 (#PR-298)',    6,  'SUCCESS',  267, '2026-03-14 16:00:00', '2026-03-14 16:04:27');


-- =============================================================
-- 13. 流水线阶段 pipeline_stages
-- =============================================================
INSERT INTO `pipeline_stages` (`pipeline_run_id`, `stage_name`, `stage_order`, `status`, `duration_seconds`, `started_at`, `finished_at`, `log_url`) VALUES
-- Run 1 (mall-backend成功)
(1, 'Checkout & Build',   1, 'SUCCESS', 65,  '2026-03-15 10:10:00', '2026-03-15 10:11:05', '/logs/run-1087/build'),
(1, 'Unit Test',          2, 'SUCCESS', 98,  '2026-03-15 10:11:05', '2026-03-15 10:12:43', '/logs/run-1087/test'),
(1, 'Code Scan (SonarQube)',3,'SUCCESS', 82,  '2026-03-15 10:12:43', '2026-03-15 10:14:05', '/logs/run-1087/scan'),
(1, 'Docker Build & Push',4, 'SUCCESS', 45,  '2026-03-15 10:14:05', '2026-03-15 10:14:50', '/logs/run-1087/docker'),
(1, 'Deploy to DEV',      5, 'SUCCESS', 36,  '2026-03-15 10:14:50', '2026-03-15 10:15:26', '/logs/run-1087/deploy'),
-- Run 6 (cs-engine失败)
(6, 'Checkout & Build',   1, 'SUCCESS', 45,  '2026-03-16 08:45:00', '2026-03-16 08:45:45', '/logs/run-235/build'),
(6, 'Unit Test',          2, 'FAILED',  120, '2026-03-16 08:45:45', '2026-03-16 08:47:45', '/logs/run-235/test'),
(6, 'Code Scan',          3, 'SKIPPED', NULL,'2026-03-16 08:47:45', '2026-03-16 08:47:45', NULL),
(6, 'Docker Build',       4, 'SKIPPED', NULL,'2026-03-16 08:47:45', '2026-03-16 08:47:45', NULL),
-- Run 3 (mall-backend运行中)
(3, 'Checkout & Build',   1, 'SUCCESS', 60,  '2026-03-16 09:20:00', '2026-03-16 09:21:00', '/logs/run-1089/build'),
(3, 'Unit Test',          2, 'RUNNING', NULL,'2026-03-16 09:21:00', NULL,                   '/logs/run-1089/test');


-- =============================================================
-- 14. 部署记录 deployments
-- =============================================================
INSERT INTO `deployments` (`id`, `service_id`, `environment_id`, `pipeline_run_id`, `version_tag`, `docker_image`, `deploy_type`, `status`, `deployed_by`, `approved_by`, `rollback_from_version`, `started_at`, `finished_at`) VALUES
(1,  1, 1, 1,  'v3.24.1', 'registry.company.com/mall/mall-backend:v3.24.1',    'ROLLING',  'SUCCESS',  6,  NULL, NULL,       '2026-03-15 10:14:50', '2026-03-15 10:15:26'),
(2,  1, 4, NULL,'v3.23.0', 'registry.company.com/mall/mall-backend:v3.23.0',    'BLUE_GREEN','SUCCESS', 3,  1,   NULL,       '2026-03-12 22:00:00', '2026-03-12 22:05:30'),
(3,  2, 6, 4,  'v2.15.3', 'registry.company.com/mall/mall-frontend:v2.15.3',   'ROLLING',  'SUCCESS',  7,  NULL, NULL,       '2026-03-13 20:00:00', '2026-03-13 20:02:15'),
(4,  5, 8, 5,  'v1.9.0',  'registry.company.com/cs/cs-engine:v1.9.0',          'CANARY',   'SUCCESS', 13,  1,   NULL,       '2026-03-14 21:00:00', '2026-03-14 21:08:00'),
(5,  4, 4, 10, 'v2.8.1',  'registry.company.com/mall/pay-service:v2.8.1',      'ROLLING',  'SUCCESS',  6,  3,   NULL,       '2026-03-14 17:00:00', '2026-03-14 17:03:45'),
(6, 13, 12,8,  'v0.6.0',  'registry.company.com/infra/infra-api:v0.6.0',       'ROLLING',  'SUCCESS', 16, NULL, NULL,       '2026-03-10 22:00:00', '2026-03-10 22:02:10'),
(7,  1, 4, NULL,'v3.22.0', 'registry.company.com/mall/mall-backend:v3.22.0',   'ROLLBACK', 'SUCCESS',  3,  1,   'v3.22.1', '2026-03-08 02:30:00', '2026-03-08 02:32:00');


-- =============================================================
-- 15. 事故 incidents
-- =============================================================
INSERT INTO `incidents` (`id`, `project_id`, `service_id`, `title`, `severity`, `incident_type`, `status`, `description`, `root_cause`, `resolution`, `reporter_user_id`, `assignee_user_id`, `started_at`, `resolved_at`) VALUES
(1, 1, 1, '商城首页接口超时 P99>5s',            'P1', 'PERFORMANCE', 'RESOLVED',
  '3月10日 20:12 商城首页商品推荐接口P99延迟突增至5.2秒，影响约15%用户',
  'Redis热key过期导致缓存击穿，大量请求打到MySQL',
  '增加热key永不过期策略+互斥锁防击穿，回滚至v3.22.0',
  12, 3, '2026-03-10 20:12:00', '2026-03-10 21:35:00'),
(2, 1, 4, '支付回调偶发超时',                    'P2', 'SYSTEM_ERROR', 'RESOLVED',
  '微信支付回调接口偶发504，约0.3%订单支付状态延迟更新',
  '回调处理中同步调用库存服务，库存服务偶发慢查询',
  '回调处理改为异步消息队列，库存扣减解耦',
  6, 6, '2026-03-06 14:30:00', '2026-03-07 11:00:00'),
(3, 2, 5, '客服AI回复包含幻觉信息',              'P2', 'AI_ANOMALY',  'MONITORING',
  '客户反馈AI客服回复了不存在的退货政策（7天无理由→30天无理由），已影响3位客户',
  '知识库中退货政策文档版本过旧，RAG召回了废弃文档',
  '更新知识库文档+增加文档版本校验+添加回复置信度阈值',
  11, 13, '2026-03-13 15:00:00', NULL),
(4, 5, 13, 'K8s集群Node NotReady告警',          'P1', 'INFRASTRUCTURE', 'RESOLVED',
  'prod-node-07 状态变为NotReady，12个Pod被驱逐重调度',
  '节点磁盘空间不足（日志未轮转），kubelet停止响应',
  '清理日志+配置logrotate+增加磁盘监控告警阈值',
  12, 16, '2026-03-09 03:15:00', '2026-03-09 04:20:00'),
(5, 4, 10, 'App启动白屏率突增',                  'P2', 'SYSTEM_ERROR', 'RESOLVED',
  'iOS 17.4更新后App启动白屏率从0.2%升至3.8%',
  'React Native Hermes引擎与iOS 17.4的内存管理存在兼容问题',
  '升级React Native至0.76.1+Hermes hotfix',
  18, 4, '2026-03-11 09:00:00', '2026-03-12 16:00:00');


-- =============================================================
-- 16. 知识库文档 knowledge_documents
-- =============================================================
INSERT INTO `knowledge_documents` (`id`, `scope_type`, `project_id`, `title`, `document_type`, `source_type`, `storage_url`, `file_name`, `file_ext`, `size_bytes`, `uploaded_by`, `status`, `created_at`) VALUES
-- 全局文档
( 1, 'GLOBAL',  NULL, '公司前端开发规范 v3.0',          'SPEC',        'MANUAL_UPLOAD', '/docs/global/frontend-spec-v3.pdf',       'frontend-spec-v3.pdf',      'pdf',  2548000,  4,  'ACTIVE', '2025-08-01 10:00:00'),
( 2, 'GLOBAL',  NULL, '公司后端Java编码规范',            'SPEC',        'MANUAL_UPLOAD', '/docs/global/java-coding-standard.pdf',   'java-coding-standard.pdf',  'pdf',  1820000,  3,  'ACTIVE', '2025-07-15 10:00:00'),
( 3, 'GLOBAL',  NULL, 'RESTful API设计规范',             'SPEC',        'MANUAL_UPLOAD', '/docs/global/restful-api-guideline.md',   'restful-api-guideline.md',  'md',    450000,  16, 'ACTIVE', '2025-06-20 10:00:00'),
( 4, 'GLOBAL',  NULL, 'Git分支管理与提交规范',           'SPEC',        'MANUAL_UPLOAD', '/docs/global/git-branch-guide.md',        'git-branch-guide.md',       'md',    280000,  16, 'ACTIVE', '2025-06-20 10:00:00'),
( 5, 'GLOBAL',  NULL, '公司信息安全管理制度',             'BUSINESS',    'MANUAL_UPLOAD', '/docs/global/security-policy.pdf',        'security-policy.pdf',       'pdf',  3200000,  1,  'ACTIVE', '2025-03-01 10:00:00'),
-- 商城项目文档
( 6, 'PROJECT', 1,   '商城中台架构设计文档',             'TECHNICAL',   'MANUAL_UPLOAD', '/docs/mall/architecture-design.md',       'architecture-design.md',    'md',    680000,  3,  'ACTIVE', '2025-02-01 10:00:00'),
( 7, 'PROJECT', 1,   '商品模块API文档 v3.24',            'TECHNICAL',   'AI_GENERATED',  '/docs/mall/product-api-v3.24.json',       'product-api-v3.24.json',    'json', 1250000,  3,  'ACTIVE', '2026-03-12 10:00:00'),
( 8, 'PROJECT', 1,   '会员体系PRD v2.0',                 'REQUIREMENT', 'MANUAL_UPLOAD', '/docs/mall/member-prd-v2.pdf',            'member-prd-v2.pdf',         'pdf',  4800000,  5,  'ACTIVE', '2026-01-15 10:00:00'),
( 9, 'PROJECT', 1,   '支付对账方案技术选型',             'TECHNICAL',   'MANUAL_UPLOAD', '/docs/mall/pay-reconciliation.md',        'pay-reconciliation.md',     'md',    320000,  6,  'ACTIVE', '2025-08-01 10:00:00'),
-- 智能客服项目文档
(10, 'PROJECT', 2,   '智能客服系统架构文档',             'TECHNICAL',   'MANUAL_UPLOAD', '/docs/cs/cs-architecture.md',             'cs-architecture.md',        'md',    520000, 13,  'ACTIVE', '2025-04-01 10:00:00'),
(11, 'PROJECT', 2,   '客服话术知识库（退换货）',         'BUSINESS',    'MANUAL_UPLOAD', '/docs/cs/return-policy-knowledge.md',     'return-policy-knowledge.md','md',    180000, 11,  'ACTIVE', '2025-05-15 10:00:00'),
(12, 'PROJECT', 2,   'RAG检索策略调优报告',              'TECHNICAL',   'AI_GENERATED',  '/docs/cs/rag-tuning-report-202603.pdf',   'rag-tuning-report.pdf',     'pdf',   890000, 13,  'ACTIVE', '2026-03-10 10:00:00'),
-- 数据分析平台文档
(13, 'PROJECT', 3,   '数据仓库表结构说明',               'TECHNICAL',   'MANUAL_UPLOAD', '/docs/data/dw-schema.md',                'dw-schema.md',              'md',    750000,  8,  'ACTIVE', '2025-07-01 10:00:00'),
(14, 'PROJECT', 3,   'NL2SQL Prompt工程实践',            'TECHNICAL',   'AI_GENERATED',  '/docs/data/nl2sql-prompt-engineering.md', 'nl2sql-prompt-engineering.md','md',   420000,  8,  'ACTIVE', '2026-02-20 10:00:00');


-- =============================================================
-- 17. 项目启用全局知识文档 project_knowledge_globals
-- =============================================================
INSERT INTO `project_knowledge_globals` (`project_id`, `document_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 2), (2, 3), (2, 5),
(3, 3), (3, 5),
(4, 1), (4, 3), (4, 4),
(5, 3), (5, 4), (5, 5);


-- =============================================================
-- 18. 项目Skill配置 project_skills
-- =============================================================
INSERT INTO `project_skills` (`project_id`, `skill_id`, `is_enabled`) VALUES
-- 商城中台：全部启用
(1, 1, 1), (1, 2, 1), (1, 3, 1), (1, 4, 1), (1, 5, 1), (1, 6, 1),
-- 智能客服：Code Review + 故障诊断 + 单元测试 + BI查询
(2, 1, 1), (2, 3, 1), (2, 4, 1), (2, 7, 1),
-- 数据分析平台
(3, 1, 1), (3, 2, 1), (3, 4, 1), (3, 7, 1),
-- 移动商城App
(4, 1, 1), (4, 4, 1), (4, 6, 1),
-- 基础设施平台
(5, 1, 1), (5, 2, 1), (5, 3, 1), (5, 4, 1), (5, 6, 1);


-- =============================================================
-- 19. 项目关联原子能力 project_atomic_capabilities
-- =============================================================
INSERT INTO `project_atomic_capabilities` (`project_id`, `capability_id`, `integration_status`, `integrated_by`) VALUES
-- 商城中台：短信+邮件+OSS+SSO+支付
(1, 1, 'INTEGRATED', 'MANUAL'),
(1, 2, 'INTEGRATED', 'MANUAL'),
(1, 3, 'INTEGRATED', 'MANUAL'),
(1, 4, 'INTEGRATED', 'MANUAL'),
(1, 5, 'INTEGRATED', 'MANUAL'),
-- 智能客服：SSO+OSS
(2, 3, 'INTEGRATED', 'MANUAL'),
(2, 4, 'INTEGRATED', 'AI_GENERATED'),
-- 数据分析平台：SSO+BI查询+邮件
(3, 2, 'INTEGRATED', 'MANUAL'),
(3, 4, 'INTEGRATED', 'MANUAL'),
(3, 6, 'INTEGRATED', 'MANUAL'),
-- 移动商城App：SSO+支付+短信+OSS
(4, 1, 'INTEGRATED', 'AI_GENERATED'),
(4, 3, 'INTEGRATED', 'MANUAL'),
(4, 4, 'INTEGRATED', 'MANUAL'),
(4, 5, 'PENDING',    'MANUAL'),
-- 基础设施平台：SSO
(5, 4, 'INTEGRATED', 'MANUAL');


-- =============================================================
-- 20. 工作流节点 workflow_nodes（为前2个工作流补充完整节点）
-- =============================================================
INSERT INTO `workflow_nodes` (`workflow_id`, `node_key`, `node_type`, `label`, `icon`, `node_order`, `config_json`, `parent_node_key`, `branch_label`) VALUES
-- 代码 Review Agent (workflow_id=1)
(1, 'trigger_pr',     'TRIGGER',   'PR 创建/更新',       '🔔', 1, '{"event":"pull_request.opened"}', NULL, NULL),
(1, 'understand_diff','LLM',       '理解代码变更',       '🧠', 2, '{"model":"claude-sonnet-4-6","prompt":"分析PR变更内容"}', NULL, NULL),
(1, 'search_spec',    'TOOL',      '搜索编码规范',       '🔍', 3, '{"tool":"search_knowledge","query":"编码规范"}', NULL, NULL),
(1, 'check_complex',  'CONDITION', '是否复杂变更?',      '❓', 4, '{"condition":"changed_files > 10 || has_security_change"}', NULL, NULL),
(1, 'deep_review',    'LLM',       '深度安全+架构审查',  '🔬', 5, '{"model":"claude-opus-4-6"}', 'check_complex', 'YES · 深度审查'),
(1, 'standard_review','LLM',       '标准质量审查',       '📝', 5, '{"model":"claude-sonnet-4-6"}', 'check_complex', 'NO · 标准审查'),
(1, 'post_comment',   'TOOL',      '发布Review评论',     '💬', 6, '{"tool":"post_review_comment"}', NULL, NULL),
(1, 'human_confirm',  'HUMAN',     '人工确认',           '👤', 7, '{"timeout_hours":24}', NULL, NULL),
-- Bug 诊断修复 Agent (workflow_id=2)
(2, 'trigger_alert',  'TRIGGER',   '报警触发',           '🚨', 1, '{"event":"alert.firing"}', NULL, NULL),
(2, 'analyze_logs',   'TOOL',      '日志分析',           '📋', 2, '{"tool":"query_metrics","query":"error logs last 30min"}', NULL, NULL),
(2, 'locate_root',    'LLM',       '根因定位',           '🎯', 3, '{"model":"claude-sonnet-4-6","prompt":"分析日志定位根因"}', NULL, NULL),
(2, 'gen_fix',        'LLM',       '生成修复代码',       '🔧', 4, '{"model":"claude-sonnet-4-6","prompt":"生成修复patch"}', NULL, NULL),
(2, 'human_approve',  'HUMAN',     '人工审批修复方案',   '👤', 5, '{"timeout_hours":4}', NULL, NULL),
(2, 'create_pr',      'TOOL',      '提交PR',             '📤', 6, '{"tool":"create_pull_request"}', NULL, NULL);


-- =============================================================
-- 21. 工作流执行记录 workflow_executions
-- =============================================================
INSERT INTO `workflow_executions` (`id`, `execution_no`, `workflow_id`, `project_id`, `trigger_source`, `current_node_key`, `total_steps`, `completed_steps`, `total_tokens`, `total_cost`, `duration_seconds`, `status`, `error_message`, `started_at`, `finished_at`) VALUES
-- 代码Review Agent执行
( 1, 'EX-1042', 1, 1, 'mall-backend PR#312 积分兑换接口',          'human_confirm', 7, 6, 28500,  0.1520, 185,  'WAITING_APPROVAL', NULL,                '2026-03-16 09:22:00', NULL),
( 2, 'EX-1041', 1, 1, 'mall-backend PR#310 搜索联想词',            NULL,            7, 7, 15200,  0.0780, 92,   'SUCCESS',          NULL,                '2026-03-15 10:30:00', '2026-03-15 10:31:32'),
( 3, 'EX-1040', 1, 2, 'cs-engine PR#89 对话上下文管理',            'human_confirm', 7, 6, 32100,  0.1850, 210,  'WAITING_APPROVAL', NULL,                '2026-03-16 08:50:00', NULL),
-- Bug诊断Agent执行
( 4, 'EX-1038', 2, 1, '商城首页接口超时告警',                      NULL,            6, 6, 45000,  0.2400, 320,  'SUCCESS',          NULL,                '2026-03-10 20:15:00', '2026-03-10 20:20:20'),
( 5, 'EX-1039', 2, 5, 'K8s Node NotReady告警 prod-node-07',       NULL,            6, 6, 38200,  0.2050, 280,  'SUCCESS',          NULL,                '2026-03-09 03:18:00', '2026-03-09 03:22:40'),
-- 需求拆分Agent执行
( 6, 'EX-1035', 3, 1, '会员体系PRD v2.0上传',                     NULL,            5, 5, 52000,  0.3100, 240,  'SUCCESS',          NULL,                '2026-01-16 10:00:00', '2026-01-16 10:04:00'),
-- Sprint日报Agent
( 7, 'EX-1043', 5, NULL, '每日定时触发 2026-03-15',                NULL,            4, 4, 18500,  0.0950, 65,   'SUCCESS',          NULL,                '2026-03-15 18:00:00', '2026-03-15 18:01:05'),
-- 接口文档同步Agent（失败）
( 8, 'EX-1036', 6, 1, 'mall-backend commit a3b7c9d2',            'parse_code',    4, 1, 8200,   0.0420, 45,   'FAILED',           '解析Java注解失败: 无法识别自定义@ApiTag注解', '2026-03-15 10:20:00', '2026-03-15 10:20:45'),
-- 正在运行
( 9, 'EX-1044', 1, 4, 'mobile-rn PR#156 推送通知SDK',            'understand_diff',7, 2, 12000,  0.0600, NULL, 'RUNNING',          NULL,                '2026-03-16 09:30:00', NULL);


-- =============================================================
-- 22. 工作流执行步骤 workflow_execution_steps（为EX-1042补充完整步骤）
-- =============================================================
INSERT INTO `workflow_execution_steps` (`execution_id`, `node_key`, `step_order`, `node_type`, `label`, `model_code`, `input_tokens`, `output_tokens`, `duration_ms`, `output_text`, `tool_name`, `tool_input`, `status`, `started_at`, `finished_at`) VALUES
-- EX-1042: 代码Review Agent → mall-backend PR#312
(1, 'trigger_pr',      1, 'TRIGGER',   'PR 创建/更新',       NULL,               0,    0,    120,   'PR#312 opened by zhengkai: 积分兑换接口开发', NULL, NULL, 'SUCCESS', '2026-03-16 09:22:00', '2026-03-16 09:22:00'),
(1, 'understand_diff', 2, 'LLM',       '理解代码变更',       'claude-sonnet-4-6', 8200, 1500, 4500, '变更涉及3个文件: PointsExchangeController.java, PointsService.java, PointsServiceTest.java。新增积分查询、兑换和记录查询3个REST接口，含事务管理和库存校验逻辑。', NULL, NULL, 'SUCCESS', '2026-03-16 09:22:01', '2026-03-16 09:22:05'),
(1, 'search_spec',     3, 'TOOL',      '搜索编码规范',       NULL,               0,    0,    850,   '找到3份相关文档: Java编码规范(相关度0.95), RESTful API设计规范(0.91), Git提交规范(0.72)', 'search_knowledge', '{"query":"Java编码规范 REST接口规范","top_k":5}', 'SUCCESS', '2026-03-16 09:22:06', '2026-03-16 09:22:07'),
(1, 'check_complex',   4, 'CONDITION', '是否复杂变更?',      NULL,               0,    0,    50,    '变更文件数=3, has_security_change=false → 标准审查', NULL, NULL, 'SUCCESS', '2026-03-16 09:22:07', '2026-03-16 09:22:07'),
(1, 'standard_review', 5, 'LLM',       '标准质量审查',       'claude-sonnet-4-6', 12000,3800, 8200, '## Code Review 结果\n\n### 优点\n- 事务管理正确使用@Transactional\n- 积分校验逻辑清晰\n\n### 需改进\n1. PointsService.exchange() 缺少并发控制，高并发下可能超额兑换\n2. 建议增加分布式锁或乐观锁\n3. PointsServiceTest 缺少边界条件测试（积分为0、负数等）', NULL, NULL, 'SUCCESS', '2026-03-16 09:22:08', '2026-03-16 09:22:16'),
(1, 'post_comment',    6, 'TOOL',      '发布Review评论',     NULL,               0,    0,    1200,  '已发布Review评论至PR#312，包含2条行内评论和1条总体评论', 'post_review_comment', '{"pr_id":312,"comments":[...]}', 'SUCCESS', '2026-03-16 09:22:16', '2026-03-16 09:22:17'),
(1, 'human_confirm',   7, 'HUMAN',     '人工确认',           NULL,               0,    0,    NULL,  NULL, NULL, NULL, 'WAITING', '2026-03-16 09:22:18', NULL);


-- =============================================================
-- 23. Tool调用日志 tool_invocation_logs
-- =============================================================
INSERT INTO `tool_invocation_logs` (`tool_id`, `execution_id`, `caller_name`, `input_params`, `output_result`, `duration_ms`, `status`, `invoked_at`) VALUES
(1, 1, '代码Review Agent', '{"query":"Java编码规范 REST接口","top_k":5}', '{"results":[{"title":"Java编码规范","score":0.95},{"title":"RESTful API设计规范","score":0.91}]}', 850, 'SUCCESS', '2026-03-16 09:22:06'),
(4, 1, '代码Review Agent', '{"pr_id":312,"repo":"mall-backend","body":"## AI Code Review..."}', '{"comment_id":1856,"url":"https://git.company.com/mall/mall-backend/pull/312#review-1856"}', 1200, 'SUCCESS', '2026-03-16 09:22:16'),
(6, 4, 'Bug诊断修复Agent', '{"service":"mall-backend","metric":"error_rate","range":"30m"}', '{"error_rate":12.5,"p99_latency":5200,"top_errors":["RedisConnectionException","CacheNullPointer"]}', 2300, 'SUCCESS', '2026-03-10 20:15:30'),
(1, 4, 'Bug诊断修复Agent', '{"query":"Redis缓存击穿 解决方案","top_k":3}', '{"results":[{"title":"Redis高可用方案","score":0.88}]}', 680, 'SUCCESS', '2026-03-10 20:16:00'),
(3, 6, '需求拆分Agent',    '{"project_id":1,"sprint_id":2,"title":"会员等级计算引擎","points":8}', '{"task_id":1,"status":"created"}', 320, 'SUCCESS', '2026-01-16 10:02:30'),
(3, 6, '需求拆分Agent',    '{"project_id":1,"sprint_id":2,"title":"会员权益配置后台","points":5}', '{"task_id":2,"status":"created"}', 280, 'SUCCESS', '2026-01-16 10:02:35'),
(5, NULL, '手动触发',       '{"service":"mall-backend","env":"PROD","version":"v3.23.0"}', '{"deployment_id":2,"status":"triggered"}', 1500, 'SUCCESS', '2026-03-12 21:55:00'),
(7, NULL, 'IDE-Cursor',     '{"title":"iOS键盘遮挡搜索框","project_id":4,"severity":"P0"}', '{"incident_id":5,"status":"created"}', 450, 'SUCCESS', '2026-03-11 09:05:00'),
(1, NULL, 'Cursor插件',     '{"query":"React Native Hermes iOS兼容","top_k":5}', '{"results":[]}', 520, 'SUCCESS', '2026-03-11 10:00:00'),
(6, NULL, 'Claude Code',    '{"service":"infra-api","metric":"cpu_usage","range":"1h"}', '{"avg_cpu":78.5,"peak_cpu":95.2,"pods":3}', 1800, 'SUCCESS', '2026-03-09 03:20:00');


-- =============================================================
-- 24. AI评估分数 ai_eval_scores
-- =============================================================
INSERT INTO `ai_eval_scores` (`eval_target_type`, `eval_target_id`, `eval_target_name`, `eval_period`, `overall_score`, `grade`, `detail_json`, `improvement_suggestion`) VALUES
('WORKFLOW', 1, '代码Review Agent', '2026-03', 91.20, 'A',
  '{"安全漏洞识别率":94,"规范违反识别率":96,"误报率":8,"平均响应时间":"12s","开发者采纳率":85}',
  '建议增加对并发安全问题的检测能力，当前对锁机制和竞态条件的识别能力较弱'),
('WORKFLOW', 2, 'Bug诊断修复Agent', '2026-03', 87.50, 'B',
  '{"根因定位准确率":82,"修复建议可用率":78,"平均诊断时间":"45s","一次修复成功率":65}',
  '对分布式系统的跨服务链路追踪能力不足，建议集成Jaeger/SkyWalking trace数据'),
('WORKFLOW', 3, '需求拆分Agent', '2026-03', 76.30, 'C',
  '{"Story拆分合理性":72,"SP估算偏差率":25,"任务遗漏率":15,"PRD理解准确率":85}',
  'Story Points估算偏差较大，建议引入历史Sprint数据作为校准参考'),
('WORKFLOW', 5, 'Sprint日报Agent', '2026-03', 93.00, 'A',
  '{"数据准确率":98,"报告完整性":95,"生成速度":"8s","格式规范性":90}',
  '建议增加异常指标自动高亮和趋势对比'),
('SKILL',    1, 'Code Review',     '2026-03', 89.60, 'B',
  '{"代码质量问题发现率":91,"安全问题发现率":88,"性能问题发现率":82,"代码风格一致性":95}',
  '对性能问题的检测可进一步加强，特别是N+1查询和内存泄漏场景'),
('SKILL',    3, '故障诊断',        '2026-03', 84.20, 'B',
  '{"日志分析准确率":88,"根因定位率":79,"修复建议可行性":82,"响应速度":"30s"}',
  '对微服务间调用链的故障传播分析能力需要增强'),
('MODEL',    1, 'Claude Sonnet 4.6','2026-03', 92.50, 'A',
  '{"代码生成质量":94,"指令遵循率":96,"中文理解":90,"上下文利用":93,"幻觉率":5}',
  '中文技术文档生成偶有术语翻译不够准确，建议配合领域词典'),
('MODEL',    5, 'GPT-4.1 Mini',    '2026-03', 78.80, 'C',
  '{"代码生成质量":76,"指令遵循率":82,"中文理解":72,"上下文利用":80,"幻觉率":12}',
  '作为经济模型用于简单Code Review和文档生成表现尚可，不建议用于复杂推理任务');


-- =============================================================
-- 25. 项目AI策略 project_ai_policies
-- =============================================================
INSERT INTO `project_ai_policies` (`project_id`, `default_provider_id`, `default_model_id`, `fallback_provider_id`, `fallback_model_id`, `monthly_token_quota`, `monthly_cost_quota`, `over_quota_strategy`, `status`) VALUES
(1, 2, 1, 6, 9,  3000000, 50.00, 'DOWNGRADE_MODEL', 'ACTIVE'),
(2, 2, 1, 2, 2,  5000000, 80.00, 'ALLOW_WITH_ALERT', 'ACTIVE'),
(3, 2, 1, 1, 5,  2000000, 30.00, 'DOWNGRADE_MODEL', 'ACTIVE'),
(4, 2, 1, 6, 9,  1500000, 25.00, 'BLOCK',            'ACTIVE'),
(5, 2, 2, 6, 9,  1000000, 15.00, 'DOWNGRADE_MODEL', 'ACTIVE');


-- =============================================================
-- 26. 项目成员AI额度 project_member_ai_quotas
-- =============================================================
INSERT INTO `project_member_ai_quotas` (`project_id`, `user_id`, `monthly_token_quota`, `monthly_cost_quota`, `used_tokens_this_month`, `used_cost_this_month`) VALUES
(1, 3,  800000, 15.00, 425000, 7.80),
(1, 6,  600000, 10.00, 580200, 9.65),
(1, 7,  400000, 8.00,  210000, 3.50),
(1, 10, 500000, 8.00,  320000, 5.30),
(2, 13, 1200000,20.00, 890000, 14.50),
(2, 15, 800000, 12.00, 560000, 9.20),
(3, 8,  600000, 10.00, 380000, 6.10),
(3, 17, 500000, 8.00,  420000, 6.80),
(4, 4,  500000, 8.00,  180000, 2.90),
(4, 18, 400000, 6.00,  350000, 5.60);


-- =============================================================
-- 27. MCP配置 project_mcp_configs（服务级MCP接入）
-- =============================================================
INSERT INTO `project_mcp_configs` (`project_id`, `service_id`, `endpoint_url`, `transport_type`, `auth_mode`, `status`, `last_used_at`) VALUES
(1, 1,  'https://mcp.company.com/mall/backend',    'STREAMABLE_HTTP', 'TOKEN', 'ACTIVE',   '2026-03-16 09:30:00'),
(1, 2,  'https://mcp.company.com/mall/frontend',   'STREAMABLE_HTTP', 'TOKEN', 'ACTIVE',   '2026-03-15 18:00:00'),
(2, 5,  'https://mcp.company.com/cs/engine',       'STREAMABLE_HTTP', 'OAUTH', 'ACTIVE',   '2026-03-16 08:50:00'),
(3, 8,  'https://mcp.company.com/data/analytics',  'SSE',             'TOKEN', 'ACTIVE',   '2026-03-15 14:30:00'),
(5, 13, 'https://mcp.company.com/infra/api',       'STREAMABLE_HTTP', 'TOKEN', 'ACTIVE',   '2026-03-15 16:20:00'),
(4, 10, 'https://mcp.company.com/mobile/rn',       'STREAMABLE_HTTP', 'TOKEN', 'DISABLED', '2026-03-10 12:00:00');


-- =============================================================
-- 28. 客户端接入策略 project_client_policies
-- =============================================================
INSERT INTO `project_client_policies` (`project_id`, `client_app_id`, `is_enabled`, `policy_json`) VALUES
(1, 1, 1, '{"allowed_models":["claude-sonnet-4-6","deepseek-v3"],"max_tokens_per_request":8000}'),
(1, 2, 1, '{"allowed_models":["claude-sonnet-4-6","claude-opus-4-6"],"max_tokens_per_request":16000}'),
(2, 1, 1, '{"allowed_models":["claude-sonnet-4-6"],"max_tokens_per_request":8000}'),
(2, 2, 1, '{"allowed_models":["claude-sonnet-4-6","claude-opus-4-6"],"max_tokens_per_request":16000}'),
(3, 2, 1, '{"allowed_models":["claude-sonnet-4-6"],"max_tokens_per_request":8000}'),
(4, 1, 1, '{"allowed_models":["claude-sonnet-4-6","gpt-4.1-mini"],"max_tokens_per_request":8000}'),
(5, 2, 1, '{"allowed_models":["claude-haiku-4-5","deepseek-v3"],"max_tokens_per_request":4000}');


-- =============================================================
-- 29. 用户客户端绑定 user_client_bindings
-- =============================================================
INSERT INTO `user_client_bindings` (`user_id`, `client_app_id`, `external_user_id`, `binding_metadata`, `status`) VALUES
( 3, 1, 'cursor_wangqiang_8f3a',  '{"license":"pro","version":"0.48"}',         'ACTIVE'),
( 3, 2, 'cc_wangqiang_d2e1',      '{"version":"1.0.24"}',                       'ACTIVE'),
( 4, 1, 'cursor_liuyang_7b2c',    '{"license":"pro","version":"0.48"}',         'ACTIVE'),
( 6, 1, 'cursor_zhaolei_9d4e',    '{"license":"pro","version":"0.47"}',         'ACTIVE'),
( 6, 2, 'cc_zhaolei_a1f3',        '{"version":"1.0.24"}',                       'ACTIVE'),
( 7, 1, 'cursor_sunyue_c5b8',     '{"license":"business","version":"0.48"}',    'ACTIVE'),
(10, 1, 'cursor_zhengkai_e7d2',   '{"license":"pro","version":"0.48"}',         'ACTIVE'),
(13, 2, 'cc_linxiao_b4c9',        '{"version":"1.0.24"}',                       'ACTIVE'),
(15, 1, 'cursor_gaoming_f1a6',    '{"license":"pro","version":"0.48"}',         'ACTIVE'),
(16, 2, 'cc_xiefeng_d8e5',        '{"version":"1.0.23"}',                       'ACTIVE'),
(18, 1, 'cursor_yangfan_g3h7',    '{"license":"pro","version":"0.48"}',         'ACTIVE'),
( 8, 2, 'cc_zhoujie_i9j1',        '{"version":"1.0.24"}',                       'ACTIVE'),
(12, 2, 'cc_mafei_k2l4',          '{"version":"1.0.24"}',                       'ACTIVE');


-- =============================================================
-- 30. 平台访问令牌 platform_access_tokens
-- =============================================================
INSERT INTO `platform_access_tokens` (`project_id`, `user_id`, `client_app_id`, `token_name`, `token_type`, `token_prefix`, `token_hash`, `expires_at`, `last_used_at`, `status`) VALUES
(1, NULL, NULL, '商城中台 MCP Token',      'PROJECT_MCP',      'pat_mall_',    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '2026-12-31 23:59:59', '2026-03-16 09:30:00', 'ACTIVE'),
(2, NULL, NULL, '智能客服 MCP Token',      'PROJECT_MCP',      'pat_cs_',      'a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a', '2026-12-31 23:59:59', '2026-03-16 08:50:00', 'ACTIVE'),
(5, NULL, NULL, '基础设施 MCP Token',      'PROJECT_MCP',      'pat_infra_',   'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35', '2026-12-31 23:59:59', '2026-03-15 16:20:00', 'ACTIVE'),
(NULL, 3, 1,    '王强 Cursor AI Token',    'AI_GATEWAY',       'gw_wq_',       '4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce', '2026-06-30 23:59:59', '2026-03-16 09:25:00', 'ACTIVE'),
(NULL, 6, 1,    '赵磊 Cursor AI Token',    'AI_GATEWAY',       'gw_zl_',       '4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdbe514', '2026-06-30 23:59:59', '2026-03-16 09:18:00', 'ACTIVE'),
(NULL, 13,2,    '林晓 Claude Code Token',  'AI_GATEWAY',       'gw_lx_',       'ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d', '2026-06-30 23:59:59', '2026-03-16 08:45:00', 'ACTIVE'),
(1, NULL, 1,    'Cursor Bootstrap Token',  'CLIENT_BOOTSTRAP', 'boot_cursor_', 'e7f6c011776e8db7cd330b54174fd76f7d0216b612387a5ffcfb81e6f0919683', '2027-01-01 00:00:00', '2026-03-15 09:00:00', 'ACTIVE'),
(NULL, 16, 2,   '谢峰 Claude Code Token(过期)', 'AI_GATEWAY',  'gw_xf_old_',   '7902699be42c8a8e46fbbb4501726517e86b22c56a189f7625a6da49081b2451', '2026-02-28 23:59:59', '2026-02-25 16:00:00', 'EXPIRED');


-- =============================================================
-- 31. AI用量明细 ai_usage_events（最近2天约50条）
-- =============================================================
INSERT INTO `ai_usage_events` (`project_id`, `user_id`, `client_app_id`, `provider_id`, `model_id`, `source_type`, `request_mode`, `enforcement_level`, `request_id`, `conversation_id`, `input_tokens`, `output_tokens`, `total_tokens`, `cost_amount`, `currency`, `status`, `occurred_at`) VALUES
-- 3月15日
(1, 6,  1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a001', 'conv_z001', 3200,  1800,  5000,  0.036600, 'USD', 'SUCCESS', '2026-03-15 09:15:00'),
(1, 6,  1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a002', 'conv_z001', 4500,  2200,  6700,  0.046500, 'USD', 'SUCCESS', '2026-03-15 09:25:00'),
(1, 10, 1, 2, 1, 'CLIENT_ADMIN_API', 'CHAT',      'SOFT_LIMITED',  'req_a003', 'conv_z002', 1800,  900,   2700,  0.018900, 'USD', 'SUCCESS', '2026-03-15 09:30:00'),
(1, 3,  2, 2, 3, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a004', 'conv_z003', 8500,  4200,  12700, 0.442500, 'USD', 'SUCCESS', '2026-03-15 10:00:00'),
(1, 7,  1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a005', 'conv_z004', 2800,  1500,  4300,  0.030900, 'USD', 'SUCCESS', '2026-03-15 10:15:00'),
(2, 13, 2, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a006', 'conv_z005', 6200,  3800,  10000, 0.075600, 'USD', 'SUCCESS', '2026-03-15 10:30:00'),
(2, 15, 1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a007', 'conv_z006', 3500,  1900,  5400,  0.039000, 'USD', 'SUCCESS', '2026-03-15 11:00:00'),
(1, NULL,NULL,2, 1, 'PLATFORM_MCP',  'MCP_TOOL',  'HARD_ENFORCED', 'req_a008', NULL,        8200,  1500,  9700,  0.047100, 'USD', 'SUCCESS', '2026-03-15 10:30:00'),
(3, 8,  2, 2, 1, 'CLIENT_ADMIN_API', 'CHAT',      'SOFT_LIMITED',  'req_a009', 'conv_z007', 5500,  2800,  8300,  0.058500, 'USD', 'SUCCESS', '2026-03-15 14:00:00'),
(3, 17, 2, 6, 9, 'CLIENT_ADMIN_API', 'CHAT',      'OBSERVE_ONLY',  'req_a010', 'conv_z008', 4000,  2000,  6000,  0.003280, 'USD', 'SUCCESS', '2026-03-15 14:30:00'),
(1, 6,  1, 6, 9, 'CLIENT_ADMIN_API', 'CODE',      'OBSERVE_ONLY',  'req_a011', 'conv_z009', 5500,  3000,  8500,  0.004785, 'USD', 'SUCCESS', '2026-03-15 14:45:00'),
(2, 13, 2, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a012', 'conv_z010', 7800,  4500,  12300, 0.090900, 'USD', 'SUCCESS', '2026-03-15 15:00:00'),
(4, 18, 1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a013', 'conv_z011', 4200,  2100,  6300,  0.044100, 'USD', 'SUCCESS', '2026-03-15 15:10:00'),
(4, 4,  1, 2, 1, 'CLIENT_ADMIN_API', 'CHAT',      'SOFT_LIMITED',  'req_a014', 'conv_z012', 2000,  1200,  3200,  0.024000, 'USD', 'SUCCESS', '2026-03-15 15:30:00'),
(5, 16, 2, 2, 2, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a015', 'conv_z013', 3800,  2200,  6000,  0.011840, 'USD', 'SUCCESS', '2026-03-15 16:00:00'),
(5, 12, 2, 2, 2, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a016', 'conv_z014', 2900,  1500,  4400,  0.008320, 'USD', 'SUCCESS', '2026-03-15 16:30:00'),
(1, NULL,NULL,2, 1, 'PLATFORM_MCP',  'MCP_TOOL',  'HARD_ENFORCED', 'req_a017', NULL,        12000, 3800,  15800, 0.093000, 'USD', 'SUCCESS', '2026-03-15 17:00:00'),
(2, NULL,NULL,2, 1, 'PLATFORM_MCP',  'MCP_TOOL',  'HARD_ENFORCED', 'req_a018', NULL,        6200,  1500,  7700,  0.041100, 'USD', 'SUCCESS', '2026-03-15 17:10:00'),
(1, 6,  1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_a019', 'conv_z015', 5800,  3200,  9000,  0.065400, 'USD', 'SUCCESS', '2026-03-15 17:30:00'),
(1, 10, 1, 6, 9, 'CLIENT_ADMIN_API', 'CODE',      'OBSERVE_ONLY',  'req_a020', 'conv_z016', 6200,  3500,  9700,  0.005524, 'USD', 'SUCCESS', '2026-03-15 17:45:00'),
-- 3月16日（今天）
(1, 6,  1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b001', 'conv_y001', 4800,  2500,  7300,  0.051900, 'USD', 'SUCCESS', '2026-03-16 08:30:00'),
(2, 13, 2, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b002', 'conv_y002', 8500,  5200,  13700, 0.103500, 'USD', 'SUCCESS', '2026-03-16 08:45:00'),
(2, 15, 1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b003', 'conv_y003', 3200,  1800,  5000,  0.036600, 'USD', 'SUCCESS', '2026-03-16 08:50:00'),
(1, NULL,NULL,2, 1, 'PLATFORM_MCP',  'MCP_TOOL',  'HARD_ENFORCED', 'req_b004', NULL,        8200,  3800,  12000, 0.081600, 'USD', 'SUCCESS', '2026-03-16 09:22:00'),
(1, 10, 1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b005', 'conv_y004', 5500,  2800,  8300,  0.058500, 'USD', 'SUCCESS', '2026-03-16 09:00:00'),
(1, 3,  2, 2, 1, 'CLIENT_ADMIN_API', 'CHAT',      'SOFT_LIMITED',  'req_b006', 'conv_y005', 2200,  1500,  3700,  0.029100, 'USD', 'SUCCESS', '2026-03-16 09:10:00'),
(4, 18, 1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b007', 'conv_y006', 6000,  3200,  9200,  0.066000, 'USD', 'SUCCESS', '2026-03-16 09:15:00'),
(3, 8,  2, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b008', 'conv_y007', 7200,  4000,  11200, 0.081600, 'USD', 'SUCCESS', '2026-03-16 09:20:00'),
(5, 16, 2, 6, 9, 'CLIENT_ADMIN_API', 'CODE',      'OBSERVE_ONLY',  'req_b009', 'conv_y008', 4500,  2500,  7000,  0.003965, 'USD', 'SUCCESS', '2026-03-16 09:25:00'),
(4, 4,  1, 2, 1, 'CLIENT_ADMIN_API', 'CODE',      'SOFT_LIMITED',  'req_b010', 'conv_y010', 3800,  2000,  5800,  0.041400, 'USD', 'SUCCESS', '2026-03-16 09:30:00'),
-- 被拦截的请求
(1, 10, 1, 2, 1, 'CLIENT_ADMIN_API', 'CHAT',      'HARD_ENFORCED', 'req_b011', 'conv_y011', 0,     0,     0,     0.000000, 'USD', 'BLOCKED', '2026-03-16 09:35:00');


-- =============================================================
-- 32. AI用量日聚合 ai_usage_daily（最近7天）
-- =============================================================
INSERT INTO `ai_usage_daily` (`stat_date`, `dimension_key`, `project_id`, `user_id`, `client_app_id`, `provider_id`, `model_id`, `source_type`, `total_requests`, `success_requests`, `blocked_requests`, `input_tokens`, `output_tokens`, `total_tokens`, `cost_amount`) VALUES
-- 按项目维度聚合
('2026-03-10', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 85,  84, 1, 320000,  180000, 500000, 3.850000),
('2026-03-11', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 92,  92, 0, 345000,  195000, 540000, 4.120000),
('2026-03-12', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 78,  78, 0, 290000,  165000, 455000, 3.480000),
('2026-03-13', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 105, 104,1, 395000,  225000, 620000, 4.750000),
('2026-03-14', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 98,  98, 0, 370000,  210000, 580000, 4.430000),
('2026-03-15', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 110, 110,0, 415000,  235000, 650000, 4.980000),
('2026-03-16', 'proj:1', 1, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 45,  44, 1, 168000,  95000,  263000, 2.010000),
('2026-03-10', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 62,  62, 0, 280000,  165000, 445000, 3.550000),
('2026-03-11', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 70,  70, 0, 315000,  185000, 500000, 3.980000),
('2026-03-12', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 55,  55, 0, 248000,  145000, 393000, 3.120000),
('2026-03-13', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 68,  68, 0, 306000,  180000, 486000, 3.860000),
('2026-03-14', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 72,  72, 0, 324000,  190000, 514000, 4.080000),
('2026-03-15', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 65,  65, 0, 292000,  172000, 464000, 3.690000),
('2026-03-16', 'proj:2', 2, NULL, NULL, NULL, NULL, 'CLIENT_ADMIN_API', 28,  28, 0, 126000,  74000,  200000, 1.590000),
-- 平台MCP维度
('2026-03-15', 'mcp:platform', NULL, NULL, NULL, 2, 1, 'PLATFORM_MCP', 18, 18, 0, 52000, 15600, 67600, 0.390000),
('2026-03-16', 'mcp:platform', NULL, NULL, NULL, 2, 1, 'PLATFORM_MCP', 8,  8,  0, 24000, 9200,  33200, 0.192000);


-- =============================================================
-- 33. 安全事件 security_events
-- =============================================================
INSERT INTO `security_events` (`rule_id`, `title`, `severity`, `user_id`, `project_id`, `description`, `resolution_status`, `resolution_note`, `occurred_at`) VALUES
(1, 'AI对话含数据库密码明文',           'CRITICAL', 10, 1,
  '用户郑凯在Cursor中向AI发送了包含MySQL root密码的代码片段，已自动屏蔽敏感内容',
  'AUTO_HANDLED', '敏感信息已自动替换为***，原始请求未发送至LLM', '2026-03-14 10:25:00'),
(2, '疑似核心算法代码外发',             'WARNING',  13, 2,
  '用户林晓的请求中包含cs-engine核心RAG算法代码(rag_pipeline.py)，已触发审查',
  'MANUALLY_VERIFIED', '经审核该代码为开源LangChain封装，非公司核心算法，放行', '2026-03-13 14:30:00'),
(3, '检测到Prompt注入尝试',             'WARNING',  NULL, 1,
  'MCP请求中检测到可疑prompt: "ignore previous instructions and..."，已拦截',
  'AUTO_HANDLED', '请求已拦截，来源IP已记录', '2026-03-12 16:45:00'),
(1, 'AI对话含AWS AccessKey',            'CRITICAL', 12, 5,
  '用户马飞在Claude Code中粘贴了包含AWS AccessKeyId的配置文件',
  'AUTO_HANDLED', '敏感信息已自动屏蔽，已通知用户轮换Key', '2026-03-15 11:20:00'),
(NULL, '非常用地点登录',                 'INFO',     3,  NULL,
  '用户王强从新IP 223.166.x.x（上海）登录，与常用地点（杭州）不符',
  'DISMISSED', '确认为出差正常登录', '2026-03-11 08:30:00'),
(NULL, '单用户Token用量24h激增300%',     'WARNING',  6,  1,
  '用户赵磊近24小时Token消耗量达58万，较日均18万激增222%',
  'MANUALLY_VERIFIED', '确认为Sprint冲刺期集中使用AI辅助编码，属正常使用', '2026-03-15 20:00:00');


-- =============================================================
-- 34. 审计日志 audit_logs
-- =============================================================
INSERT INTO `audit_logs` (`user_id`, `project_id`, `action`, `target_type`, `target_id`, `detail`, `result`, `ip_address`, `occurred_at`) VALUES
( 3, 1, '新增项目成员',       'project_member', 7,  '{"added_user":"赵磊","role":"DEVELOPER"}',              'SUCCESS',  '10.0.1.15',  '2025-01-20 09:00:00'),
( 5, 1, '上传需求文档',       'knowledge_document', 8, '{"file":"member-prd-v2.pdf","size":"4.8MB"}',        'SUCCESS',  '10.0.1.22',  '2026-01-15 10:00:00'),
(16, 5, 'MCP接入配置',        'project_mcp_config', 5, '{"endpoint":"mcp.company.com/infra/api"}',           'SUCCESS',  '10.0.1.30',  '2026-02-15 14:00:00'),
(13, 2, 'AI对话含敏感词',     'ai_usage_event', NULL,  '{"keyword":"DROP TABLE","action":"blocked"}',        'FILTERED', '10.0.2.10',  '2026-03-10 11:30:00'),
( 1, NULL,'修改平台全局设置',  'platform_setting', NULL,'{"key":"monthly_total_quota_tokens","old":"8000000","new":"10000000"}', 'SUCCESS', '10.0.1.1', '2026-03-01 10:00:00'),
( 3, 1, '触发生产部署',       'deployment', 2,         '{"service":"mall-backend","version":"v3.23.0","env":"PROD"}', 'SUCCESS', '10.0.1.15', '2026-03-12 22:00:00'),
( 1, NULL,'新增API密钥',      'provider_api_key', 3,   '{"provider":"DeepSeek","scope":"PLATFORM"}',         'SUCCESS',  '10.0.1.1',   '2025-06-01 14:00:00'),
(13, 2, '创建事故工单',       'incident', 3,           '{"title":"客服AI回复幻觉信息","severity":"P2"}',      'SUCCESS',  '10.0.2.10',  '2026-03-13 15:00:00'),
( 6, 1, '代码推送触发CI',     'pipeline_run', 1,       '{"branch":"feature/member-v2","commit":"a3b7c9d2"}', 'SUCCESS',  '10.0.1.18',  '2026-03-15 10:10:00'),
(12, 5, '修改告警规则',       'security_rule', NULL,    '{"rule":"Token异常突增","threshold":"200%→300%"}',   'SUCCESS',  '10.0.1.25',  '2026-03-14 09:00:00');


-- =============================================================
-- 35. 活动日志 activity_logs（仪表盘时间线）
-- =============================================================
INSERT INTO `activity_logs` (`project_id`, `user_id`, `actor_name`, `action_type`, `summary`, `target_type`, `target_id`, `target_name`, `occurred_at`) VALUES
(1, 6,   '赵磊',             'push_code',      '赵磊推送代码到 mall-backend/feature/member-v2',                    'service', 1,  'mall-backend',    '2026-03-15 10:10:00'),
(1, 7,   '孙悦',             'push_code',      '孙悦推送代码到 mall-frontend/feature/member-ui',                   'service', 2,  'mall-frontend',   '2026-03-15 11:00:00'),
(1, NULL, 'Code Review Agent','ai_review',      'AI完成mall-backend PR#310代码审查，发现2个改进项',                 'service', 1,  'mall-backend',    '2026-03-15 10:31:32'),
(2, 13,  '林晓',             'push_code',      '林晓推送代码到 cs-engine/feature/rag-v2',                          'service', 5,  'cs-engine',       '2026-03-15 17:00:00'),
(1, 5,   '陈思',             'upload_doc',     '陈思上传需求文档《会员体系PRD v2.0》',                             'document',8,  '会员体系PRD v2.0','2026-01-15 10:00:00'),
(2, 11,  '黄蕾',             'upload_doc',     '黄蕾更新知识库文档《客服话术知识库-退换货》',                      'document',11, '退换货话术',      '2026-03-14 10:00:00'),
(1, 3,   '王强',             'deploy',         '王强部署 mall-backend v3.23.0 到生产环境',                        'service', 1,  'mall-backend',    '2026-03-12 22:00:00'),
(5, 16,  '谢峰',             'mcp_connect',    '谢峰配置 infra-api MCP接入 (Streamable HTTP)',                     'service', 13, 'infra-api',       '2026-02-15 14:00:00'),
(1, NULL, 'Bug诊断Agent',    'ai_diagnosis',   'AI诊断商城首页超时事故：Redis热key击穿，建议增加互斥锁',          'incident',1,  '商城首页超时',    '2026-03-10 20:20:00'),
(3, 8,   '周杰',             'push_code',      '周杰推送代码到 analytics-api/feature/nl2sql-join',                 'service', 8,  'analytics-api',   '2026-03-15 14:00:00'),
(4, 18,  '杨帆',             'push_code',      '杨帆推送代码到 mobile-rn/feature/ar-optimize',                     'service', 10, 'mobile-rn',       '2026-03-15 15:00:00'),
(1, NULL, '需求拆分Agent',   'ai_split',       'AI完成《会员体系PRD v2.0》需求拆分，生成6个User Story共33SP',     'project', 1,  '商城中台',        '2026-01-16 10:04:00'),
(2, 13,  '林晓',             'create_project', '林晓创建项目「智能客服系统」',                                     'project', 2,  '智能客服系统',    '2025-03-01 09:00:00'),
(1, 12,  '马飞',             'deploy',         '马飞部署 pay-service v2.8.1 到生产环境（修复优惠券叠加Bug）',     'service', 4,  'pay-service',     '2026-03-14 17:00:00'),
(5, NULL, 'Sprint日报Agent', 'ai_report',      'AI生成3月15日Sprint日报：5个项目进度汇总，2个风险项',             'project', NULL,'全平台日报',      '2026-03-15 18:01:05'),
(1, 10,  '郑凯',             'push_code',      '郑凯推送代码到 mall-backend/feature/points-exchange',             'service', 1,  'mall-backend',    '2026-03-16 09:15:00'),
(1, NULL, 'Code Review Agent','ai_review',      'AI正在审查 mall-backend PR#312 积分兑换接口，等待人工确认',       'service', 1,  'mall-backend',    '2026-03-16 09:22:18'),
(4, 18,  '杨帆',             'push_code',      '杨帆推送代码到 mobile-rn/feature/push-notify',                    'service', 10, 'mobile-rn',       '2026-03-16 09:30:00');
