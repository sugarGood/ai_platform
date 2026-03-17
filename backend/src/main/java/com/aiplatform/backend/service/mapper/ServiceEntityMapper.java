package com.aiplatform.backend.service.mapper;

import com.aiplatform.backend.service.entity.ServiceEntity;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 服务实体的 MyBatis-Plus Mapper 接口。
 *
 * <p>继承 {@link BaseMapper}，提供对 {@code services} 表的标准 CRUD 操作，
 * 无需编写自定义 SQL。由 MyBatis 框架在运行时自动生成实现。</p>
 *
 * @see ServiceEntity
 */
@Mapper
public interface ServiceEntityMapper extends BaseMapper<ServiceEntity> {
}
