package com.aiplatform.agent.gateway.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 工作区能力绑定只读引用实体。
 *
 * <p>映射表 {@code workspace_ai_capabilities}，用于判断工作区是否开通某项能力。</p>
 */
@TableName("workspace_ai_capabilities")
public class WorkspaceAiCapabilityRef {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long workspaceId;
    private Long aiCapabilityId;
    private Long providerId;
    private Long modelId;
    private Integer monthlyRequestQuota;
    private Long monthlyTokenQuota;
    private java.math.BigDecimal monthlyCostQuota;
    private String overQuotaStrategy;
    private String status;

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

    public java.math.BigDecimal getMonthlyCostQuota() {
        return monthlyCostQuota;
    }

    public void setMonthlyCostQuota(java.math.BigDecimal monthlyCostQuota) {
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
}
