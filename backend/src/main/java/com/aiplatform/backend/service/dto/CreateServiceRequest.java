package com.aiplatform.backend.service.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * 创建服务的请求 DTO。
 *
 * <p>用于 {@code POST /api/projects/{projectId}/services} 接口的请求体，
 * 包含新建服务所需的基本信息。所有字段均为必填。</p>
 *
 * @param name          服务名称，不能为空白
 * @param serviceType   服务类型，不能为空白；必须为以下枚举值之一：
 *                      {@code BACKEND}、{@code FRONTEND}、{@code MOBILE}、{@code DATA}、
 *                      {@code TEST}、{@code AI_AGENT}、{@code SHARED_COMPONENT}
 * @param defaultBranch 默认代码分支名称，不能为空白（例如 {@code "main"}）
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
