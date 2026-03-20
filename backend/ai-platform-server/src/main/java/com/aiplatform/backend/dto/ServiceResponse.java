package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.ServiceEntity;

/**
 * 服务响应对象。
 */
public record ServiceResponse(
        Long id,
        Long projectId,
        String name,
        String serviceType,
        String defaultBranch,
        String status
) {
    
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
