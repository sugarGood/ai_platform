package com.aiplatform.agent.gateway.service;

import com.aiplatform.agent.gateway.entity.PlatformAccessTokenRef;

public record PlatformAccessAuthorization(
        Long projectId,
        Long workspaceId,
        Long projectMemberId,
        PlatformAccessTokenRef token
) {
}
