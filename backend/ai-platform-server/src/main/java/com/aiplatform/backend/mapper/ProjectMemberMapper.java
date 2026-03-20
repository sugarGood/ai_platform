package com.aiplatform.backend.mapper;

import com.aiplatform.backend.entity.ProjectMember;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 项目成员数据访问接口。
 */
@Mapper
public interface ProjectMemberMapper extends BaseMapper<ProjectMember> {
}
