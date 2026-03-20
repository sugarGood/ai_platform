package com.aiplatform.agent.gateway.service;

import com.aiplatform.agent.gateway.dto.ChatCompletionRequest;
import com.aiplatform.agent.gateway.entity.ProjectAiKeyRef;

/**
 * Abstraction over provider-specific chat-completion forwarding implementations.
 */
public interface ChatCompletionUpstreamClient {

    /**
     * Sends the normalized gateway request to the upstream provider selected by the project key.
     */
    ProviderProxyResponse chatCompletion(ProjectAiKeyRef aiKey, ChatCompletionRequest request);
}
