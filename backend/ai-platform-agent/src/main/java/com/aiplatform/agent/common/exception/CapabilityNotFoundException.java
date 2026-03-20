package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 能力目录中不存在指定能力时抛出的异常。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class CapabilityNotFoundException extends RuntimeException {

    /**
     * 构造能力不存在异常。
     *
     * @param capabilityCode 能力编码
     */
    public CapabilityNotFoundException(String capabilityCode) {
        super("AI capability not found: " + capabilityCode);
    }
}
