package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class ProjectMemberNotFoundException extends RuntimeException {

    public ProjectMemberNotFoundException(Long projectId, Long memberId) {
        super("Project member not found: projectId=%d, memberId=%d".formatted(projectId, memberId));
    }
}
