package com.aiplatform.agent.gateway.service;

import com.aiplatform.agent.common.exception.CapabilityNotAllowedException;
import com.aiplatform.agent.common.exception.CapabilityNotFoundException;
import com.aiplatform.agent.common.exception.PlatformAccessDeniedException;
import com.aiplatform.agent.common.exception.ProjectAiKeyNotFoundException;
import com.aiplatform.agent.common.exception.ProjectAiKeyQuotaExceededException;
import com.aiplatform.agent.common.exception.WorkspaceNotFoundException;
import com.aiplatform.agent.gateway.dto.ChatCompletionRequest;
import com.aiplatform.agent.gateway.entity.AiCapabilityRef;
import com.aiplatform.agent.gateway.entity.ProjectAiKeyRef;
import com.aiplatform.agent.gateway.entity.ProjectWorkspaceRef;
import com.aiplatform.agent.gateway.entity.WorkspaceAiCapabilityRef;
import com.aiplatform.agent.gateway.mapper.AiCapabilityRefMapper;
import com.aiplatform.agent.gateway.mapper.ProjectAiKeyRefMapper;
import com.aiplatform.agent.gateway.mapper.ProjectWorkspaceRefMapper;
import com.aiplatform.agent.gateway.mapper.WorkspaceAiCapabilityRefMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.Locale;
import java.util.Set;

/**
 * Coordinates workspace validation, capability checks, provider key selection and upstream forwarding.
 */
@Service
public class WorkspaceGatewayService {

    private static final String STATUS_ACTIVE = "ACTIVE";
    private static final Set<String> SUPPORTED_REQUEST_MODES = Set.of("CHAT", "CODE");

    private final ProjectWorkspaceRefMapper projectWorkspaceRefMapper;
    private final AiCapabilityRefMapper aiCapabilityRefMapper;
    private final WorkspaceAiCapabilityRefMapper workspaceAiCapabilityRefMapper;
    private final ProjectAiKeyRefMapper projectAiKeyRefMapper;
    private final ChatCompletionUpstreamClient chatCompletionUpstreamClient;
    private final PlatformAccessTokenAuthService platformAccessTokenAuthService;

    public WorkspaceGatewayService(ProjectWorkspaceRefMapper projectWorkspaceRefMapper,
                                   AiCapabilityRefMapper aiCapabilityRefMapper,
                                   WorkspaceAiCapabilityRefMapper workspaceAiCapabilityRefMapper,
                                   ProjectAiKeyRefMapper projectAiKeyRefMapper,
                                   ChatCompletionUpstreamClient chatCompletionUpstreamClient,
                                   PlatformAccessTokenAuthService platformAccessTokenAuthService) {
        this.projectWorkspaceRefMapper = projectWorkspaceRefMapper;
        this.aiCapabilityRefMapper = aiCapabilityRefMapper;
        this.workspaceAiCapabilityRefMapper = workspaceAiCapabilityRefMapper;
        this.projectAiKeyRefMapper = projectAiKeyRefMapper;
        this.chatCompletionUpstreamClient = chatCompletionUpstreamClient;
        this.platformAccessTokenAuthService = platformAccessTokenAuthService;
    }

    /**
     * Processes a workspace chat request through the full gateway pipeline.
     */
    public ProviderProxyResponse chatCompletion(Long workspaceId, String authorization, ChatCompletionRequest request) {
        PlatformAccessAuthorization accessAuthorization =
                platformAccessTokenAuthService.authorize(workspaceId, authorization, request.capabilityCode());
        ProjectWorkspaceRef workspace = getWorkspace(workspaceId);
        if (!accessAuthorization.projectId().equals(workspace.getProjectId())) {
            throw new PlatformAccessDeniedException("Platform access token project does not match workspace project");
        }
        AiCapabilityRef capability = getCapability(request.capabilityCode());
        assertRequestModeSupported(capability);
        assertCapabilityEnabled(workspaceId, capability.getId(), capability.getCode());

        ProjectAiKeyRef aiKey = getProjectAiKey(workspace.getProjectId(), request.effectiveProvider());
        assertQuotaAvailable(aiKey);

        ProviderProxyResponse response = chatCompletionUpstreamClient.chatCompletion(aiKey, request);
        // Quota is consumed only when the upstream call succeeds at the HTTP layer.
        if (response.statusCode().is2xxSuccessful()) {
            incrementUsage(aiKey);
            platformAccessTokenAuthService.markUsed(accessAuthorization.token());
        }
        return response;
    }

    /**
     * Loads the workspace and ensures it is still active for gateway access.
     */
    private ProjectWorkspaceRef getWorkspace(Long workspaceId) {
        ProjectWorkspaceRef workspace = projectWorkspaceRefMapper.selectById(workspaceId);
        if (workspace == null || !STATUS_ACTIVE.equals(workspace.getStatus())) {
            throw new WorkspaceNotFoundException(workspaceId);
        }
        return workspace;
    }

    /**
     * Resolves the requested capability code to an enabled capability definition.
     */
    private AiCapabilityRef getCapability(String capabilityCode) {
        AiCapabilityRef capability = aiCapabilityRefMapper.selectOne(Wrappers.<AiCapabilityRef>lambdaQuery()
                .eq(AiCapabilityRef::getCode, capabilityCode)
                .eq(AiCapabilityRef::getStatus, STATUS_ACTIVE)
                .last("LIMIT 1"));
        if (capability == null) {
            throw new CapabilityNotFoundException(capabilityCode);
        }
        return capability;
    }

    /**
     * Restricts the gateway to request modes it knows how to proxy.
     */
    private void assertRequestModeSupported(AiCapabilityRef capability) {
        if (!SUPPORTED_REQUEST_MODES.contains(capability.getRequestMode())) {
            throw new CapabilityNotAllowedException(-1L, capability.getCode());
        }
    }

    /**
     * Verifies the workspace has been granted the requested capability.
     */
    private void assertCapabilityEnabled(Long workspaceId, Long capabilityId, String capabilityCode) {
        Long count = workspaceAiCapabilityRefMapper.selectCount(Wrappers.<WorkspaceAiCapabilityRef>lambdaQuery()
                .eq(WorkspaceAiCapabilityRef::getWorkspaceId, workspaceId)
                .eq(WorkspaceAiCapabilityRef::getAiCapabilityId, capabilityId)
                .eq(WorkspaceAiCapabilityRef::getStatus, STATUS_ACTIVE));
        if (count == null || count == 0) {
            throw new CapabilityNotAllowedException(workspaceId, capabilityCode);
        }
    }

    /**
     * Selects the first active key for the requested provider under the project.
     */
    private ProjectAiKeyRef getProjectAiKey(Long projectId, String provider) {
        String normalizedProvider = provider.toUpperCase(Locale.ROOT);
        ProjectAiKeyRef aiKey = projectAiKeyRefMapper.selectOne(Wrappers.<ProjectAiKeyRef>lambdaQuery()
                .eq(ProjectAiKeyRef::getProjectId, projectId)
                .eq(ProjectAiKeyRef::getProvider, normalizedProvider)
                .eq(ProjectAiKeyRef::getStatus, STATUS_ACTIVE)
                .orderByAsc(ProjectAiKeyRef::getId)
                .last("LIMIT 1"));
        if (aiKey == null) {
            throw new ProjectAiKeyNotFoundException(projectId, normalizedProvider);
        }
        return aiKey;
    }

    /**
     * Prevents forwarding once a project key reaches its monthly cap.
     */
    private void assertQuotaAvailable(ProjectAiKeyRef aiKey) {
        if (aiKey.getUsedQuota() >= aiKey.getMonthlyQuota()) {
            throw new ProjectAiKeyQuotaExceededException(aiKey.getId());
        }
    }

    /**
     * Persists the new usage counter after a successful upstream request.
     */
    private void incrementUsage(ProjectAiKeyRef aiKey) {
        aiKey.setUsedQuota(aiKey.getUsedQuota() + 1);
        projectAiKeyRefMapper.updateById(aiKey);
    }
}
