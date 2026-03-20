package com.aiplatform.backend.service;

import com.aiplatform.backend.dto.CreateProjectRequest;
import com.aiplatform.backend.entity.Project;
import com.aiplatform.backend.mapper.ProjectMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Handles the core lifecycle of project records.
 */
@Service
public class ProjectService {

    private final ProjectMapper projectMapper;

    public ProjectService(ProjectMapper projectMapper) {
        this.projectMapper = projectMapper;
    }

    /**
     * Creates a project from the inbound request and assigns the default active status.
     */
    public Project create(CreateProjectRequest request) {
        Project project = new Project();
        project.setName(request.name());
        project.setCode(request.code());
        project.setProjectType(request.projectType());
        project.setBranchStrategy(request.branchStrategy());
        // New projects are immediately available for downstream binding operations.
        project.setStatus("ACTIVE");
        projectMapper.insert(project);
        return project;
    }

    /**
     * Returns all projects ordered by primary key so the API response stays deterministic.
     */
    public List<Project> list() {
        return projectMapper.selectList(Wrappers.<Project>lambdaQuery().orderByAsc(Project::getId));
    }

    /**
     * Loads a project by id and converts missing data into a domain exception.
     */
    public Project getByIdOrThrow(Long projectId) {
        Project project = projectMapper.selectById(projectId);
        if (project == null) {
            throw new com.aiplatform.backend.common.exception.ProjectNotFoundException(projectId);
        }
        return project;
    }
}
