package com.aiplatform.backend.service.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 服务实体类，对应数据库表 {@code services}。
 *
 * <p>表示项目下的一个微服务/应用模块，记录服务的基本元数据，
 * 包括所属项目、服务类型、默认代码分支以及当前状态。</p>
 *
 * @see com.aiplatform.backend.service.mapper.ServiceEntityMapper
 */
@TableName("services")
public class ServiceEntity {

    /** 服务主键 ID，数据库自增生成 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属项目 ID，关联 {@code projects} 表主键 */
    private Long projectId;

    /** 服务名称，项目内唯一标识 */
    private String name;

    /**
     * 服务类型，取值范围：
     * {@code BACKEND}、{@code FRONTEND}、{@code MOBILE}、{@code DATA}、
     * {@code TEST}、{@code AI_AGENT}、{@code SHARED_COMPONENT}
     */
    private String serviceType;

    /** 默认代码分支名称，例如 {@code "main"}、{@code "master"} */
    private String defaultBranch;

    /** 服务状态，例如 {@code "ACTIVE"}、{@code "ARCHIVED"} */
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

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getDefaultBranch() {
        return defaultBranch;
    }

    public void setDefaultBranch(String defaultBranch) {
        this.defaultBranch = defaultBranch;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
