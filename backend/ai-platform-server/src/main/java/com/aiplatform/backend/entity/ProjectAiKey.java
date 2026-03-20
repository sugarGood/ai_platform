package com.aiplatform.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 项目 AI Key 实体，对应 `project_ai_keys` 表。
 */
@TableName("project_ai_keys")
public class ProjectAiKey {

    
    @TableId(type = IdType.AUTO)
    private Long id;

    
    private Long projectId;

    
    private String name;

    
    private String provider;

    
    private String secretKey;

    
    private String maskedKey;

    
    private Long monthlyQuota;

    
    private Long usedQuota;

    
    private Integer alertThresholdPercent;

    
    private String status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getProjectId() {
        return projectId;
    }

    public void setProjectId(Long projectId) {
        this.projectId = projectId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public void setSecretKey(String secretKey) {
        this.secretKey = secretKey;
    }

    public String getMaskedKey() {
        return maskedKey;
    }

    public void setMaskedKey(String maskedKey) {
        this.maskedKey = maskedKey;
    }

    public Long getMonthlyQuota() {
        return monthlyQuota;
    }

    public void setMonthlyQuota(Long monthlyQuota) {
        this.monthlyQuota = monthlyQuota;
    }

    public Long getUsedQuota() {
        return usedQuota;
    }

    public void setUsedQuota(Long usedQuota) {
        this.usedQuota = usedQuota;
    }

    public Integer getAlertThresholdPercent() {
        return alertThresholdPercent;
    }

    public void setAlertThresholdPercent(Integer alertThresholdPercent) {
        this.alertThresholdPercent = alertThresholdPercent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
