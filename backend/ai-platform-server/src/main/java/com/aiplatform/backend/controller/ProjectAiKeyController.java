package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateProjectAiKeyRequest;
import com.aiplatform.backend.dto.ProjectAiKeyResponse;
import com.aiplatform.backend.dto.ProjectAiKeyUsageResponse;
import com.aiplatform.backend.service.ProjectAiKeyService;
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
 * 项目 AI Key 管理控制器。
 */
@RestController
@RequestMapping("/api/projects/{projectId}/ai-keys")
public class ProjectAiKeyController {

    private final ProjectAiKeyService projectAiKeyService;

    public ProjectAiKeyController(ProjectAiKeyService projectAiKeyService) {
        this.projectAiKeyService = projectAiKeyService;
    }

    
    /**
     * 在指定项目下创建 AI Key。
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectAiKeyResponse create(@PathVariable Long projectId,
                                       @Valid @RequestBody CreateProjectAiKeyRequest request) {
        return ProjectAiKeyResponse.from(projectAiKeyService.create(projectId, request));
    }

    
    /**
     * 查询指定项目下的 AI Key 列表。
     */
    @GetMapping
    public List<ProjectAiKeyResponse> list(@PathVariable Long projectId) {
        return projectAiKeyService.listByProjectId(projectId).stream()
                .map(ProjectAiKeyResponse::from)
                .toList();
    }

    
    /**
     * 查询指定项目下 AI Key 的使用汇总。
     */
    @GetMapping("/usage")
    public ProjectAiKeyUsageResponse usage(@PathVariable Long projectId) {
        return projectAiKeyService.usageSummary(projectId);
    }
}
