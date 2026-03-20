package com.aiplatform.backend.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

/**
 * 创建项目 AI Key 的请求对象。
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
