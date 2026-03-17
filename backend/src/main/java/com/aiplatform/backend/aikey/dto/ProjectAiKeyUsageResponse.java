package com.aiplatform.backend.aikey.dto;

/**
 * 项目 AI 密钥用量汇总响应 DTO。
 *
 * <p>聚合某个项目下所有密钥的配额使用情况，以及按状态分类的密钥数量统计。
 * 由 {@link com.aiplatform.backend.aikey.service.ProjectAiKeyService#usageSummary(Long)} 生成。</p>
 *
 * @param projectId         项目 ID
 * @param provider          AI 服务提供商标识（当前固定为 {@code "CODEX"}）
 * @param totalMonthlyQuota 所有密钥月度配额之和
 * @param totalUsedQuota    所有密钥当月已使用量之和
 * @param remainingQuota    剩余可用配额（= totalMonthlyQuota - totalUsedQuota，最小为 0）
 * @param usageRatePercent  总体使用率百分比（整数截断，0 ~ 100）；配额为 0 时返回 0
 * @param activeKeyCount    状态为 {@code "ACTIVE"} 的密钥数量
 * @param disabledKeyCount  状态为 {@code "DISABLED"} 的密钥数量
 * @param alertingKeyCount  正在告警的密钥数量（使用率达到阈值但尚未耗尽）
 * @param exhaustedKeyCount 配额已耗尽的密钥数量（usedQuota >= monthlyQuota）
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
