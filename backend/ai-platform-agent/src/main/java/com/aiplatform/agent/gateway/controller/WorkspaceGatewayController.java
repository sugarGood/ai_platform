package com.aiplatform.agent.gateway.controller;

import com.aiplatform.agent.gateway.dto.ChatCompletionRequest;
import com.aiplatform.agent.gateway.service.ProviderProxyResponse;
import com.aiplatform.agent.gateway.service.WorkspaceGatewayService;
import jakarta.validation.Valid;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Receives workspace-scoped gateway requests and forwards them to the routing service.
 */
@RestController
@RequestMapping("/api/gateway/workspaces/{workspaceId}")
public class WorkspaceGatewayController {

    private final WorkspaceGatewayService workspaceGatewayService;

    public WorkspaceGatewayController(WorkspaceGatewayService workspaceGatewayService) {
        this.workspaceGatewayService = workspaceGatewayService;
    }

    /**
     * Proxies chat-completion requests for a workspace while preserving upstream status and body.
     */
    @PostMapping("/chat/completions")
    public ResponseEntity<String> chatCompletions(@PathVariable Long workspaceId,
                                                  @RequestHeader(value = HttpHeaders.AUTHORIZATION, required = false) String authorization,
                                                  @Valid @RequestBody ChatCompletionRequest request) {
        ProviderProxyResponse response = workspaceGatewayService.chatCompletion(workspaceId, authorization, request);
        // Fall back to JSON so clients still receive a parsable response when upstream omits the header.
        MediaType contentType = response.contentType() == null ? MediaType.APPLICATION_JSON : response.contentType();
        return ResponseEntity.status(response.statusCode())
                .contentType(contentType)
                .body(response.body());
    }
}
