package com.aiplatform.backend.service;

import com.aiplatform.backend.common.exception.InvalidAiKeyQuotaException;
import com.aiplatform.backend.common.exception.ProjectAiKeyAlreadyExistsException;
import com.aiplatform.backend.dto.CreateProjectAiKeyRequest;
import com.aiplatform.backend.dto.ProjectAiKeyUsageResponse;
import com.aiplatform.backend.entity.ProjectAiKey;
import com.aiplatform.backend.mapper.ProjectAiKeyMapper;
import com.aiplatform.backend.mapper.ProjectMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Maintains project-level AI keys and their quota statistics.
 */
@Service
public class ProjectAiKeyService {

    private final ProjectMapper projectMapper;
    private final ProjectAiKeyMapper projectAiKeyMapper;

    public ProjectAiKeyService(ProjectMapper projectMapper, ProjectAiKeyMapper projectAiKeyMapper) {
        this.projectMapper = projectMapper;
        this.projectAiKeyMapper = projectAiKeyMapper;
    }

    /**
     * Creates a new AI key after validating project existence, quota bounds and duplicate names.
     */
    public ProjectAiKey create(Long projectId, CreateProjectAiKeyRequest request) {
        ensureProjectExists(projectId);
        validateQuota(request.monthlyQuota(), request.usedQuota());

        boolean exists = projectAiKeyMapper.selectCount(
                Wrappers.<ProjectAiKey>lambdaQuery()
                        .eq(ProjectAiKey::getProjectId, projectId)
                        .eq(ProjectAiKey::getName, request.name())
        ) > 0;
        if (exists) {
            throw new ProjectAiKeyAlreadyExistsException(projectId, request.name());
        }

        ProjectAiKey projectAiKey = new ProjectAiKey();
        projectAiKey.setProjectId(projectId);
        projectAiKey.setName(request.name());
        projectAiKey.setProvider(request.provider());
        projectAiKey.setSecretKey(request.secretKey());
        projectAiKey.setMaskedKey(maskKey(request.secretKey()));
        projectAiKey.setMonthlyQuota(request.monthlyQuota());
        projectAiKey.setUsedQuota(request.usedQuota());
        projectAiKey.setAlertThresholdPercent(request.alertThresholdPercent());
        projectAiKey.setStatus("ACTIVE");
        projectAiKeyMapper.insert(projectAiKey);
        return projectAiKey;
    }

    /**
     * Lists all AI keys that belong to a project.
     */
    public List<ProjectAiKey> listByProjectId(Long projectId) {
        ensureProjectExists(projectId);
        return projectAiKeyMapper.selectList(
                Wrappers.<ProjectAiKey>lambdaQuery()
                        .eq(ProjectAiKey::getProjectId, projectId)
                        .orderByAsc(ProjectAiKey::getId)
        );
    }

    /**
     * Aggregates usage metrics so the frontend can render quota dashboards without extra calculations.
     */
    public ProjectAiKeyUsageResponse usageSummary(Long projectId) {
        ensureProjectExists(projectId);
        List<ProjectAiKey> aiKeys = listByProjectId(projectId);

        long totalMonthlyQuota = aiKeys.stream().mapToLong(ProjectAiKey::getMonthlyQuota).sum();
        long totalUsedQuota = aiKeys.stream().mapToLong(ProjectAiKey::getUsedQuota).sum();
        long remainingQuota = Math.max(0L, totalMonthlyQuota - totalUsedQuota);
        int usageRatePercent = totalMonthlyQuota == 0 ? 0 : (int) ((totalUsedQuota * 100) / totalMonthlyQuota);
        int activeKeyCount = (int) aiKeys.stream().filter(aiKey -> "ACTIVE".equals(aiKey.getStatus())).count();
        int disabledKeyCount = (int) aiKeys.stream().filter(aiKey -> "DISABLED".equals(aiKey.getStatus())).count();
        // Alerting keys are active, not yet exhausted, and already beyond their warning threshold.
        int alertingKeyCount = (int) aiKeys.stream()
                .filter(aiKey -> "ACTIVE".equals(aiKey.getStatus()))
                .filter(aiKey -> aiKey.getUsedQuota() < aiKey.getMonthlyQuota())
                .filter(aiKey -> aiKey.getMonthlyQuota() > 0)
                .filter(aiKey -> aiKey.getUsedQuota() * 100 >= aiKey.getMonthlyQuota() * aiKey.getAlertThresholdPercent())
                .count();
        int exhaustedKeyCount = (int) aiKeys.stream()
                .filter(aiKey -> aiKey.getUsedQuota() >= aiKey.getMonthlyQuota())
                .count();
        String provider = aiKeys.stream()
                .map(ProjectAiKey::getProvider)
                .filter(value -> value != null && !value.isBlank())
                .findFirst()
                .orElse("CODEX");

        return new ProjectAiKeyUsageResponse(
                projectId,
                provider,
                totalMonthlyQuota,
                totalUsedQuota,
                remainingQuota,
                usageRatePercent,
                activeKeyCount,
                disabledKeyCount,
                alertingKeyCount,
                exhaustedKeyCount
        );
    }

    /**
     * Converts missing parent projects into a consistent business exception.
     */
    private void ensureProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new com.aiplatform.backend.common.exception.ProjectNotFoundException(projectId);
        }
    }

    /**
     * Prevents persisted usage from starting above the configured monthly cap.
     */
    private void validateQuota(Long monthlyQuota, Long usedQuota) {
        if (usedQuota > monthlyQuota) {
            throw new InvalidAiKeyQuotaException(monthlyQuota, usedQuota);
        }
    }

    /**
     * Stores only a partially visible key in query results to avoid leaking secrets.
     */
    private String maskKey(String secretKey) {
        if (secretKey == null || secretKey.length() <= 4) {
            return "****";
        }
        String prefix = secretKey.length() >= 3 ? secretKey.substring(0, 3) : "";
        return prefix + "****" + secretKey.substring(secretKey.length() - 4);
    }
}
