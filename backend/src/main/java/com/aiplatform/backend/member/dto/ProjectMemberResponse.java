package com.aiplatform.backend.member.dto;

import com.aiplatform.backend.member.entity.ProjectMember;

/**
 * 项目成员响应 DTO。
 *
 * <p>用于向客户端返回项目成员信息，字段与 {@link ProjectMember} 实体一一对应。</p>
 *
 * @param id        成员记录主键 ID
 * @param projectId 所属项目 ID
 * @param name      成员姓名
 * @param email     成员邮箱
 * @param role      成员角色：{@code OWNER} 或 {@code DEVELOPER}
 * @param status    成员状态：{@code ACTIVE}
 */
public record ProjectMemberResponse(
        Long id,
        Long projectId,
        String name,
        String email,
        String role,
        String status
) {
    /**
     * 将 {@link ProjectMember} 实体转换为响应 DTO。
     *
     * @param projectMember 项目成员实体对象，不能为 {@code null}
     * @return 对应的 {@link ProjectMemberResponse} 实例
     */
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
