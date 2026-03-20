package com.aiplatform.agent.gateway.service;

import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;

/**
 * 上游代理响应。
 *
 * @param statusCode HTTP 状态码
 * @param body 响应体
 * @param contentType 响应类型
 */
public record ProviderProxyResponse(
        HttpStatusCode statusCode,
        String body,
        MediaType contentType
) {
}
