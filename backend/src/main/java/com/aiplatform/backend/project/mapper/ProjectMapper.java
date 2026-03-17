package com.aiplatform.backend.project.mapper;

import com.aiplatform.backend.project.entity.Project;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 项目数据访问层 Mapper 接口。
 *
 * <p>继承 MyBatis-Plus 的 {@link BaseMapper}，自动获得对 {@code projects} 表的
 * 通用 CRUD 能力（如 {@code insert}、{@code selectById}、{@code selectList}、
 * {@code updateById}、{@code deleteById} 等），无需编写额外 XML 映射文件。</p>
 *
 * <p>如需自定义 SQL，可在此接口中添加方法并配合
 * {@code @Select} / {@code @Update} 等注解或对应的 XML 映射。</p>
 *
 * @see BaseMapper
 * @see Project
 */
@Mapper
public interface ProjectMapper extends BaseMapper<Project> {
}
