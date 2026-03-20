package com.aiplatform.backend.service;

import com.aiplatform.backend.common.exception.WorkspaceCapabilityAlreadyExistsException;
import com.aiplatform.backend.dto.CreateWorkspaceCapabilityRequest;
import com.aiplatform.backend.dto.WorkspaceCapabilityResponse;
import com.aiplatform.backend.entity.AiCapability;
import com.aiplatform.backend.entity.WorkspaceAiCapability;
import com.aiplatform.backend.mapper.WorkspaceAiCapabilityMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * 工作区能力绑定业务服务。
 */
@Service
public class WorkspaceCapabilityService {

    private final WorkspaceAiCapabilityMapper workspaceAiCapabilityMapper;
    private final ProjectWorkspaceService projectWorkspaceService;
    private final AiCapabilityService aiCapabilityService;

    public WorkspaceCapabilityService(WorkspaceAiCapabilityMapper workspaceAiCapabilityMapper,
                                      ProjectWorkspaceService projectWorkspaceService,
                                      AiCapabilityService aiCapabilityService) {
        this.workspaceAiCapabilityMapper = workspaceAiCapabilityMapper;
        this.projectWorkspaceService = projectWorkspaceService;
        this.aiCapabilityService = aiCapabilityService;
    }

    /**
     * 为指定工作区创建能力绑定。
     */
    public WorkspaceCapabilityResponse create(Long workspaceId, CreateWorkspaceCapabilityRequest request) {
        projectWorkspaceService.getById(workspaceId);
        AiCapability capability = aiCapabilityService.getById(request.aiCapabilityId());

        Long providerId = request.providerId() == null ? 0L : request.providerId();
        Long modelId = request.modelId() == null ? 0L : request.modelId();
        if (exists(workspaceId, request.aiCapabilityId(), providerId, modelId)) {
            throw new WorkspaceCapabilityAlreadyExistsException(workspaceId, request.aiCapabilityId(), providerId, modelId);
        }

        WorkspaceAiCapability binding = new WorkspaceAiCapability();
        binding.setWorkspaceId(workspaceId);
        binding.setAiCapabilityId(request.aiCapabilityId());
        binding.setProviderId(providerId);
        binding.setModelId(modelId);
        binding.setMonthlyRequestQuota(request.monthlyRequestQuota() == null ? 0 : request.monthlyRequestQuota());
        binding.setMonthlyTokenQuota(request.monthlyTokenQuota() == null ? 0L : request.monthlyTokenQuota());
        binding.setMonthlyCostQuota(request.monthlyCostQuota() == null ? BigDecimal.ZERO : request.monthlyCostQuota());
        binding.setOverQuotaStrategy(request.overQuotaStrategy() == null ? "BLOCK" : request.overQuotaStrategy());
        binding.setStatus("ACTIVE");
        workspaceAiCapabilityMapper.insert(binding);
        return WorkspaceCapabilityResponse.from(binding, capability);
    }

    /**
     * 查询指定工作区下的能力绑定列表。
     */
    public List<WorkspaceCapabilityResponse> listByWorkspaceId(Long workspaceId) {
        projectWorkspaceService.getById(workspaceId);
        return workspaceAiCapabilityMapper.selectList(Wrappers.<WorkspaceAiCapability>lambdaQuery()
                        .eq(WorkspaceAiCapability::getWorkspaceId, workspaceId)
                        .orderByAsc(WorkspaceAiCapability::getId))
                .stream()
                .map(binding -> WorkspaceCapabilityResponse.from(binding, aiCapabilityService.getById(binding.getAiCapabilityId())))
                .toList();
    }

    private boolean exists(Long workspaceId, Long capabilityId, Long providerId, Long modelId) {
        return workspaceAiCapabilityMapper.selectCount(Wrappers.<WorkspaceAiCapability>lambdaQuery()
                .eq(WorkspaceAiCapability::getWorkspaceId, workspaceId)
                .eq(WorkspaceAiCapability::getAiCapabilityId, capabilityId)
                .eq(WorkspaceAiCapability::getProviderId, providerId)
                .eq(WorkspaceAiCapability::getModelId, modelId)) > 0;
    }
}
