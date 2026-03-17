package com.aiplatform.backend.project.dto;

import com.aiplatform.backend.project.entity.Project;

/**
 * 项目响应 DTO，用于向客户端返回项目信息。
 *
 * <p>包含项目的全部核心字段，通过 {@link #from(Project)} 工厂方法
 * 从 {@link Project} 实体进行转换，实现领域模型与接口契约的解耦。</p>
 *
 * @param id             项目主键 ID
 * @param name           项目名称
 * @param code           项目编码
 * @param projectType    项目类型（PRODUCT / INTERNAL_SYSTEM / TECH_PLATFORM / DATA_PRODUCT）
 * @param branchStrategy 分支策略（GIT_FLOW / TRUNK_BASED / FEATURE_BRANCH）
 * @param status         项目状态，如 {@code ACTIVE}
 */
public record ProjectResponse(
        Long id,
        String name,
        String code,
        String projectType,
        String branchStrategy,
        String status
) {
    /**
     * 将 {@link Project} 实体转换为 {@link ProjectResponse} DTO。
     *
     * @param project 项目实体对象，不能为 {@code null}
     * @return 包含项目所有核心字段的响应 DTO
     */
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
