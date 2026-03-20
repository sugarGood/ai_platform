package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
public class WorkspaceCapabilityNotEnabledException extends RuntimeException {

    public WorkspaceCapabilityNotEnabledException(Long workspaceId, String capabilityCode) {
        super("Workspace capability not enabled: workspaceId=%d, capabilityCode=%s".formatted(workspaceId, capabilityCode));
    }
}
