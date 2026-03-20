package com.aiplatform.agent.gateway.service;

import com.aiplatform.agent.common.exception.InvalidPlatformAccessTokenException;
import com.aiplatform.agent.common.exception.PlatformAccessDeniedException;
import com.aiplatform.agent.gateway.entity.PlatformAccessTokenRef;
import com.aiplatform.agent.gateway.entity.ProjectMemberRef;
import com.aiplatform.agent.gateway.mapper.PlatformAccessTokenRefMapper;
import com.aiplatform.agent.gateway.mapper.ProjectMemberRefMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Locale;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class PlatformAccessTokenAuthService {

    private static final String STATUS_ACTIVE = "ACTIVE";

    private final PlatformAccessTokenRefMapper platformAccessTokenRefMapper;
    private final ProjectMemberRefMapper projectMemberRefMapper;

    public PlatformAccessTokenAuthService(PlatformAccessTokenRefMapper platformAccessTokenRefMapper,
                                          ProjectMemberRefMapper projectMemberRefMapper) {
        this.platformAccessTokenRefMapper = platformAccessTokenRefMapper;
        this.projectMemberRefMapper = projectMemberRefMapper;
    }

    public PlatformAccessAuthorization authorize(Long workspaceId, String authorizationHeader, String capabilityCode) {
        String rawToken = extractBearerToken(authorizationHeader);
        PlatformAccessTokenRef token = platformAccessTokenRefMapper.selectOne(Wrappers.<PlatformAccessTokenRef>lambdaQuery()
                .eq(PlatformAccessTokenRef::getTokenHash, PlatformAccessTokenCodec.hashToken(rawToken))
                .eq(PlatformAccessTokenRef::getStatus, STATUS_ACTIVE)
                .last("LIMIT 1"));
        if (token == null) {
            throw new InvalidPlatformAccessTokenException("Platform access token is invalid");
        }
        if (token.getExpiresAt() != null && token.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new InvalidPlatformAccessTokenException("Platform access token has expired");
        }
        if (!workspaceId.equals(token.getWorkspaceId())) {
            throw new PlatformAccessDeniedException("Platform access token does not belong to the workspace");
        }

        ProjectMemberRef member = projectMemberRefMapper.selectById(token.getProjectMemberId());
        if (member == null || !STATUS_ACTIVE.equals(member.getStatus()) || !token.getProjectId().equals(member.getProjectId())) {
            throw new InvalidPlatformAccessTokenException("Platform access token owner is invalid");
        }
        if (!token.getRoleSnapshot().equals(member.getRole())) {
            throw new PlatformAccessDeniedException("Platform access token role is out of date");
        }
        assertCapabilityAllowed(token, capabilityCode);
        return new PlatformAccessAuthorization(token.getProjectId(), token.getWorkspaceId(), token.getProjectMemberId(), token);
    }

    public void markUsed(PlatformAccessTokenRef token) {
        token.setLastUsedAt(LocalDateTime.now());
        platformAccessTokenRefMapper.updateById(token);
    }

    private String extractBearerToken(String authorizationHeader) {
        if (!StringUtils.hasText(authorizationHeader)) {
            throw new InvalidPlatformAccessTokenException("Missing Authorization header");
        }
        String prefix = "Bearer ";
        if (!authorizationHeader.regionMatches(true, 0, prefix, 0, prefix.length())) {
            throw new InvalidPlatformAccessTokenException("Authorization header must use Bearer token");
        }
        String rawToken = authorizationHeader.substring(prefix.length()).trim();
        if (!StringUtils.hasText(rawToken)) {
            throw new InvalidPlatformAccessTokenException("Bearer token must not be blank");
        }
        return rawToken;
    }

    private void assertCapabilityAllowed(PlatformAccessTokenRef token, String capabilityCode) {
        if (!StringUtils.hasText(token.getAllowedCapabilityCodes())) {
            return;
        }
        Set<String> allowedCodes = Arrays.stream(token.getAllowedCapabilityCodes().split(","))
                .filter(StringUtils::hasText)
                .map(value -> value.trim().toUpperCase(Locale.ROOT))
                .collect(Collectors.toSet());
        if (!allowedCodes.contains(capabilityCode.trim().toUpperCase(Locale.ROOT))) {
            throw new PlatformAccessDeniedException("Platform access token cannot use capability: " + capabilityCode);
        }
    }
}
