package com.aiplatform.backend.member.service;

import com.aiplatform.backend.common.exception.ProjectMemberAlreadyExistsException;
import com.aiplatform.backend.common.exception.ProjectNotFoundException;
import com.aiplatform.backend.member.dto.CreateProjectMemberRequest;
import com.aiplatform.backend.member.entity.ProjectMember;
import com.aiplatform.backend.member.mapper.ProjectMemberMapper;
import com.aiplatform.backend.project.mapper.ProjectMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 项目成员业务服务层。
 *
 * <p>封装项目成员的核心业务逻辑，包括创建成员和查询成员列表。
 * 所有操作均会先校验项目是否存在，不存在时抛出 {@link ProjectNotFoundException}。</p>
 *
 * @see ProjectMemberMapper
 * @see ProjectMapper
 */
@Service
public class ProjectMemberService {

    private final ProjectMemberMapper projectMemberMapper;
    private final ProjectMapper projectMapper;

    public ProjectMemberService(ProjectMemberMapper projectMemberMapper, ProjectMapper projectMapper) {
        this.projectMemberMapper = projectMemberMapper;
        this.projectMapper = projectMapper;
    }

    /**
     * 在指定项目中创建一个新成员。
     *
     * <p>创建前会校验项目是否存在，并检查同一项目下是否已有相同邮箱的成员。
     * 新创建的成员状态默认为 {@code ACTIVE}。</p>
     *
     * @param projectId 项目 ID，必须对应一个已存在的项目
     * @param request   创建成员请求体，包含姓名、邮箱和角色
     * @return 创建成功后的 {@link ProjectMember} 实体（含数据库自增 ID）
     * @throws ProjectNotFoundException           当项目不存在时抛出
     * @throws ProjectMemberAlreadyExistsException 当该项目中已存在相同邮箱的成员时抛出
     */
    public ProjectMember create(Long projectId, CreateProjectMemberRequest request) {
        assertProjectExists(projectId);

        // 检查同一项目下是否已有相同邮箱的成员
        ProjectMember existing = projectMemberMapper.selectOne(Wrappers.<ProjectMember>lambdaQuery()
                .eq(ProjectMember::getProjectId, projectId)
                .eq(ProjectMember::getEmail, request.email()));
        if (existing != null) {
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
     * 查询指定项目的全部成员列表。
     *
     * @param projectId 项目 ID，必须对应一个已存在的项目
     * @return 该项目下的成员列表，按 ID 升序排列；若无成员则返回空列表
     * @throws ProjectNotFoundException 当项目不存在时抛出
     */
    public List<ProjectMember> listByProjectId(Long projectId) {
        assertProjectExists(projectId);
        return projectMemberMapper.selectList(Wrappers.<ProjectMember>lambdaQuery()
                .eq(ProjectMember::getProjectId, projectId)
                .orderByAsc(ProjectMember::getId));
    }

    /**
     * 校验项目是否存在，不存在时抛出异常。
     *
     * @param projectId 待校验的项目 ID
     * @throws ProjectNotFoundException 当项目不存在时抛出
     */
    private void assertProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new ProjectNotFoundException(projectId);
        }
    }
}
