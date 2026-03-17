package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目 AI 密钥已存在异常。
 *
 * <p>当尝试为某个项目创建 AI 密钥，但该项目下已存在同名密钥时抛出此异常。
 * 通过 {@code @ResponseStatus(HttpStatus.CONFLICT)} 注解，Spring MVC
 * 会自动将该异常映射为 HTTP 409 响应，表示资源冲突。
 *
 * @see org.springframework.web.bind.annotation.ResponseStatus
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class ProjectAiKeyAlreadyExistsException extends RuntimeException {

    /**
     * 构造项目 AI 密钥已存在异常。
     *
     * @param projectId 所属项目的 ID
     * @param name      已存在的 AI 密钥名称
     */
    public ProjectAiKeyAlreadyExistsException(Long projectId, String name) {
        super("Project ai key already exists: projectId=%d, name=%s".formatted(projectId, name));
    }
}
