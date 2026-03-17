package com.aiplatform.backend.service.controller;

import com.aiplatform.backend.service.dto.CreateServiceRequest;
import com.aiplatform.backend.service.dto.ServiceResponse;
import com.aiplatform.backend.service.service.ServiceEntityService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 项目服务管理的 REST 控制器。
 *
 * <p>提供项目下服务资源的 CRUD 端点，基础路径为
 * {@code /api/projects/{projectId}/services}。</p>
 *
 * @see ServiceEntityService
 */
@RestController
@RequestMapping("/api/projects/{projectId}/services")
public class ProjectServiceController {

    private final ServiceEntityService serviceEntityService;

    public ProjectServiceController(ServiceEntityService serviceEntityService) {
        this.serviceEntityService = serviceEntityService;
    }

    /**
     * 在指定项目下创建新服务。
     *
     * @param projectId 项目 ID（路径参数）
     * @param request   创建服务的请求体，需通过 JSR 380 校验
     * @return 新创建的服务响应 DTO
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ServiceResponse create(@PathVariable Long projectId, @Valid @RequestBody CreateServiceRequest request) {
        return ServiceResponse.from(serviceEntityService.create(projectId, request));
    }

    /**
     * 查询指定项目下的所有服务列表。
     *
     * @param projectId 项目 ID（路径参数）
     * @return 服务响应 DTO 列表
     */
    @GetMapping
    public List<ServiceResponse> list(@PathVariable Long projectId) {
        return serviceEntityService.listByProjectId(projectId).stream()
                .map(ServiceResponse::from)
                .toList();
    }
}
