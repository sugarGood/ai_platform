package com.aiplatform.backend.dto;

import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;

/**
 * 创建工作区能力绑定的请求对象。
 */
public record CreateWorkspaceCapabilityRequest(
        @NotNull(message = "AI capability id must not be null")
        Long aiCapabilityId,
        Long providerId,
        Long modelId,
        Integer monthlyRequestQuota,
        Long monthlyTokenQuota,
        BigDecimal monthlyCostQuota,
        String overQuotaStrategy
) {
}
