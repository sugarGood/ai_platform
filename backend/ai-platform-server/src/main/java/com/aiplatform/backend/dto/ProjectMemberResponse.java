package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.ProjectMember;

/**
 * 项目成员响应对象。
 */
public record ProjectMemberResponse(
        Long id,
        Long projectId,
        String name,
        String email,
        String role,
        String status
) {
    
    public static ProjectMemberResponse from(ProjectMember projectMember) {
        return new ProjectMemberResponse(
                projectMember.getId(),
                projectMember.getProjectId(),
                projectMember.getName(),
                projectMember.getEmail(),
                projectMember.getRole(),
                projectMember.getStatus()
        );
    }
}
