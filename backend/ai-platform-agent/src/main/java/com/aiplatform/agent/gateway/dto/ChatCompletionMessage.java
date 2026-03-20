package com.aiplatform.agent.gateway.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * 聊天消息体。
 *
 * @param role 消息角色，例如 {@code user}/{@code system}/{@code assistant}
 * @param content 消息内容
 */
public record ChatCompletionMessage(
        @NotBlank String role,
        @NotBlank String content
) {
}
