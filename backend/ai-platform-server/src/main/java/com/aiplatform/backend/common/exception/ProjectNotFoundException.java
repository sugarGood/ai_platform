package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目不存在时抛出的异常。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ProjectNotFoundException extends RuntimeException {

    
    public ProjectNotFoundException(Long projectId) {
        super("Project not found: " + projectId);
    }
}
