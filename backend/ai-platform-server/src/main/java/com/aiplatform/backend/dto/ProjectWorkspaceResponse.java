package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.ProjectWorkspace;

/**
 * 工作区响应对象。
 */
public record ProjectWorkspaceResponse(
        Long id,
        Long projectId,
        String name,
        String code,
        String workspaceType,
        String description,
        Long defaultProviderId,
        Long defaultModelId,
        String status
) {
    
    public static ProjectWorkspaceResponse from(ProjectWorkspace workspace) {
        return new ProjectWorkspaceResponse(
                workspace.getId(),
                workspace.getProjectId(),
                workspace.getName(),
                workspace.getCode(),
                workspace.getWorkspaceType(),
                workspace.getDescription(),
                workspace.getDefaultProviderId(),
                workspace.getDefaultModelId(),
                workspace.getStatus()
        );
    }
}
