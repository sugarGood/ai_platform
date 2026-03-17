package com.aiplatform.backend.member.mapper;

import com.aiplatform.backend.member.entity.ProjectMember;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 项目成员数据访问接口。
 *
 * <p>继承 MyBatis-Plus 的 {@link BaseMapper}，自动提供对 {@code project_members} 表的
 * 基础 CRUD 操作（insert、selectById、selectList、update、delete 等），
 * 无需手动编写 SQL 映射。</p>
 *
 * @see com.aiplatform.backend.member.entity.ProjectMember
 */
@Mapper
public interface ProjectMemberMapper extends BaseMapper<ProjectMember> {
}
