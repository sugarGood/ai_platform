package com.aiplatform.agent.gateway.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.HashMap;
import java.util.Map;

/**
 * 网关上游服务商配置。
 *
 * <p>用于配置各个 provider 的基础地址与兼容接口路径。</p>
 */
@ConfigurationProperties(prefix = "ai.gateway")
public class GatewayProviderProperties {

    private Map<String, ProviderConfig> providers = new HashMap<>();

    public Map<String, ProviderConfig> getProviders() {
        return providers;
    }

    public void setProviders(Map<String, ProviderConfig> providers) {
        this.providers = providers;
    }

    /**
     * 单个上游服务商配置项。
     */
    public static class ProviderConfig {
        private String baseUrl;
        private String chatCompletionsPath = "/v1/chat/completions";

        public String getBaseUrl() {
            return baseUrl;
        }

        public void setBaseUrl(String baseUrl) {
            this.baseUrl = baseUrl;
        }

        public String getChatCompletionsPath() {
            return chatCompletionsPath;
        }

        public void setChatCompletionsPath(String chatCompletionsPath) {
            this.chatCompletionsPath = chatCompletionsPath;
        }
    }
}
