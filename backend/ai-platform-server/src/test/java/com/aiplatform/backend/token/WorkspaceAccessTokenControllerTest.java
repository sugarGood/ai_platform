package com.aiplatform.backend.token;

import org.hamcrest.Matchers;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.Sql.ExecutionPhase;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM platform_access_tokens",
        "DELETE FROM workspace_ai_capabilities",
        "DELETE FROM project_workspaces",
        "DELETE FROM project_members",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class WorkspaceAccessTokenControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void shouldCreateWorkspaceAccessToken() throws Exception {
        Long projectId = insertProject();
        Long memberId = insertProjectMember(projectId);
        Long workspaceId = insertWorkspace(projectId);
        bindCapability(workspaceId, 1L);

        String response = mockMvc.perform(post("/api/workspaces/{workspaceId}/access-tokens", workspaceId)
                        .contentType("application/json")
                        .content("""
                                {
                                  "projectMemberId": %d,
                                  "name": "alice-cli",
                                  "allowedCapabilityCodes": ["GENERAL_CHAT"],
                                  "expiresInDays": 7
                                }
                                """.formatted(memberId)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.projectMemberId").value(memberId))
                .andExpect(jsonPath("$.role").value("DEVELOPER"))
                .andExpect(jsonPath("$.allowedCapabilityCodes[0]").value("GENERAL_CHAT"))
                .andExpect(jsonPath("$.accessToken").isString())
                .andReturn()
                .getResponse()
                .getContentAsString();

        String tokenHash = jdbcTemplate.queryForObject(
                "SELECT token_hash FROM platform_access_tokens WHERE workspace_id = ?",
                String.class,
                workspaceId);
        assertThat(tokenHash).hasSize(64);
        assertThat(response).doesNotContain(tokenHash);
    }

    @Test
    void shouldListWorkspaceAccessTokensWithoutSecret() throws Exception {
        Long projectId = insertProject();
        Long memberId = insertProjectMember(projectId);
        Long workspaceId = insertWorkspace(projectId);
        bindCapability(workspaceId, 1L);

        mockMvc.perform(post("/api/workspaces/{workspaceId}/access-tokens", workspaceId)
                        .contentType("application/json")
                        .content("""
                                {
                                  "projectMemberId": %d,
                                  "name": "alice-cli"
                                }
                                """.formatted(memberId)))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/workspaces/{workspaceId}/access-tokens", workspaceId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("alice-cli"))
                .andExpect(jsonPath("$[0].accessToken").value(Matchers.nullValue()));
    }

    private Long insertProject() {
        jdbcTemplate.update("INSERT INTO projects(name, code, project_type, branch_strategy, status) VALUES (?, ?, ?, ?, ?)",
                "Token Project", "token-project", "TECH_PLATFORM", "TRUNK_BASED", "ACTIVE");
        return jdbcTemplate.queryForObject("SELECT id FROM projects WHERE code = ?", Long.class, "token-project");
    }

    private Long insertProjectMember(Long projectId) {
        jdbcTemplate.update("INSERT INTO project_members(project_id, name, email, role, status) VALUES (?, ?, ?, ?, ?)",
                projectId, "Alice", "alice@example.com", "DEVELOPER", "ACTIVE");
        return jdbcTemplate.queryForObject("SELECT id FROM project_members WHERE email = ?", Long.class, "alice@example.com");
    }

    private Long insertWorkspace(Long projectId) {
        jdbcTemplate.update("""
                INSERT INTO project_workspaces(project_id, name, code, workspace_type, description, status)
                VALUES (?, ?, ?, ?, ?, ?)
                """, projectId, "RD Workspace", "RD", "R_AND_D", "desc", "ACTIVE");
        return jdbcTemplate.queryForObject("SELECT id FROM project_workspaces WHERE code = ?", Long.class, "RD");
    }

    private void bindCapability(Long workspaceId, Long capabilityId) {
        jdbcTemplate.update("""
                INSERT INTO workspace_ai_capabilities(workspace_id, ai_capability_id, provider_id, model_id,
                monthly_request_quota, monthly_token_quota, monthly_cost_quota, over_quota_strategy, status)
                VALUES (?, ?, 0, 0, 100, 0, 0, 'BLOCK', 'ACTIVE')
                """, workspaceId, capabilityId);
    }
}
