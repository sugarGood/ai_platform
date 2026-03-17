package com.aiplatform.backend.aikey.dto;

import com.aiplatform.backend.aikey.entity.ProjectAiKey;

/**
 * 项目 AI 密钥响应 DTO，用于向前端返回密钥信息。
 *
 * <p>出于安全考虑，不包含原始密钥 {@code secretKey}，仅返回脱敏后的 {@code maskedKey}。</p>
 *
 * @param id                    密钥主键 ID
 * @param projectId             所属项目 ID
 * @param name                  密钥名称
 * @param provider              AI 服务提供商标识
 * @param maskedKey             脱敏后的密钥（如 {@code "sk-****abcd"}）
 * @param monthlyQuota          月度配额
 * @param usedQuota             当月已使用量
 * @param alertThresholdPercent 告警阈值百分比（1 ~ 100）
 * @param status                密钥状态（{@code "ACTIVE"} / {@code "DISABLED"}）
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
    /**
     * 从实体对象构建响应 DTO。
     *
     * @param projectAiKey 密钥实体，不能为 null
     * @return 不含原始密钥的响应对象
     */
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
