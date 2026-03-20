package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * AI Key 配额参数非法时抛出的异常。
 */
@ResponseStatus(HttpStatus.BAD_REQUEST)
public class InvalidAiKeyQuotaException extends RuntimeException {

    
    public InvalidAiKeyQuotaException(Long monthlyQuota, Long usedQuota) {
        super("Invalid ai key quota: monthlyQuota=%d, usedQuota=%d".formatted(monthlyQuota, usedQuota));
    }
}
