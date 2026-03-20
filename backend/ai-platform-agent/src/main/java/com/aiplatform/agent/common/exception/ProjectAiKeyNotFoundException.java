package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目下找不到可用 AI Key 时抛出的异常。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ProjectAiKeyNotFoundException extends RuntimeException {

    /**
     * 构造项目 AI Key 不存在异常。
     *
     * @param projectId 项目 ID
     * @param provider 服务商编码
     */
    public ProjectAiKeyNotFoundException(Long projectId, String provider) {
        super("Project AI key not found: projectId=%d, provider=%s".formatted(projectId, provider));
    }
}
