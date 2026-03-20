package com.aiplatform.backend.mapper;

import com.aiplatform.backend.entity.WorkspaceAiCapability;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 工作区能力绑定数据访问接口。
 */
@Mapper
public interface WorkspaceAiCapabilityMapper extends BaseMapper<WorkspaceAiCapability> {
}
