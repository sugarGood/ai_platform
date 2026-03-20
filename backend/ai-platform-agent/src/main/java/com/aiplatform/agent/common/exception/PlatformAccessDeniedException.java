package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.FORBIDDEN)
public class PlatformAccessDeniedException extends RuntimeException {

    public PlatformAccessDeniedException(String message) {
        super(message);
    }
}
