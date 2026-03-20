package com.aiplatform.agent.gateway.service;

import com.aiplatform.agent.common.exception.GatewayProviderNotConfiguredException;
import com.aiplatform.agent.gateway.config.GatewayProviderProperties;
import com.aiplatform.agent.gateway.dto.ChatCompletionRequest;
import com.aiplatform.agent.gateway.entity.ProjectAiKeyRef;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Default upstream client for providers that expose an OpenAI-compatible chat endpoint.
 */
@Component
public class CodexChatCompletionClient implements ChatCompletionUpstreamClient {

    private final GatewayProviderProperties gatewayProviderProperties;
    private final RestTemplate restTemplate = new RestTemplate();

    public CodexChatCompletionClient(GatewayProviderProperties gatewayProviderProperties) {
        this.gatewayProviderProperties = gatewayProviderProperties;
    }

    /**
     * Builds the provider request, forwards it, and normalizes both success and error responses.
     */
    @Override
    public ProviderProxyResponse chatCompletion(ProjectAiKeyRef aiKey, ChatCompletionRequest request) {
        GatewayProviderProperties.ProviderConfig providerConfig = gatewayProviderProperties.getProviders()
                .get(aiKey.getProvider().toUpperCase(Locale.ROOT));
        if (providerConfig == null || providerConfig.getBaseUrl() == null || providerConfig.getBaseUrl().isBlank()) {
            throw new GatewayProviderNotConfiguredException(aiKey.getProvider());
        }

        // Provider-specific base URLs and paths come from configuration so routing stays declarative.
        String url = providerConfig.getBaseUrl() + providerConfig.getChatCompletionsPath();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(aiKey.getSecretKey());
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(buildPayload(request), headers);
        try {
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
            MediaType contentType = response.getHeaders().getContentType();
            return new ProviderProxyResponse(response.getStatusCode(), response.getBody(), contentType == null ? MediaType.APPLICATION_JSON : contentType);
        } catch (HttpStatusCodeException exception) {
            MediaType contentType = exception.getResponseHeaders() == null
                    ? MediaType.APPLICATION_JSON
                    : exception.getResponseHeaders().getContentType();
            return new ProviderProxyResponse(exception.getStatusCode(), exception.getResponseBodyAsString(), contentType == null ? MediaType.APPLICATION_JSON : contentType);
        }
    }

    /**
     * Converts the internal request DTO into the payload expected by OpenAI-compatible providers.
     */
    private Map<String, Object> buildPayload(ChatCompletionRequest request) {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("model", request.model());
        payload.put("messages", toMessages(request));
        payload.put("stream", request.streaming());
        if (request.temperature() != null) {
            payload.put("temperature", request.temperature());
        }
        if (request.maxTokens() != null) {
            payload.put("max_tokens", request.maxTokens());
        }
        return payload;
    }

    /**
     * Maps each gateway message into the lightweight role/content structure accepted upstream.
     */
    private List<Map<String, Object>> toMessages(ChatCompletionRequest request) {
        return request.messages().stream()
                .map(message -> Map.<String, Object>of(
                        "role", message.role(),
                        "content", message.content()))
                .toList();
    }
}
