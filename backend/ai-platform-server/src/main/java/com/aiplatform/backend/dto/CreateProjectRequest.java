package com.aiplatform.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * 创建项目的请求对象。
 */
public record CreateProjectRequest(
        @NotBlank(message = "Project name must not be blank")
        String name,
        @NotBlank(message = "Project code must not be blank")
        String code,
        @NotBlank(message = "Project type must not be blank")
        @Pattern(regexp = "PRODUCT|INTERNAL_SYSTEM|TECH_PLATFORM|DATA_PRODUCT", message = "Invalid project type")
        String projectType,
        @NotBlank(message = "Branch strategy must not be blank")
        @Pattern(regexp = "GIT_FLOW|TRUNK_BASED|FEATURE_BRANCH", message = "Invalid branch strategy")
        String branchStrategy
) {
}
