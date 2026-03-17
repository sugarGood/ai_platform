package com.aiplatform.backend.aikey;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.Sql.ExecutionPhase;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import static org.hamcrest.Matchers.not;
import static org.hamcrest.Matchers.hasKey;
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
class ProjectAiKeyControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void shouldCreateAiKeyUnderProject() throws Exception {
        Long projectId = createProject("mall-ai-key-create");

        mockMvc.perform(post("/api/projects/{projectId}/ai-keys", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "codex-main",
                          "provider": "CODEX",
                          "secretKey": "sk-codex-main-1234",
                          "monthlyQuota": 1000000,
                          "usedQuota": 120000,
                          "alertThresholdPercent": 80
                        }
                        """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.projectId").value(projectId))
            .andExpect(jsonPath("$.name").value("codex-main"))
            .andExpect(jsonPath("$.provider").value("CODEX"))
            .andExpect(jsonPath("$.maskedKey").value("sk-****1234"))
            .andExpect(jsonPath("$.status").value("ACTIVE"))
            .andExpect(jsonPath("$", not(hasKey("secretKey"))));
    }

    @Test
    void shouldListAiKeysUnderProject() throws Exception {
        Long projectId = createProject("mall-ai-key-list");

        mockMvc.perform(post("/api/projects/{projectId}/ai-keys", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "codex-backup",
                          "provider": "CODEX",
                          "secretKey": "sk-codex-backup-5678",
                          "monthlyQuota": 500000,
                          "usedQuota": 50000,
                          "alertThresholdPercent": 75
                        }
                        """))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/projects/{projectId}/ai-keys", projectId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(1))
            .andExpect(jsonPath("$[0].projectId").value(projectId))
            .andExpect(jsonPath("$[0].name").value("codex-backup"))
            .andExpect(jsonPath("$[0].maskedKey").value("sk-****5678"))
            .andExpect(jsonPath("$[0]", not(hasKey("secretKey"))));
    }

    @Test
    void shouldReturnNotFoundWhenProjectMissing() throws Exception {
        mockMvc.perform(post("/api/projects/999/ai-keys")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "codex-main",
                          "provider": "CODEX",
                          "secretKey": "sk-codex-main-1234",
                          "monthlyQuota": 1000000,
                          "usedQuota": 120000,
                          "alertThresholdPercent": 80
                        }
                        """))
            .andExpect(status().isNotFound());
    }

    @Test
    void shouldReturnConflictWhenAiKeyNameDuplicated() throws Exception {
        Long projectId = createProject("mall-ai-key-duplicate");

        mockMvc.perform(post("/api/projects/{projectId}/ai-keys", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "codex-main",
                          "provider": "CODEX",
                          "secretKey": "sk-codex-main-1234",
                          "monthlyQuota": 1000000,
                          "usedQuota": 100000,
                          "alertThresholdPercent": 80
                        }
                        """))
            .andExpect(status().isCreated());

        mockMvc.perform(post("/api/projects/{projectId}/ai-keys", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "codex-main",
                          "provider": "CODEX",
                          "secretKey": "sk-codex-main-9999",
                          "monthlyQuota": 900000,
                          "usedQuota": 200000,
                          "alertThresholdPercent": 85
                        }
                        """))
            .andExpect(status().isConflict());
    }

    @Test
    void shouldRejectUnsupportedProvider() throws Exception {
        Long projectId = createProject("mall-ai-key-provider");

        mockMvc.perform(post("/api/projects/{projectId}/ai-keys", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "gpt-main",
                          "provider": "GPT",
                          "secretKey": "sk-gpt-main-1234",
                          "monthlyQuota": 1000000,
                          "usedQuota": 120000,
                          "alertThresholdPercent": 80
                        }
                        """))
            .andExpect(status().isBadRequest());
    }

    @Test
    void shouldRejectWhenUsedQuotaExceedsMonthlyQuota() throws Exception {
        Long projectId = createProject("mall-ai-key-quota");

        mockMvc.perform(post("/api/projects/{projectId}/ai-keys", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "codex-main",
                          "provider": "CODEX",
                          "secretKey": "sk-codex-main-1234",
                          "monthlyQuota": 1000,
                          "usedQuota": 2000,
                          "alertThresholdPercent": 80
                        }
                        """))
            .andExpect(status().isBadRequest());
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
}
