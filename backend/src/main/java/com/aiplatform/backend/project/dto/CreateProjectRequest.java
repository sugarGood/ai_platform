package com.aiplatform.backend.project.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * 创建项目请求 DTO。
 *
 * <p>用于接收 {@code POST /api/projects} 请求体，所有字段均为必填项，
 * 并通过 Jakarta Validation 注解进行校验。</p>
 *
 * @param name           项目名称，不能为空白字符串
 * @param code           项目编码，不能为空白字符串，建议使用全局唯一的大写标识
 * @param projectType    项目类型，必须为以下值之一：
 *                       {@code PRODUCT}（产品项目）、{@code INTERNAL_SYSTEM}（内部系统）、
 *                       {@code TECH_PLATFORM}（技术平台）、{@code DATA_PRODUCT}（数据产品）
 * @param branchStrategy 分支策略，必须为以下值之一：
 *                       {@code GIT_FLOW}、{@code TRUNK_BASED}、{@code FEATURE_BRANCH}
 */
public record CreateProjectRequest(
        @NotBlank(message = "项目名称不能为空")
        String name,
        @NotBlank(message = "项目编码不能为空")
        String code,
        @NotBlank(message = "项目类型不能为空")
        @Pattern(regexp = "PRODUCT|INTERNAL_SYSTEM|TECH_PLATFORM|DATA_PRODUCT", message = "项目类型不合法")
        String projectType,
        @NotBlank(message = "分支策略不能为空")
        @Pattern(regexp = "GIT_FLOW|TRUNK_BASED|FEATURE_BRANCH", message = "分支策略不合法")
        String branchStrategy
) {
}
