package com.aiplatform.agent.gateway.mapper;

import com.aiplatform.agent.gateway.entity.ProjectWorkspaceRef;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 工作区只读 Mapper。
 */
@Mapper
public interface ProjectWorkspaceRefMapper extends BaseMapper<ProjectWorkspaceRef> {
}
