package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateWorkspaceRequest;
import com.aiplatform.backend.dto.ProjectWorkspaceResponse;
import com.aiplatform.backend.service.ProjectWorkspaceService;
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
 * 项目工作区管理控制器。
 */
@RestController
@RequestMapping("/api/projects/{projectId}/workspaces")
public class ProjectWorkspaceController {

    private final ProjectWorkspaceService projectWorkspaceService;

    public ProjectWorkspaceController(ProjectWorkspaceService projectWorkspaceService) {
        this.projectWorkspaceService = projectWorkspaceService;
    }

    
    /**
     * 在指定项目下创建工作区。
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectWorkspaceResponse create(@PathVariable Long projectId,
                                           @Valid @RequestBody CreateWorkspaceRequest request) {
        return ProjectWorkspaceResponse.from(projectWorkspaceService.create(projectId, request));
    }

    
    /**
     * 查询指定项目下的工作区列表。
     */
    @GetMapping
    public List<ProjectWorkspaceResponse> list(@PathVariable Long projectId) {
        return projectWorkspaceService.listByProjectId(projectId).stream()
                .map(ProjectWorkspaceResponse::from)
                .toList();
    }
}
