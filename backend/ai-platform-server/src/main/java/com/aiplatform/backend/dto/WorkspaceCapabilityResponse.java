package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.WorkspaceAiCapability;
import com.aiplatform.backend.entity.AiCapability;

import java.math.BigDecimal;

/**
 * 工作区能力绑定响应对象。
 */
public record WorkspaceCapabilityResponse(
        Long id,
        Long workspaceId,
        Long aiCapabilityId,
        String capabilityCode,
        String capabilityName,
        String capabilityType,
        String requestMode,
        Long providerId,
        Long modelId,
        Integer monthlyRequestQuota,
        Long monthlyTokenQuota,
        BigDecimal monthlyCostQuota,
        String overQuotaStrategy,
        String status
) {
    
    public static WorkspaceCapabilityResponse from(WorkspaceAiCapability binding, AiCapability capability) {
        return new WorkspaceCapabilityResponse(
                binding.getId(),
                binding.getWorkspaceId(),
                binding.getAiCapabilityId(),
                capability.getCode(),
                capability.getName(),
                capability.getCapabilityType(),
                capability.getRequestMode(),
                binding.getProviderId(),
                binding.getModelId(),
                binding.getMonthlyRequestQuota(),
                binding.getMonthlyTokenQuota(),
                binding.getMonthlyCostQuota(),
                binding.getOverQuotaStrategy(),
                binding.getStatus()
        );
    }
}
