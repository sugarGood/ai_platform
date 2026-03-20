package com.aiplatform.backend.dto;

import com.aiplatform.backend.entity.AiCapability;

/**
 * AI 能力响应对象。
 */
public record AiCapabilityResponse(
        Long id,
        String code,
        String name,
        String capabilityType,
        String requestMode,
        String description,
        String status
) {
    
    public static AiCapabilityResponse from(AiCapability capability) {
        return new AiCapabilityResponse(
                capability.getId(),
                capability.getCode(),
                capability.getName(),
                capability.getCapabilityType(),
                capability.getRequestMode(),
                capability.getDescription(),
                capability.getStatus()
        );
    }
}
