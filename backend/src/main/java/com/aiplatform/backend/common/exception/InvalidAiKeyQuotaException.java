package com.aiplatform.backend.common.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * AI 密钥配额无效异常。
 *
 * <p>当设置或修改 AI 密钥的月度配额时，若新配额值不合法（例如小于已使用量）则抛出此异常。
 * 通过 {@code @ResponseStatus(HttpStatus.BAD_REQUEST)} 注解，Spring MVC
 * 会自动将该异常映射为 HTTP 400 响应，表示请求参数无效。
 *
 * @see org.springframework.web.bind.annotation.ResponseStatus
 */
@ResponseStatus(HttpStatus.BAD_REQUEST)
public class InvalidAiKeyQuotaException extends RuntimeException {

    /**
     * 构造 AI 密钥配额无效异常。
     *
     * @param monthlyQuota 设置的月度配额值
     * @param usedQuota    当前已使用的配额量
     */
    public InvalidAiKeyQuotaException(Long monthlyQuota, Long usedQuota) {
        super("Invalid ai key quota: monthlyQuota=%d, usedQuota=%d".formatted(monthlyQuota, usedQuota));
    }
}
