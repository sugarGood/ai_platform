package com.aiplatform.backend.project.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 项目实体类，对应数据库表 {@code projects}。
 *
 * <p>该实体是 AI 中台项目模块的核心领域对象，记录项目的基本信息、
 * 类型、分支策略以及生命周期状态。通过 MyBatis-Plus 的 {@link TableName}
 * 注解与数据库表进行映射。</p>
 *
 * @see com.aiplatform.backend.project.mapper.ProjectMapper
 * @see com.aiplatform.backend.project.service.ProjectService
 */
@TableName("projects")
public class Project {

    /** 项目主键 ID，数据库自增生成 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 项目名称，用于界面展示，不可为空 */
    private String name;

    /** 项目编码，全局唯一标识，通常为大写字母与数字的组合，不可为空 */
    private String code;

    /**
     * 项目类型。
     * <p>可选值：{@code PRODUCT}（产品项目）、{@code INTERNAL_SYSTEM}（内部系统）、
     * {@code TECH_PLATFORM}（技术平台）、{@code DATA_PRODUCT}（数据产品）</p>
     */
    private String projectType;

    /**
     * 分支策略，决定项目代码仓库的分支管理模式。
     * <p>可选值：{@code GIT_FLOW}、{@code TRUNK_BASED}、{@code FEATURE_BRANCH}</p>
     */
    private String branchStrategy;

    /**
     * 项目状态，表示项目当前的生命周期阶段。
     * <p>创建时默认为 {@code ACTIVE}</p>
     */
    private String status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public String getProjectType() {
        return projectType;
    }

    public void setProjectType(String projectType) {
        this.projectType = projectType;
    }

    public String getBranchStrategy() {
        return branchStrategy;
    }

    public void setBranchStrategy(String branchStrategy) {
        this.branchStrategy = branchStrategy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
