package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateWorkspaceAccessTokenRequest;
import com.aiplatform.backend.dto.PlatformAccessTokenResponse;
import com.aiplatform.backend.service.PlatformAccessTokenService;
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

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/access-tokens")
public class WorkspaceAccessTokenController {

    private final PlatformAccessTokenService platformAccessTokenService;

    public WorkspaceAccessTokenController(PlatformAccessTokenService platformAccessTokenService) {
        this.platformAccessTokenService = platformAccessTokenService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public PlatformAccessTokenResponse create(@PathVariable Long workspaceId,
                                              @Valid @RequestBody CreateWorkspaceAccessTokenRequest request) {
        return platformAccessTokenService.create(workspaceId, request);
    }

    @GetMapping
    public List<PlatformAccessTokenResponse> list(@PathVariable Long workspaceId) {
        return platformAccessTokenService.listByWorkspaceId(workspaceId);
    }
}
