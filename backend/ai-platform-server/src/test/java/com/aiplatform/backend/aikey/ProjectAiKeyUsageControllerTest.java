package com.aiplatform.backend.aikey;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.Sql.ExecutionPhase;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM project_ai_keys",
        "DELETE FROM project_members",
        "DELETE FROM services",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class ProjectAiKeyUsageControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Test
    void shouldReturnUsageSummaryForProjectKeys() throws Exception {
        Long projectId = createProject("mall-ai-key-usage");

        insertAiKey(projectId, "codex-main", "ACTIVE", 1_000_000L, 800_000L, 70);
        insertAiKey(projectId, "codex-backup", "DISABLED", 500_000L, 500_000L, 90);
        insertAiKey(projectId, "codex-lab", "ACTIVE", 250_000L, 100_000L, 80);

        mockMvc.perform(get("/api/projects/{projectId}/ai-keys/usage", projectId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.projectId").value(projectId))
            .andExpect(jsonPath("$.provider").value("CODEX"))
            .andExpect(jsonPath("$.totalMonthlyQuota").value(1750000))
            .andExpect(jsonPath("$.totalUsedQuota").value(1400000))
            .andExpect(jsonPath("$.remainingQuota").value(350000))
            .andExpect(jsonPath("$.usageRatePercent").value(80))
            .andExpect(jsonPath("$.activeKeyCount").value(2))
            .andExpect(jsonPath("$.disabledKeyCount").value(1))
            .andExpect(jsonPath("$.alertingKeyCount").value(1))
            .andExpect(jsonPath("$.exhaustedKeyCount").value(1));
    }

    @Test
    void shouldReturnZeroSummaryWhenProjectHasNoAiKeys() throws Exception {
        Long projectId = createProject("mall-ai-key-empty");

        mockMvc.perform(get("/api/projects/{projectId}/ai-keys/usage", projectId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.projectId").value(projectId))
            .andExpect(jsonPath("$.provider").value("CODEX"))
            .andExpect(jsonPath("$.totalMonthlyQuota").value(0))
            .andExpect(jsonPath("$.totalUsedQuota").value(0))
            .andExpect(jsonPath("$.remainingQuota").value(0))
            .andExpect(jsonPath("$.usageRatePercent").value(0))
            .andExpect(jsonPath("$.activeKeyCount").value(0))
            .andExpect(jsonPath("$.disabledKeyCount").value(0))
            .andExpect(jsonPath("$.alertingKeyCount").value(0))
            .andExpect(jsonPath("$.exhaustedKeyCount").value(0));
    }

    @Test
    void shouldReturnNotFoundWhenProjectMissing() throws Exception {
        mockMvc.perform(get("/api/projects/999/ai-keys/usage"))
            .andExpect(status().isNotFound());
    }

    private Long createProject(String code) throws Exception {
        MvcResult result = mockMvc.perform(post("/api/projects")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Mall System",
                          "code": "%s",
                          "projectType": "PRODUCT",
                          "branchStrategy": "TRUNK_BASED"
                        }
                        """.formatted(code)))
            .andExpect(status().isCreated())
            .andReturn();

        JsonNode response = objectMapper.readTree(result.getResponse().getContentAsString());
        return response.get("id").asLong();
    }

    private void insertAiKey(Long projectId,
                             String name,
                             String status,
                             long monthlyQuota,
                             long usedQuota,
                             int alertThresholdPercent) {
        jdbcTemplate.update("""
                INSERT INTO project_ai_keys (
                    project_id,
                    name,
                    provider,
                    secret_key,
                    masked_key,
                    monthly_quota,
                    used_quota,
                    alert_threshold_percent,
                    status
                ) VALUES (?, ?, 'CODEX', ?, ?, ?, ?, ?, ?)
                """,
                projectId,
                name,
                "sk-" + name + "-secret",
                "sk-****cret",
                monthlyQuota,
                usedQuota,
                alertThresholdPercent,
                status);
    }
}

