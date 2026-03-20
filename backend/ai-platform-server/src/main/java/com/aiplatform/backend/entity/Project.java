package com.aiplatform.backend.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 项目实体，对应 `projects` 表。
 */
@TableName("projects")
public class Project {

    
    @TableId(type = IdType.AUTO)
    private Long id;

    
    private String name;

    
    private String code;

    
    private String projectType;

    
    private String branchStrategy;

    
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
