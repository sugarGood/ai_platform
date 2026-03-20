package com.aiplatform.backend.service;

import com.aiplatform.backend.common.exception.WorkspaceCapabilityNotEnabledException;
import com.aiplatform.backend.dto.CreateWorkspaceAccessTokenRequest;
import com.aiplatform.backend.dto.PlatformAccessTokenResponse;
import com.aiplatform.backend.entity.AiCapability;
import com.aiplatform.backend.entity.PlatformAccessToken;
import com.aiplatform.backend.entity.ProjectMember;
import com.aiplatform.backend.entity.ProjectWorkspace;
import com.aiplatform.backend.entity.WorkspaceAiCapability;
import com.aiplatform.backend.mapper.PlatformAccessTokenMapper;
import com.aiplatform.backend.mapper.WorkspaceAiCapabilityMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

@Service
public class PlatformAccessTokenService {

    private static final String STATUS_ACTIVE = "ACTIVE";

    private final PlatformAccessTokenMapper platformAccessTokenMapper;
    private final ProjectWorkspaceService projectWorkspaceService;
    private final ProjectMemberService projectMemberService;
    private final AiCapabilityService aiCapabilityService;
    private final WorkspaceAiCapabilityMapper workspaceAiCapabilityMapper;

    public PlatformAccessTokenService(PlatformAccessTokenMapper platformAccessTokenMapper,
                                      ProjectWorkspaceService projectWorkspaceService,
                                      ProjectMemberService projectMemberService,
                                      AiCapabilityService aiCapabilityService,
                                      WorkspaceAiCapabilityMapper workspaceAiCapabilityMapper) {
        this.platformAccessTokenMapper = platformAccessTokenMapper;
        this.projectWorkspaceService = projectWorkspaceService;
        this.projectMemberService = projectMemberService;
        this.aiCapabilityService = aiCapabilityService;
        this.workspaceAiCapabilityMapper = workspaceAiCapabilityMapper;
    }

    public PlatformAccessTokenResponse create(Long workspaceId, CreateWorkspaceAccessTokenRequest request) {
        ProjectWorkspace workspace = projectWorkspaceService.getById(workspaceId);
        ProjectMember projectMember = projectMemberService.getByProjectAndId(workspace.getProjectId(), request.projectMemberId());
        Set<String> allowedCapabilityCodes = resolveAllowedCapabilityCodes(workspaceId, request.allowedCapabilityCodes());

        String rawToken = PlatformAccessTokenCodec.generateRawToken();
        PlatformAccessToken token = new PlatformAccessToken();
        token.setProjectId(workspace.getProjectId());
        token.setWorkspaceId(workspaceId);
        token.setProjectMemberId(projectMember.getId());
        token.setName(request.name().trim());
        token.setRoleSnapshot(projectMember.getRole());
        token.setTokenPrefix(PlatformAccessTokenCodec.buildTokenPrefix(rawToken));
        token.setTokenHash(PlatformAccessTokenCodec.hashToken(rawToken));
        token.setAllowedCapabilityCodes(allowedCapabilityCodes.isEmpty() ? null : String.join(",", allowedCapabilityCodes));
        token.setStatus(STATUS_ACTIVE);
        token.setExpiresAt(LocalDateTime.now().plusDays(request.expiresInDays() == null ? 30L : request.expiresInDays()));
        platformAccessTokenMapper.insert(token);
        return PlatformAccessTokenResponse.from(token, projectMember, List.copyOf(allowedCapabilityCodes), rawToken);
    }

    public List<PlatformAccessTokenResponse> listByWorkspaceId(Long workspaceId) {
        ProjectWorkspace workspace = projectWorkspaceService.getById(workspaceId);
        return platformAccessTokenMapper.selectList(Wrappers.<PlatformAccessToken>lambdaQuery()
                        .eq(PlatformAccessToken::getWorkspaceId, workspaceId)
                        .orderByAsc(PlatformAccessToken::getId))
                .stream()
                .map(token -> PlatformAccessTokenResponse.from(
                        token,
                        projectMemberService.getByProjectAndId(workspace.getProjectId(), token.getProjectMemberId()),
                        parseAllowedCapabilityCodes(token.getAllowedCapabilityCodes()),
                        null))
                .toList();
    }

    private Set<String> resolveAllowedCapabilityCodes(Long workspaceId, List<String> requestedCodes) {
        if (requestedCodes == null || requestedCodes.isEmpty()) {
            return Set.of();
        }
        LinkedHashSet<String> normalizedCodes = requestedCodes.stream()
                .filter(StringUtils::hasText)
                .map(code -> code.trim().toUpperCase(Locale.ROOT))
                .collect(java.util.stream.Collectors.toCollection(LinkedHashSet::new));
        for (String code : normalizedCodes) {
            AiCapability capability = aiCapabilityService.listActiveCapabilities().stream()
                    .filter(item -> code.equals(item.getCode()))
                    .findFirst()
                    .orElseThrow(() -> new com.aiplatform.backend.common.exception.CapabilityNotFoundException(code));
            assertCapabilityEnabled(workspaceId, capability);
        }
        return normalizedCodes;
    }

    private void assertCapabilityEnabled(Long workspaceId, AiCapability capability) {
        Long count = workspaceAiCapabilityMapper.selectCount(Wrappers.<WorkspaceAiCapability>lambdaQuery()
                .eq(WorkspaceAiCapability::getWorkspaceId, workspaceId)
                .eq(WorkspaceAiCapability::getAiCapabilityId, capability.getId())
                .eq(WorkspaceAiCapability::getStatus, STATUS_ACTIVE));
        if (count == null || count == 0) {
            throw new WorkspaceCapabilityNotEnabledException(workspaceId, capability.getCode());
        }
    }

    private List<String> parseAllowedCapabilityCodes(String rawCodes) {
        if (!StringUtils.hasText(rawCodes)) {
            return List.of();
        }
        return List.of(rawCodes.split(","));
    }
}
