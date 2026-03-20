package com.aiplatform.agent.gateway.mapper;

import com.aiplatform.agent.gateway.entity.ProjectAiKeyRef;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 项目 AI Key 只读/轻量更新 Mapper。
 */
@Mapper
public interface ProjectAiKeyRefMapper extends BaseMapper<ProjectAiKeyRef> {
}
