package com.aiplatform.agent.gateway.mapper;

import com.aiplatform.agent.gateway.entity.AiCapabilityRef;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 能力目录只读 Mapper。
 */
@Mapper
public interface AiCapabilityRefMapper extends BaseMapper<AiCapabilityRef> {
}
