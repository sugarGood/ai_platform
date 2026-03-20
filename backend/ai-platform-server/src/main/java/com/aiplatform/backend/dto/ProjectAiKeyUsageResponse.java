package com.aiplatform.backend.dto;

/**
 * 项目 AI Key 使用量汇总响应对象。
 */
public record ProjectAiKeyUsageResponse(
        Long projectId,
        String provider,
        Long totalMonthlyQuota,
        Long totalUsedQuota,
        Long remainingQuota,
        Integer usageRatePercent,
        Integer activeKeyCount,
        Integer disabledKeyCount,
        Integer alertingKeyCount,
        Integer exhaustedKeyCount
) {
}
