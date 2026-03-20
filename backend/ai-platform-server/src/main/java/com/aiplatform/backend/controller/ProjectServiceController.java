package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateServiceRequest;
import com.aiplatform.backend.dto.ServiceResponse;
import com.aiplatform.backend.service.ServiceEntityService;
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
 * 项目服务管理控制器。
 */
@RestController
@RequestMapping("/api/projects/{projectId}/services")
public class ProjectServiceController {

    private final ServiceEntityService serviceEntityService;

    public ProjectServiceController(ServiceEntityService serviceEntityService) {
        this.serviceEntityService = serviceEntityService;
    }

    
    /**
     * 在指定项目下创建服务。
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ServiceResponse create(@PathVariable Long projectId, @Valid @RequestBody CreateServiceRequest request) {
        return ServiceResponse.from(serviceEntityService.create(projectId, request));
    }

    
    /**
     * 查询指定项目下的服务列表。
     */
    @GetMapping
    public List<ServiceResponse> list(@PathVariable Long projectId) {
        return serviceEntityService.listByProjectId(projectId).stream()
                .map(ServiceResponse::from)
                .toList();
    }
}
