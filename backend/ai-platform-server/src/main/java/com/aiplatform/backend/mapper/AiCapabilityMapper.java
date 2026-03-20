package com.aiplatform.backend.mapper;

import com.aiplatform.backend.entity.AiCapability;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * AI 能力数据访问接口。
 */
@Mapper
public interface AiCapabilityMapper extends BaseMapper<AiCapability> {
}

