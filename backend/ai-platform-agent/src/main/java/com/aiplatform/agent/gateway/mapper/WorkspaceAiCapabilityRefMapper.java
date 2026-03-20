package com.aiplatform.agent.gateway.mapper;

import com.aiplatform.agent.gateway.entity.WorkspaceAiCapabilityRef;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 工作区能力绑定只读 Mapper。
 */
@Mapper
public interface WorkspaceAiCapabilityRefMapper extends BaseMapper<WorkspaceAiCapabilityRef> {
}
