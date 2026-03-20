package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 工作区未开通指定能力时抛出的异常。
 */
@ResponseStatus(HttpStatus.FORBIDDEN)
public class CapabilityNotAllowedException extends RuntimeException {

    /**
     * 构造能力未授权异常。
     *
     * @param workspaceId 工作区 ID
     * @param capabilityCode 能力编码
     */
    public CapabilityNotAllowedException(Long workspaceId, String capabilityCode) {
        super("Capability is not enabled for workspace: workspaceId=%d, capabilityCode=%s"
                .formatted(workspaceId, capabilityCode));
    }
}
