package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 工作区不存在时抛出的异常。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class WorkspaceNotFoundException extends RuntimeException {

    
    public WorkspaceNotFoundException(Long workspaceId) {
        super("Workspace not found: " + workspaceId);
    }
}
