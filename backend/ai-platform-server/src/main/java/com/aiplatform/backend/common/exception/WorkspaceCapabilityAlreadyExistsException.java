package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 工作区能力绑定重复时抛出的异常。
 */
@ResponseStatus(HttpStatus.CONFLICT)
public class WorkspaceCapabilityAlreadyExistsException extends RuntimeException {

    
    public WorkspaceCapabilityAlreadyExistsException(Long workspaceId, Long capabilityId, Long providerId, Long modelId) {
        super("Workspace capability already exists: workspaceId=%d, capabilityId=%d, providerId=%d, modelId=%d"
                .formatted(workspaceId, capabilityId, providerId, modelId));
    }
}
