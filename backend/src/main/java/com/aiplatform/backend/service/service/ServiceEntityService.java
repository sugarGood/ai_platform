package com.aiplatform.backend.service.service;

import com.aiplatform.backend.common.exception.ProjectNotFoundException;
import com.aiplatform.backend.project.mapper.ProjectMapper;
import com.aiplatform.backend.service.dto.CreateServiceRequest;
import com.aiplatform.backend.service.entity.ServiceEntity;
import com.aiplatform.backend.service.mapper.ServiceEntityMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 服务模块的核心业务逻辑层。
 *
 * <p>负责项目下服务的创建和查询操作，所有操作前会校验项目是否存在。</p>
 *
 * @see ServiceEntity
 * @see com.aiplatform.backend.service.controller.ProjectServiceController
 */
@Service
public class ServiceEntityService {

    private final ServiceEntityMapper serviceEntityMapper;
    private final ProjectMapper projectMapper;

    public ServiceEntityService(ServiceEntityMapper serviceEntityMapper, ProjectMapper projectMapper) {
        this.serviceEntityMapper = serviceEntityMapper;
        this.projectMapper = projectMapper;
    }

    /**
     * 在指定项目下创建一个新服务。
     *
     * <p>新服务的初始状态为 {@code ACTIVE}。</p>
     *
     * @param projectId 所属项目 ID
     * @param request   创建服务的请求参数
     * @return 创建完成并已持久化的服务实体（含自增主键）
     * @throws ProjectNotFoundException 当指定的项目不存在时抛出
     */
    public ServiceEntity create(Long projectId, CreateServiceRequest request) {
        assertProjectExists(projectId);

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
     * 查询指定项目下的所有服务，按 ID 升序排列。
     *
     * @param projectId 项目 ID
     * @return 该项目下的服务列表，可能为空列表
     * @throws ProjectNotFoundException 当指定的项目不存在时抛出
     */
    public List<ServiceEntity> listByProjectId(Long projectId) {
        assertProjectExists(projectId);
        return serviceEntityMapper.selectList(Wrappers.<ServiceEntity>lambdaQuery()
                .eq(ServiceEntity::getProjectId, projectId)
                .orderByAsc(ServiceEntity::getId));
    }

    /**
     * 校验项目是否存在，若不存在则抛出异常。
     *
     * @param projectId 待校验的项目 ID
     * @throws ProjectNotFoundException 当项目不存在时抛出
     */
    private void assertProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new ProjectNotFoundException(projectId);
        }
    }
}
