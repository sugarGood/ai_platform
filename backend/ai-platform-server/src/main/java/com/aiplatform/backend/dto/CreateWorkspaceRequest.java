package com.aiplatform.backend.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * 创建工作区的请求对象。
 */
public record CreateWorkspaceRequest(
        @NotBlank(message = "Workspace name must not be blank")
        String name,
        @NotBlank(message = "Workspace code must not be blank")
        String code,
        @NotBlank(message = "Workspace type must not be blank")
        String workspaceType,
        String description,
        Long defaultProviderId,
        Long defaultModelId
) {
}
