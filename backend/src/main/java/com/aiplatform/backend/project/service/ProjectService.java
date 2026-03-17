package com.aiplatform.backend.project.service;

import com.aiplatform.backend.project.dto.CreateProjectRequest;
import com.aiplatform.backend.project.entity.Project;
import com.aiplatform.backend.project.mapper.ProjectMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 项目业务服务层，封装项目模块的核心业务逻辑。
 *
 * <p>负责项目的创建与查询操作，通过 {@link ProjectMapper} 与数据库交互。
 * 由 Spring 容器管理，通过构造器注入所需依赖。</p>
 *
 * @see ProjectMapper
 * @see com.aiplatform.backend.project.controller.ProjectController
 */
@Service
public class ProjectService {

    private final ProjectMapper projectMapper;

    public ProjectService(ProjectMapper projectMapper) {
        this.projectMapper = projectMapper;
    }

    /**
     * 创建新项目。
     *
     * <p>将请求 DTO 中的字段映射到 {@link Project} 实体，
     * 状态默认设置为 {@code ACTIVE}，然后插入数据库。
     * 插入成功后，实体的 {@code id} 字段会被 MyBatis-Plus 自动回填。</p>
     *
     * @param request 创建项目请求 DTO，包含名称、编码、类型和分支策略
     * @return 已持久化的项目实体（含数据库生成的主键 ID）
     */
    public Project create(CreateProjectRequest request) {
        Project project = new Project();
        project.setName(request.name());
        project.setCode(request.code());
        project.setProjectType(request.projectType());
        project.setBranchStrategy(request.branchStrategy());
        project.setStatus("ACTIVE");
        projectMapper.insert(project);
        return project;
    }

    /**
     * 查询全部项目列表。
     *
     * <p>返回按项目 ID 升序排列的所有项目。</p>
     *
     * @return 项目实体列表，可能为空列表
     */
    public List<Project> list() {
        return projectMapper.selectList(Wrappers.<Project>lambdaQuery().orderByAsc(Project::getId));
    }
}
