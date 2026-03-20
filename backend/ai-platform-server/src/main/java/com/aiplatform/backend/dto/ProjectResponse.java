package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.Project;

/**
 * 项目响应对象。
 */
public record ProjectResponse(
        Long id,
        String name,
        String code,
        String projectType,
        String branchStrategy,
        String status
) {
    
    public static ProjectResponse from(Project project) {
        return new ProjectResponse(
                project.getId(),
                project.getName(),
                project.getCode(),
                project.getProjectType(),
                project.getBranchStrategy(),
                project.getStatus()
        );
    }
}
