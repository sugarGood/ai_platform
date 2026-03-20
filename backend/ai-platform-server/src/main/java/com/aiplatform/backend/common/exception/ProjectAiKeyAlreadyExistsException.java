package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目下存在同名 AI Key 时抛出的异常。
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class ProjectAiKeyAlreadyExistsException extends RuntimeException {

    
    public ProjectAiKeyAlreadyExistsException(Long projectId, String name) {
        super("Project ai key already exists: projectId=%d, name=%s".formatted(projectId, name));
    }
}
