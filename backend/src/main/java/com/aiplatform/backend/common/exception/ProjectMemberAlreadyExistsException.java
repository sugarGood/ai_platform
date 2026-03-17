package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目成员已存在异常。
 *
 * <p>当尝试向某个项目添加成员，但该成员（以邮箱标识）已存在于项目中时抛出此异常。
 * 通过 {@code @ResponseStatus(HttpStatus.CONFLICT)} 注解，Spring MVC
 * 会自动将该异常映射为 HTTP 409 响应，表示资源冲突。
 *
 * @see org.springframework.web.bind.annotation.ResponseStatus
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class ProjectMemberAlreadyExistsException extends RuntimeException {

    /**
     * 构造项目成员已存在异常。
     *
     * @param projectId 所属项目的 ID
     * @param email     已存在的成员邮箱地址
     */
    public ProjectMemberAlreadyExistsException(Long projectId, String email) {
        super("Project member already exists: projectId=%d, email=%s".formatted(projectId, email));
    }
}
