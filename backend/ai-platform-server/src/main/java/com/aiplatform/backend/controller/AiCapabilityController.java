package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.AiCapabilityResponse;
import com.aiplatform.backend.service.AiCapabilityService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * AI 能力目录控制器。
 */
@RestController
@RequestMapping("/api/agent/capabilities")
public class AiCapabilityController {

    private final AiCapabilityService aiCapabilityService;

    public AiCapabilityController(AiCapabilityService aiCapabilityService) {
        this.aiCapabilityService = aiCapabilityService;
    }

    
    /**
     * 查询当前可用的 AI 能力列表。
     */
    @GetMapping
    public List<AiCapabilityResponse> list() {
        return aiCapabilityService.listActiveCapabilities().stream()
                .map(AiCapabilityResponse::from)
                .toList();
    }
}
