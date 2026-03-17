package com.aiplatform.backend.aikey.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

/**
 * 创建项目 AI 密钥的请求 DTO。
 *
 * <p>所有字段均带有 Bean Validation 约束，由 Controller 层的 {@code @Valid} 触发校验。</p>
 *
 * @param name                  密钥名称，不能为空；同一项目内不允许重名（业务层校验）
 * @param provider              AI 服务提供商，不能为空；当前仅允许 {@code "CODEX"}（正则校验）
 * @param secretKey             原始密钥字符串，不能为空；创建后将被脱敏存储展示值
 * @param monthlyQuota          月度配额，不能为 null，最小值 1
 * @param usedQuota             初始已用量，不能为 null，最小值 0；不得大于 monthlyQuota（业务层校验）
 * @param alertThresholdPercent 告警阈值百分比，不能为 null，取值范围 1 ~ 100
 */
public record CreateProjectAiKeyRequest(
        @NotBlank
        String name,
        @NotBlank
        @Pattern(regexp = "CODEX")
        String provider,
        @NotBlank
        String secretKey,
        @NotNull
        @Min(1)
        Long monthlyQuota,
        @NotNull
        @Min(0)
        Long usedQuota,
        @NotNull
        @Min(1)
        @Max(100)
        Integer alertThresholdPercent
) {
}
