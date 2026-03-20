package com.aiplatform.agent.gateway;

import com.aiplatform.agent.gateway.entity.ProjectAiKeyRef;
import com.aiplatform.agent.gateway.entity.PlatformAccessTokenRef;
import com.aiplatform.agent.gateway.entity.ProjectWorkspaceRef;
import com.aiplatform.agent.gateway.entity.WorkspaceAiCapabilityRef;
import com.aiplatform.agent.gateway.mapper.PlatformAccessTokenRefMapper;
import com.aiplatform.agent.gateway.mapper.ProjectAiKeyRefMapper;
import com.aiplatform.agent.gateway.mapper.ProjectWorkspaceRefMapper;
import com.aiplatform.agent.gateway.mapper.WorkspaceAiCapabilityRefMapper;
import com.aiplatform.agent.gateway.service.CodexChatCompletionClient;
import com.aiplatform.agent.gateway.service.PlatformAccessTokenCodec;
import com.aiplatform.agent.gateway.service.ProviderProxyResponse;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.Sql.ExecutionPhase;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM workspace_ai_capabilities",
        "DELETE FROM project_workspaces",
        "DELETE FROM platform_access_tokens",
        "DELETE FROM project_members",
        "DELETE FROM project_ai_keys",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class WorkspaceGatewayControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private ProjectWorkspaceRefMapper projectWorkspaceRefMapper;

    @Autowired
    private WorkspaceAiCapabilityRefMapper workspaceAiCapabilityRefMapper;

    @Autowired
    private ProjectAiKeyRefMapper projectAiKeyRefMapper;

    @Autowired
    private PlatformAccessTokenRefMapper platformAccessTokenRefMapper;

    @MockBean(name = "codexChatCompletionClient")
    private CodexChatCompletionClient codexChatCompletionClient;

    private Long projectId;
    private Long workspaceId;
    private Long aiKeyId;
    private String accessToken;

    @BeforeEach
    void setUp() {
        jdbcTemplate.update("INSERT INTO projects(name, code, project_type, branch_strategy, status) VALUES (?, ?, ?, ?, ?)",
                "Gateway Project", "gateway-project", "TECH_PLATFORM", "TRUNK_BASED", "ACTIVE");
        projectId = jdbcTemplate.queryForObject("SELECT id FROM projects WHERE code = ?", Long.class, "gateway-project");
        jdbcTemplate.update("INSERT INTO project_members(project_id, name, email, role, status) VALUES (?, ?, ?, ?, ?)",
                projectId, "Alice", "alice@example.com", "DEVELOPER", "ACTIVE");
        Long projectMemberId = jdbcTemplate.queryForObject("SELECT id FROM project_members WHERE email = ?", Long.class, "alice@example.com");

        ProjectWorkspaceRef workspace = new ProjectWorkspaceRef();
        workspace.setProjectId(projectId);
        workspace.setName("Gateway Workspace");
        workspace.setCode("GW_WORKSPACE");
        workspace.setWorkspaceType("R_AND_D");
        workspace.setStatus("ACTIVE");
        projectWorkspaceRefMapper.insert(workspace);
        workspaceId = workspace.getId();

        WorkspaceAiCapabilityRef binding = new WorkspaceAiCapabilityRef();
        binding.setWorkspaceId(workspaceId);
        binding.setAiCapabilityId(1L);
        binding.setProviderId(0L);
        binding.setModelId(0L);
        binding.setMonthlyRequestQuota(100);
        binding.setMonthlyTokenQuota(0L);
        binding.setMonthlyCostQuota(java.math.BigDecimal.ZERO);
        binding.setOverQuotaStrategy("BLOCK");
        binding.setStatus("ACTIVE");
        workspaceAiCapabilityRefMapper.insert(binding);

        ProjectAiKeyRef aiKey = new ProjectAiKeyRef();
        aiKey.setProjectId(projectId);
        aiKey.setName("codex-main");
        aiKey.setProvider("CODEX");
        aiKey.setSecretKey("sk-test-1234");
        aiKey.setMaskedKey("sk-****1234");
        aiKey.setMonthlyQuota(10L);
        aiKey.setUsedQuota(0L);
        aiKey.setAlertThresholdPercent(80);
        aiKey.setStatus("ACTIVE");
        projectAiKeyRefMapper.insert(aiKey);
        aiKeyId = aiKey.getId();

        accessToken = "pat_test_access_token";
        PlatformAccessTokenRef platformToken = new PlatformAccessTokenRef();
        platformToken.setProjectId(projectId);
        platformToken.setWorkspaceId(workspaceId);
        platformToken.setProjectMemberId(projectMemberId);
        platformToken.setName("alice-cli");
        platformToken.setRoleSnapshot("DEVELOPER");
        platformToken.setTokenPrefix("pat_test_access");
        platformToken.setTokenHash(PlatformAccessTokenCodec.hashToken(accessToken));
        platformToken.setAllowedCapabilityCodes("GENERAL_CHAT");
        platformToken.setStatus("ACTIVE");
        platformToken.setExpiresAt(java.time.LocalDateTime.now().plusDays(7));
        platformAccessTokenRefMapper.insert(platformToken);
    }

    @Test
    void shouldProxyChatCompletionForWorkspace() throws Exception {
        when(codexChatCompletionClient.chatCompletion(any(), any()))
                .thenReturn(new ProviderProxyResponse(HttpStatus.OK, "{\"id\":\"chatcmpl_test\"}", MediaType.APPLICATION_JSON));

        mockMvc.perform(post("/api/gateway/workspaces/{workspaceId}/chat/completions", workspaceId)
                        .header("Authorization", "Bearer " + accessToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "capabilityCode": "GENERAL_CHAT",
                                  "model": "gpt-4.1",
                                  "messages": [
                                    {
                                      "role": "user",
                                      "content": "hello"
                                    }
                                  ]
                                }
                                """))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("chatcmpl_test"));

        ProjectAiKeyRef refreshed = projectAiKeyRefMapper.selectById(aiKeyId);
        Assertions.assertEquals(1L, refreshed.getUsedQuota());
    }

    @Test
    void shouldRejectCapabilityWhenNotBoundToWorkspace() throws Exception {
        jdbcTemplate.update("DELETE FROM workspace_ai_capabilities WHERE workspace_id = ?", workspaceId);

        mockMvc.perform(post("/api/gateway/workspaces/{workspaceId}/chat/completions", workspaceId)
                        .header("Authorization", "Bearer " + accessToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "capabilityCode": "GENERAL_CHAT",
                                  "model": "gpt-4.1",
                                  "messages": [
                                    {
                                      "role": "user",
                                      "content": "hello"
                                    }
                                  ]
                                }
                                """))
                .andExpect(status().isForbidden());

        verifyNoInteractions(codexChatCompletionClient);
    }

    @Test
    void shouldRejectWhenProjectAiKeyMissing() throws Exception {
        jdbcTemplate.update("DELETE FROM project_ai_keys WHERE id = ?", aiKeyId);

        mockMvc.perform(post("/api/gateway/workspaces/{workspaceId}/chat/completions", workspaceId)
                        .header("Authorization", "Bearer " + accessToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "capabilityCode": "GENERAL_CHAT",
                                  "model": "gpt-4.1",
                                  "messages": [
                                    {
                                      "role": "user",
                                      "content": "hello"
                                    }
                                  ]
                                }
                                """))
                .andExpect(status().isNotFound());

        verifyNoInteractions(codexChatCompletionClient);
    }

    @Test
    void shouldRejectWhenAuthorizationMissing() throws Exception {
        mockMvc.perform(post("/api/gateway/workspaces/{workspaceId}/chat/completions", workspaceId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "capabilityCode": "GENERAL_CHAT",
                                  "model": "gpt-4.1",
                                  "messages": [
                                    {
                                      "role": "user",
                                      "content": "hello"
                                    }
                                  ]
                                }
                                """))
                .andExpect(status().isUnauthorized());

        verifyNoInteractions(codexChatCompletionClient);
    }
}
