package com.aiplatform.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * 创建服务的请求对象。
 */
public record CreateServiceRequest(
        @NotBlank
        String name,
        @NotBlank
        @Pattern(regexp = "BACKEND|FRONTEND|MOBILE|DATA|TEST|AI_AGENT|SHARED_COMPONENT")
        String serviceType,
        @NotBlank
        String defaultBranch
) {
}
