package com.aiplatform.backend.aikey.controller;

import com.aiplatform.backend.aikey.dto.CreateProjectAiKeyRequest;
import com.aiplatform.backend.aikey.dto.ProjectAiKeyResponse;
import com.aiplatform.backend.aikey.dto.ProjectAiKeyUsageResponse;
import com.aiplatform.backend.aikey.service.ProjectAiKeyService;
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
 * 项目 AI 密钥管理 REST 控制器。
 *
 * <p>基础路径：{@code /api/projects/{projectId}/ai-keys}，
 * 提供密钥的创建、列表查询和用量汇总三个端点。</p>
 *
 * @see ProjectAiKeyService
 */
@RestController
@RequestMapping("/api/projects/{projectId}/ai-keys")
public class ProjectAiKeyController {

    private final ProjectAiKeyService projectAiKeyService;

    public ProjectAiKeyController(ProjectAiKeyService projectAiKeyService) {
        this.projectAiKeyService = projectAiKeyService;
    }

    /**
     * 创建 AI 密钥。
     *
     * @param projectId 路径参数，项目 ID
     * @param request   请求体，包含密钥名称、提供商、密钥值、配额等信息
     * @return 创建成功的密钥响应 DTO（HTTP 201）
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectAiKeyResponse create(@PathVariable Long projectId,
                                       @Valid @RequestBody CreateProjectAiKeyRequest request) {
        return ProjectAiKeyResponse.from(projectAiKeyService.create(projectId, request));
    }

    /**
     * 查询指定项目下的所有 AI 密钥列表。
     *
     * @param projectId 路径参数，项目 ID
     * @return 密钥响应 DTO 列表（HTTP 200）
     */
    @GetMapping
    public List<ProjectAiKeyResponse> list(@PathVariable Long projectId) {
        return projectAiKeyService.listByProjectId(projectId).stream()
                .map(ProjectAiKeyResponse::from)
                .toList();
    }

    /**
     * 获取指定项目的 AI 密钥用量汇总。
     *
     * @param projectId 路径参数，项目 ID
     * @return 用量汇总响应 DTO（HTTP 200）
     */
    @GetMapping("/usage")
    public ProjectAiKeyUsageResponse usage(@PathVariable Long projectId) {
        return projectAiKeyService.usageSummary(projectId);
    }
}
