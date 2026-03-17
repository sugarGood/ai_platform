package com.aiplatform.backend.member.controller;

import com.aiplatform.backend.member.dto.CreateProjectMemberRequest;
import com.aiplatform.backend.member.dto.ProjectMemberResponse;
import com.aiplatform.backend.member.service.ProjectMemberService;
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
 * 项目成员 REST 控制器。
 *
 * <p>提供项目成员管理相关的 HTTP 接口，基础路径为
 * {@code /api/projects/{projectId}/members}。</p>
 *
 * <ul>
 *   <li>{@code POST /api/projects/{projectId}/members} — 创建项目成员</li>
 *   <li>{@code GET  /api/projects/{projectId}/members} — 查询项目成员列表</li>
 * </ul>
 *
 * @see ProjectMemberService
 */
@RestController
@RequestMapping("/api/projects/{projectId}/members")
public class ProjectMemberController {

    private final ProjectMemberService projectMemberService;

    public ProjectMemberController(ProjectMemberService projectMemberService) {
        this.projectMemberService = projectMemberService;
    }

    /**
     * 创建项目成员。
     *
     * @param projectId 路径参数，项目 ID
     * @param request   请求体，包含成员姓名、邮箱和角色，需通过校验
     * @return 创建成功的成员信息，HTTP 状态码 201
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectMemberResponse create(@PathVariable Long projectId,
                                        @Valid @RequestBody CreateProjectMemberRequest request) {
        return ProjectMemberResponse.from(projectMemberService.create(projectId, request));
    }

    /**
     * 查询指定项目的全部成员列表。
     *
     * @param projectId 路径参数，项目 ID
     * @return 该项目下的成员响应列表，按 ID 升序排列
     */
    @GetMapping
    public List<ProjectMemberResponse> list(@PathVariable Long projectId) {
        return projectMemberService.listByProjectId(projectId).stream()
                .map(ProjectMemberResponse::from)
                .toList();
    }
}
