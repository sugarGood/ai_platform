package com.aiplatform.backend.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record CreateWorkspaceAccessTokenRequest(
        @NotNull
        Long projectMemberId,
        @NotBlank
        String name,
        List<@NotBlank String> allowedCapabilityCodes,
        @Min(1)
        @Max(365)
        Integer expiresInDays
) {
}
