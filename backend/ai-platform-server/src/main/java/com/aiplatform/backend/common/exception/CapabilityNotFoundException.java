package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 指定能力不存在时抛出的异常。
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class CapabilityNotFoundException extends RuntimeException {

    public CapabilityNotFoundException(Long capabilityId) {
        super("AI capability not found: " + capabilityId);
    }

    public CapabilityNotFoundException(String capabilityCode) {
        super("AI capability not found: " + capabilityCode);
    }
}
