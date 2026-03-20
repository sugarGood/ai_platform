package com.aiplatform.agent.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * 项目级 AI Key 额度耗尽时抛出的异常。
 */
@ResponseStatus(HttpStatus.TOO_MANY_REQUESTS)
public class ProjectAiKeyQuotaExceededException extends RuntimeException {

    /**
     * 构造 AI Key 配额超限异常。
     *
     * @param aiKeyId 项目 AI Key ID
     */
    public ProjectAiKeyQuotaExceededException(Long aiKeyId) {
        super("Project AI key quota exceeded: " + aiKeyId);
    }
}
