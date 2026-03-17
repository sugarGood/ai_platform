package com.aiplatform.backend.aikey.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 项目 AI 密钥实体类，对应数据库表 {@code project_ai_keys}。
 *
 * <p>每条记录代表一个项目下注册的 AI 服务商密钥，包含密钥本体、脱敏展示值、
 * 月度配额及已用量、告警阈值、启停状态等信息。</p>
 *
 * @see com.aiplatform.backend.aikey.mapper.ProjectAiKeyMapper
 */
@TableName("project_ai_keys")
public class ProjectAiKey {

    /** 主键 ID，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属项目 ID，关联 projects 表主键 */
    private Long projectId;

    /** 密钥名称，同一项目内唯一，用于业务标识（如"生产环境主密钥"） */
    private String name;

    /** AI 服务提供商标识，目前仅支持 {@code "CODEX"} */
    private String provider;

    /** 原始密钥（完整值），仅在创建时写入，对外接口不返回此字段 */
    private String secretKey;

    /** 脱敏后的密钥，用于前端安全展示（如 {@code "sk-****abcd"}） */
    private String maskedKey;

    /** 月度配额（单位：token 数或调用次数），必须 >= 1 */
    private Long monthlyQuota;

    /** 当月已使用量，取值范围 0 ~ monthlyQuota */
    private Long usedQuota;

    /**
     * 用量告警阈值百分比，取值范围 1 ~ 100。
     * 当 {@code usedQuota / monthlyQuota * 100 >= alertThresholdPercent} 时触发告警。
     */
    private Integer alertThresholdPercent;

    /** 密钥状态，取值：{@code "ACTIVE"}（启用）、{@code "DISABLED"}（停用） */
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
