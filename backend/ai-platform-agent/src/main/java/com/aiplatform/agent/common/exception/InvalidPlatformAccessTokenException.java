package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.UNAUTHORIZED)
public class InvalidPlatformAccessTokenException extends RuntimeException {

    public InvalidPlatformAccessTokenException(String message) {
        super(message);
    }
}
