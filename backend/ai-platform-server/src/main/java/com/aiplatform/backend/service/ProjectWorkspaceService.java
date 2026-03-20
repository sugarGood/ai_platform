package com.aiplatform.backend.service;

import com.aiplatform.backend.common.exception.ProjectNotFoundException;
import com.aiplatform.backend.common.exception.WorkspaceNotFoundException;
import com.aiplatform.backend.dto.CreateWorkspaceRequest;
import com.aiplatform.backend.entity.ProjectWorkspace;
import com.aiplatform.backend.mapper.ProjectMapper;
import com.aiplatform.backend.mapper.ProjectWorkspaceMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Manages workspaces that belong to a project.
 */
@Service
public class ProjectWorkspaceService {

    private final ProjectWorkspaceMapper projectWorkspaceMapper;
    private final ProjectMapper projectMapper;

    public ProjectWorkspaceService(ProjectWorkspaceMapper projectWorkspaceMapper, ProjectMapper projectMapper) {
        this.projectWorkspaceMapper = projectWorkspaceMapper;
        this.projectMapper = projectMapper;
    }

    /**
     * Creates a workspace under the specified project after validating the parent project exists.
     */
    public ProjectWorkspace create(Long projectId, CreateWorkspaceRequest request) {
        assertProjectExists(projectId);

        ProjectWorkspace workspace = new ProjectWorkspace();
        workspace.setProjectId(projectId);
        workspace.setName(request.name());
        workspace.setCode(request.code());
        workspace.setWorkspaceType(request.workspaceType());
        workspace.setDescription(request.description());
        workspace.setDefaultProviderId(request.defaultProviderId());
        workspace.setDefaultModelId(request.defaultModelId());
        workspace.setStatus("ACTIVE");
        projectWorkspaceMapper.insert(workspace);
        return workspace;
    }

    /**
     * Lists workspaces for a project in id order to keep client-side displays stable.
     */
    public List<ProjectWorkspace> listByProjectId(Long projectId) {
        assertProjectExists(projectId);
        return projectWorkspaceMapper.selectList(Wrappers.<ProjectWorkspace>lambdaQuery()
                .eq(ProjectWorkspace::getProjectId, projectId)
                .orderByAsc(ProjectWorkspace::getId));
    }

    /**
     * Returns a workspace by id or fails fast with a domain-specific exception.
     */
    public ProjectWorkspace getById(Long workspaceId) {
        ProjectWorkspace workspace = projectWorkspaceMapper.selectById(workspaceId);
        if (workspace == null) {
            throw new WorkspaceNotFoundException(workspaceId);
        }
        return workspace;
    }

    /**
     * Guards workspace operations from being created under a missing project.
     */
    private void assertProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new ProjectNotFoundException(projectId);
        }
    }
}
