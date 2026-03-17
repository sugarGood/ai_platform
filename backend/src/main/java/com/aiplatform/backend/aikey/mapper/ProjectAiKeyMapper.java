package com.aiplatform.backend.aikey.mapper;

import com.aiplatform.backend.aikey.entity.ProjectAiKey;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 项目 AI 密钥 MyBatis-Plus Mapper 接口。
 *
 * <p>继承 {@link BaseMapper}，提供对 {@code project_ai_keys} 表的基础 CRUD 操作。
 * 业务层通过 {@link com.aiplatform.backend.aikey.service.ProjectAiKeyService} 调用本接口
 * 完成密钥的创建、查询等数据库交互。</p>
 */
@Mapper
public interface ProjectAiKeyMapper extends BaseMapper<ProjectAiKey> {
}
