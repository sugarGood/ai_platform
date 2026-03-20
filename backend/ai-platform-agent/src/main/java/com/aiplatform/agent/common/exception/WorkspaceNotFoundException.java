package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 工作区不存在或不可用时抛出的异常。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class WorkspaceNotFoundException extends RuntimeException {

    /**
     * 构造工作区不存在异常。
     *
     * @param workspaceId 工作区 ID
     */
    public WorkspaceNotFoundException(Long workspaceId) {
        super("Workspace not found: " + workspaceId);
    }
}
