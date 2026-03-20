package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.ProjectAiKey;

/**
 * 项目 AI Key 响应对象。
 */
public record ProjectAiKeyResponse(
        Long id,
        Long projectId,
        String name,
        String provider,
        String maskedKey,
        Long monthlyQuota,
        Long usedQuota,
        Integer alertThresholdPercent,
        String status
) {
    
    public static ProjectAiKeyResponse from(ProjectAiKey projectAiKey) {
        return new ProjectAiKeyResponse(
                projectAiKey.getId(),
                projectAiKey.getProjectId(),
                projectAiKey.getName(),
                projectAiKey.getProvider(),
                projectAiKey.getMaskedKey(),
                projectAiKey.getMonthlyQuota(),
                projectAiKey.getUsedQuota(),
                projectAiKey.getAlertThresholdPercent(),
                projectAiKey.getStatus()
        );
    }
}
