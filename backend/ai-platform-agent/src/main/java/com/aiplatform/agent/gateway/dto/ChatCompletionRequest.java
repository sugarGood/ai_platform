package com.aiplatform.agent.gateway.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;

import java.util.List;

/**
 * 工作区聊天补全请求。
 *
 * @param capabilityCode 能力编码
 * @param provider 上游服务商，未传时默认使用 {@code CODEX}
 * @param model 模型名称
 * @param messages 对话消息列表
 * @param stream 是否启用流式返回
 * @param temperature 温度参数
 * @param maxTokens 最大输出 token 数
 */
public record ChatCompletionRequest(
        @NotBlank String capabilityCode,
        String provider,
        @NotBlank String model,
        @NotEmpty List<@Valid ChatCompletionMessage> messages,
        Boolean stream,
        Double temperature,
        Integer maxTokens
) {

    /**
     * 获取规范化后的服务商编码。
     *
     * @return 服务商编码
     */
    public String effectiveProvider() {
        return provider == null || provider.isBlank() ? "CODEX" : provider.trim().toUpperCase();
    }

    /**
     * 判断是否启用流式输出。
     *
     * @return true 表示启用流式模式
     */
    public boolean streaming() {
        return Boolean.TRUE.equals(stream);
    }
}
