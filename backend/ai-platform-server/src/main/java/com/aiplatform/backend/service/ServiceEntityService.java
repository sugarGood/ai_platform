package com.aiplatform.backend.service;

import com.aiplatform.backend.dto.CreateServiceRequest;
import com.aiplatform.backend.entity.ServiceEntity;
import com.aiplatform.backend.mapper.ProjectMapper;
import com.aiplatform.backend.mapper.ServiceEntityMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 服务业务服务。
 */
@Service
public class ServiceEntityService {

    private final ProjectMapper projectMapper;
    private final ServiceEntityMapper serviceEntityMapper;

    public ServiceEntityService(ProjectMapper projectMapper, ServiceEntityMapper serviceEntityMapper) {
        this.projectMapper = projectMapper;
        this.serviceEntityMapper = serviceEntityMapper;
    }

    /**
     * 在指定项目下创建服务。
     */
    public ServiceEntity create(Long projectId, CreateServiceRequest request) {
        ensureProjectExists(projectId);

        ServiceEntity serviceEntity = new ServiceEntity();
        serviceEntity.setProjectId(projectId);
        serviceEntity.setName(request.name());
        serviceEntity.setServiceType(request.serviceType());
        serviceEntity.setDefaultBranch(request.defaultBranch());
        serviceEntity.setStatus("ACTIVE");
        serviceEntityMapper.insert(serviceEntity);
        return serviceEntity;
    }

    /**
     * 查询指定项目下的服务列表。
     */
    public List<ServiceEntity> listByProjectId(Long projectId) {
        ensureProjectExists(projectId);
        return serviceEntityMapper.selectList(
                Wrappers.<ServiceEntity>lambdaQuery()
                        .eq(ServiceEntity::getProjectId, projectId)
                        .orderByAsc(ServiceEntity::getId)
        );
    }

    private void ensureProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new com.aiplatform.backend.common.exception.ProjectNotFoundException(projectId);
        }
    }
}
