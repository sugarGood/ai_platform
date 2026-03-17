package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目未找到异常。
 *
 * <p>当根据项目 ID 查询项目但数据库中不存在对应记录时抛出此异常。
 * 通过 {@code @ResponseStatus(HttpStatus.NOT_FOUND)} 注解，Spring MVC
 * 会自动将该异常映射为 HTTP 404 响应。
 *
 * @see org.springframework.web.bind.annotation.ResponseStatus
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ProjectNotFoundException extends RuntimeException {

    /**
     * 构造项目未找到异常。
     *
     * @param projectId 未找到的项目 ID
     */
    public ProjectNotFoundException(Long projectId) {
        super("Project not found: " + projectId);
    }
}
