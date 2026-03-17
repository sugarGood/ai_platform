package com.aiplatform.backend.service.dto;

import com.aiplatform.backend.service.entity.ServiceEntity;

/**
 * 服务响应 DTO，用于向客户端返回服务详情。
 *
 * @param id            服务主键 ID
 * @param projectId     所属项目 ID
 * @param name          服务名称
 * @param serviceType   服务类型（如 {@code BACKEND}、{@code FRONTEND} 等）
 * @param defaultBranch 默认代码分支名称
 * @param status        服务状态（如 {@code ACTIVE}、{@code ARCHIVED}）
 */
public record ServiceResponse(
        Long id,
        Long projectId,
        String name,
        String serviceType,
        String defaultBranch,
        String status
) {
    /**
     * 将服务实体转换为响应 DTO。
     *
     * @param serviceEntity 服务实体对象，不能为 {@code null}
     * @return 包含实体所有字段的 {@link ServiceResponse} 实例
     */
    public static ServiceResponse from(ServiceEntity serviceEntity) {
        return new ServiceResponse(
                serviceEntity.getId(),
                serviceEntity.getProjectId(),
                serviceEntity.getName(),
                serviceEntity.getServiceType(),
                serviceEntity.getDefaultBranch(),
                serviceEntity.getStatus()
        );
    }
}
