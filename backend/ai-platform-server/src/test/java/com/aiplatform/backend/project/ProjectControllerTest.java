package com.aiplatform.backend.project;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.Sql.ExecutionPhase;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Sql(statements = "DELETE FROM projects", executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class ProjectControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldCreateProject() throws Exception {
        mockMvc.perform(post("/api/projects")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "鍟嗗煄绯荤粺",
                          "code": "mall",
                          "projectType": "PRODUCT",
                          "branchStrategy": "TRUNK_BASED"
                        }
                        """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.name").value("鍟嗗煄绯荤粺"))
            .andExpect(jsonPath("$.code").value("mall"))
            .andExpect(jsonPath("$.projectType").value("PRODUCT"))
            .andExpect(jsonPath("$.branchStrategy").value("TRUNK_BASED"));
    }

    @Test
    void shouldListProjectsAfterCreation() throws Exception {
        mockMvc.perform(post("/api/projects")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "鐢ㄦ埛涓績",
                          "code": "user-center",
                          "projectType": "TECH_PLATFORM",
                          "branchStrategy": "FEATURE_BRANCH"
                        }
                        """))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/projects"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.length()").value(1))
            .andExpect(jsonPath("$[0].code").value("user-center"));
    }

    @Test
    void shouldRejectBlankProjectName() throws Exception {
        mockMvc.perform(post("/api/projects")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "",
                          "code": "bad-project",
                          "projectType": "PRODUCT",
                          "branchStrategy": "TRUNK_BASED"
                        }
                        """))
            .andExpect(status().isBadRequest());
    }
}

