package com.aiplatform.agent.gateway.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 工作区只读引用实体。
 *
 * <p>映射表 {@code project_workspaces}，用于校验请求所属工作区。</p>
 */
@TableName("project_workspaces")
public class ProjectWorkspaceRef {

    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectId;
    private String name;
    private String code;
    private String workspaceType;
    private String description;
    private Long defaultProviderId;
    private Long defaultModelId;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getWorkspaceType() {
        return workspaceType;
    }

    public void setWorkspaceType(String workspaceType) {
        this.workspaceType = workspaceType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getDefaultProviderId() {
        return defaultProviderId;
    }

    public void setDefaultProviderId(Long defaultProviderId) {
        this.defaultProviderId = defaultProviderId;
    }

    public Long getDefaultModelId() {
        return defaultModelId;
    }

    public void setDefaultModelId(Long defaultModelId) {
        this.defaultModelId = defaultModelId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
