package com.aiplatform.backend.service;

import com.aiplatform.backend.common.exception.CapabilityNotFoundException;
import com.aiplatform.backend.entity.AiCapability;
import com.aiplatform.backend.mapper.AiCapabilityMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * AI 能力目录业务服务。
 */
@Service
public class AiCapabilityService {

    private final AiCapabilityMapper aiCapabilityMapper;

    public AiCapabilityService(AiCapabilityMapper aiCapabilityMapper) {
        this.aiCapabilityMapper = aiCapabilityMapper;
    }

    /**
     * 查询状态为启用的能力列表。
     */
    public List<AiCapability> listActiveCapabilities() {
        return aiCapabilityMapper.selectList(Wrappers.<AiCapability>lambdaQuery()
                .eq(AiCapability::getStatus, "ACTIVE")
                .orderByAsc(AiCapability::getId));
    }

    /**
     * 按主键查询能力，不存在则抛出异常。
     */
    public AiCapability getById(Long capabilityId) {
        AiCapability capability = aiCapabilityMapper.selectById(capabilityId);
        if (capability == null) {
            throw new CapabilityNotFoundException(capabilityId);
        }
        return capability;
    }
}
