package com.aiplatform.backend.project.controller;

import com.aiplatform.backend.project.dto.CreateProjectRequest;
import com.aiplatform.backend.project.dto.ProjectResponse;
import com.aiplatform.backend.project.service.ProjectService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 项目管理 REST 控制器。
 *
 * <p>提供项目的创建与列表查询接口，基础路径为 {@code /api/projects}。
 * 请求体校验通过 Jakarta Validation 自动完成，校验失败将返回 400 错误。</p>
 *
 * @see ProjectService
 * @see CreateProjectRequest
 * @see ProjectResponse
 */
@RestController
@RequestMapping("/api/projects")
public class ProjectController {

    private final ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    /**
     * 创建新项目。
     *
     * <p>接收经过校验的请求体，委托 {@link ProjectService} 完成创建，
     * 成功后返回 HTTP 201 状态码及项目响应 DTO。</p>
     *
     * @param request 创建项目请求体，字段需满足校验约束
     * @return 新创建的项目响应 DTO
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectResponse create(@Valid @RequestBody CreateProjectRequest request) {
        return ProjectResponse.from(projectService.create(request));
    }

    /**
     * 查询全部项目列表。
     *
     * <p>返回系统中所有项目的响应 DTO 列表，按 ID 升序排列。</p>
     *
     * @return 项目响应 DTO 列表
     */
    @GetMapping
    public List<ProjectResponse> list() {
        return projectService.list().stream()
                .map(ProjectResponse::from)
                .toList();
    }
}
