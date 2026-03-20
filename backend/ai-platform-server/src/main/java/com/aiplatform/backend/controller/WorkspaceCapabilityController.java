package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateWorkspaceCapabilityRequest;
import com.aiplatform.backend.dto.WorkspaceCapabilityResponse;
import com.aiplatform.backend.service.WorkspaceCapabilityService;
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
 * 工作区能力绑定控制器。
 */
@RestController
@RequestMapping("/api/workspaces/{workspaceId}/capabilities")
public class WorkspaceCapabilityController {

    private final WorkspaceCapabilityService workspaceCapabilityService;

    public WorkspaceCapabilityController(WorkspaceCapabilityService workspaceCapabilityService) {
        this.workspaceCapabilityService = workspaceCapabilityService;
    }

    
    /**
     * 为指定工作区创建能力绑定。
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public WorkspaceCapabilityResponse create(@PathVariable Long workspaceId,
                                              @Valid @RequestBody CreateWorkspaceCapabilityRequest request) {
        return workspaceCapabilityService.create(workspaceId, request);
    }

    
    /**
     * 查询指定工作区下的能力绑定列表。
     */
    @GetMapping
    public List<WorkspaceCapabilityResponse> list(@PathVariable Long workspaceId) {
        return workspaceCapabilityService.listByWorkspaceId(workspaceId);
    }
}
