package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.PlatformAccessToken;
import com.aiplatform.backend.entity.ProjectMember;

import java.time.LocalDateTime;
import java.util.List;

public record PlatformAccessTokenResponse(
        Long id,
        Long projectId,
        Long workspaceId,
        Long projectMemberId,
        String memberName,
        String memberEmail,
        String role,
        String name,
        String tokenPrefix,
        List<String> allowedCapabilityCodes,
        String status,
        LocalDateTime expiresAt,
        String accessToken
) {

    public static PlatformAccessTokenResponse from(PlatformAccessToken token,
                                                   ProjectMember member,
                                                   List<String> allowedCapabilityCodes,
                                                   String accessToken) {
        return new PlatformAccessTokenResponse(
                token.getId(),
                token.getProjectId(),
                token.getWorkspaceId(),
                token.getProjectMemberId(),
                member.getName(),
                member.getEmail(),
                token.getRoleSnapshot(),
                token.getName(),
                token.getTokenPrefix(),
                allowedCapabilityCodes,
                token.getStatus(),
                token.getExpiresAt(),
                accessToken
        );
    }
}
