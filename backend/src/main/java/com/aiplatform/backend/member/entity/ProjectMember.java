package com.aiplatform.backend.member.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

/**
 * 项目成员实体类，对应数据库表 {@code project_members}。
 *
 * <p>记录某个项目中的成员信息，包括成员姓名、邮箱、角色及状态。
 * 一个项目可以拥有多个成员，同一邮箱在同一项目中不可重复。</p>
 *
 * @see com.aiplatform.backend.member.mapper.ProjectMemberMapper
 */
@TableName("project_members")
public class ProjectMember {

    /** 主键 ID，自增生成 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属项目 ID，关联 {@code projects} 表主键 */
    private Long projectId;

    /** 成员姓名 */
    private String name;

    /** 成员邮箱，同一项目内唯一 */
    private String email;

    /** 成员角色，取值范围：{@code OWNER}（项目负责人）、{@code DEVELOPER}（开发者） */
    private String role;

    /** 成员状态，取值范围：{@code ACTIVE}（活跃） */
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
