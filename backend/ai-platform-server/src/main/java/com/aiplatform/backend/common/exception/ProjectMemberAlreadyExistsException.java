package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目下成员邮箱重复时抛出的异常。
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class ProjectMemberAlreadyExistsException extends RuntimeException {

    
    public ProjectMemberAlreadyExistsException(Long projectId, String email) {
        super("Project member already exists: projectId=%d, email=%s".formatted(projectId, email));
    }
}
