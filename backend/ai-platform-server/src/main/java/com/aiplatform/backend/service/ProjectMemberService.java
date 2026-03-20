package com.aiplatform.backend.service;

import com.aiplatform.backend.common.exception.ProjectMemberAlreadyExistsException;
import com.aiplatform.backend.common.exception.ProjectMemberNotFoundException;
import com.aiplatform.backend.dto.CreateProjectMemberRequest;
import com.aiplatform.backend.entity.ProjectMember;
import com.aiplatform.backend.mapper.ProjectMapper;
import com.aiplatform.backend.mapper.ProjectMemberMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 项目成员业务服务。
 */
@Service
public class ProjectMemberService {

    private final ProjectMapper projectMapper;
    private final ProjectMemberMapper projectMemberMapper;

    public ProjectMemberService(ProjectMapper projectMapper, ProjectMemberMapper projectMemberMapper) {
        this.projectMapper = projectMapper;
        this.projectMemberMapper = projectMemberMapper;
    }

    /**
     * 在指定项目下创建成员。
     */
    public ProjectMember create(Long projectId, CreateProjectMemberRequest request) {
        ensureProjectExists(projectId);

        boolean exists = projectMemberMapper.selectCount(
                Wrappers.<ProjectMember>lambdaQuery()
                        .eq(ProjectMember::getProjectId, projectId)
                        .eq(ProjectMember::getEmail, request.email())
        ) > 0;
        if (exists) {
            throw new ProjectMemberAlreadyExistsException(projectId, request.email());
        }

        ProjectMember projectMember = new ProjectMember();
        projectMember.setProjectId(projectId);
        projectMember.setName(request.name());
        projectMember.setEmail(request.email());
        projectMember.setRole(request.role());
        projectMember.setStatus("ACTIVE");
        projectMemberMapper.insert(projectMember);
        return projectMember;
    }

    /**
     * 查询指定项目下的成员列表。
     */
    public List<ProjectMember> listByProjectId(Long projectId) {
        ensureProjectExists(projectId);
        return projectMemberMapper.selectList(
                Wrappers.<ProjectMember>lambdaQuery()
                        .eq(ProjectMember::getProjectId, projectId)
                        .orderByAsc(ProjectMember::getId)
        );
    }

    public ProjectMember getByProjectAndId(Long projectId, Long memberId) {
        ensureProjectExists(projectId);
        ProjectMember member = projectMemberMapper.selectOne(Wrappers.<ProjectMember>lambdaQuery()
                .eq(ProjectMember::getProjectId, projectId)
                .eq(ProjectMember::getId, memberId)
                .eq(ProjectMember::getStatus, "ACTIVE")
                .last("LIMIT 1"));
        if (member == null) {
            throw new ProjectMemberNotFoundException(projectId, memberId);
        }
        return member;
    }

    private void ensureProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new com.aiplatform.backend.common.exception.ProjectNotFoundException(projectId);
        }
    }
}
