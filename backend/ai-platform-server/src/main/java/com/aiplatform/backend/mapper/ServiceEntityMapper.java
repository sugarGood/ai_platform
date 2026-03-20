package com.aiplatform.backend.mapper;

import com.aiplatform.backend.entity.ServiceEntity;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * 服务数据访问接口。
 */
@Mapper
public interface ServiceEntityMapper extends BaseMapper<ServiceEntity> {
}
