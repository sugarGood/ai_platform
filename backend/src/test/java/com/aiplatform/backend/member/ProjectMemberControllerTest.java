package com.aiplatform.backend.member;

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

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM project_members",
        "DELETE FROM services",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class ProjectMemberControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void shouldCreateMemberUnderProject() throws Exception {
        Long projectId = createProject("mall-member-create");

        mockMvc.perform(post("/api/projects/{projectId}/members", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Alice",
                          "email": "alice@example.com",
                          "role": "OWNER"
                        }
                        """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.projectId").value(projectId))
            .andExpect(jsonPath("$.name").value("Alice"))
            .andExpect(jsonPath("$.email").value("alice@example.com"))
            .andExpect(jsonPath("$.role").value("OWNER"))
            .andExpect(jsonPath("$.status").value("ACTIVE"));
    }

    @Test
    void shouldListMembersUnderProject() throws Exception {
        Long projectId = createProject("mall-member-list");

        mockMvc.perform(post("/api/projects/{projectId}/members", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Bob",
                          "email": "bob@example.com",
                          "role": "DEVELOPER"
                        }
                        """))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/projects/{projectId}/members", projectId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(1))
            .andExpect(jsonPath("$[0].projectId").value(projectId))
            .andExpect(jsonPath("$[0].email").value("bob@example.com"))
            .andExpect(jsonPath("$[0].role").value("DEVELOPER"));
    }

    @Test
    void shouldReturnNotFoundWhenProjectMissing() throws Exception {
        mockMvc.perform(post("/api/projects/999/members")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Carol",
                          "email": "carol@example.com",
                          "role": "OWNER"
                        }
                        """))
            .andExpect(status().isNotFound());
    }

    @Test
    void shouldReturnConflictWhenMemberEmailDuplicated() throws Exception {
        Long projectId = createProject("mall-member-duplicate");

        mockMvc.perform(post("/api/projects/{projectId}/members", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Dora",
                          "email": "dora@example.com",
                          "role": "OWNER"
                        }
                        """))
            .andExpect(status().isCreated());

        mockMvc.perform(post("/api/projects/{projectId}/members", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Dora Copy",
                          "email": "dora@example.com",
                          "role": "DEVELOPER"
                        }
                        """))
            .andExpect(status().isConflict());
    }

    @Test
    void shouldRejectInvalidRole() throws Exception {
        Long projectId = createProject("mall-member-invalid");

        mockMvc.perform(post("/api/projects/{projectId}/members", projectId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "Eve",
                          "email": "eve@example.com",
                          "role": "ADMIN"
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
