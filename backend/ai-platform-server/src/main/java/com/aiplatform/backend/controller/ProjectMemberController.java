package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateProjectMemberRequest;
import com.aiplatform.backend.dto.ProjectMemberResponse;
import com.aiplatform.backend.service.ProjectMemberService;
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
 * 项目成员管理控制器。
 */
@RestController
@RequestMapping("/api/projects/{projectId}/members")
public class ProjectMemberController {

    private final ProjectMemberService projectMemberService;

    public ProjectMemberController(ProjectMemberService projectMemberService) {
        this.projectMemberService = projectMemberService;
    }

    
    /**
     * 在指定项目下创建成员。
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectMemberResponse create(@PathVariable Long projectId,
                                        @Valid @RequestBody CreateProjectMemberRequest request) {
        return ProjectMemberResponse.from(projectMemberService.create(projectId, request));
    }

    
    /**
     * 查询指定项目下的成员列表。
     */
    @GetMapping
    public List<ProjectMemberResponse> list(@PathVariable Long projectId) {
        return projectMemberService.listByProjectId(projectId).stream()
                .map(ProjectMemberResponse::from)
                .toList();
    }
}
