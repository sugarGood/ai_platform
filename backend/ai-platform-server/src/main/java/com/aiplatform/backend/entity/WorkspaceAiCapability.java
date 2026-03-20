package com.aiplatform.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 工作区能力绑定实体，对应 `workspace_ai_capabilities` 表。
 */
@TableName("workspace_ai_capabilities")
public class WorkspaceAiCapability {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long workspaceId;
    private Long aiCapabilityId;
    private Long providerId;
    private Long modelId;
    private Integer monthlyRequestQuota;
    private Long monthlyTokenQuota;
    private BigDecimal monthlyCostQuota;
    private String overQuotaStrategy;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getWorkspaceId() {
        return workspaceId;
    }

    public void setWorkspaceId(Long workspaceId) {
        this.workspaceId = workspaceId;
    }

    public Long getAiCapabilityId() {
        return aiCapabilityId;
    }

    public void setAiCapabilityId(Long aiCapabilityId) {
        this.aiCapabilityId = aiCapabilityId;
    }

    public Long getProviderId() {
        return providerId;
    }

    public void setProviderId(Long providerId) {
        this.providerId = providerId;
    }

    public Long getModelId() {
        return modelId;
    }

    public void setModelId(Long modelId) {
        this.modelId = modelId;
    }

    public Integer getMonthlyRequestQuota() {
        return monthlyRequestQuota;
    }

    public void setMonthlyRequestQuota(Integer monthlyRequestQuota) {
        this.monthlyRequestQuota = monthlyRequestQuota;
    }

    public Long getMonthlyTokenQuota() {
        return monthlyTokenQuota;
    }

    public void setMonthlyTokenQuota(Long monthlyTokenQuota) {
        this.monthlyTokenQuota = monthlyTokenQuota;
    }

    public BigDecimal getMonthlyCostQuota() {
        return monthlyCostQuota;
    }

    public void setMonthlyCostQuota(BigDecimal monthlyCostQuota) {
        this.monthlyCostQuota = monthlyCostQuota;
    }

    public String getOverQuotaStrategy() {
        return overQuotaStrategy;
    }

    public void setOverQuotaStrategy(String overQuotaStrategy) {
        this.overQuotaStrategy = overQuotaStrategy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
