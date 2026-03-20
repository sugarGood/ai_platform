package com.aiplatform.backend.workspace;

import com.aiplatform.backend.entity.Project;
import com.aiplatform.backend.mapper.ProjectMapper;
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
@Sql(statements = {
        "DELETE FROM workspace_ai_capabilities",
        "DELETE FROM project_workspaces",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class ProjectWorkspaceControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ProjectMapper projectMapper;

    @Test
    void shouldCreateWorkspaceUnderProject() throws Exception {
        Long projectId = createProject("workspace-create");

        mockMvc.perform(post("/api/projects/{projectId}/workspaces", projectId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name": "R&D Workspace",
                                  "code": "RND_AGENT",
                                  "workspaceType": "R_AND_D",
                                  "description": "Engineering workspace",
                                  "defaultProviderId": 1,
                                  "defaultModelId": 101
                                }
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.projectId").value(projectId))
                .andExpect(jsonPath("$.name").value("R&D Workspace"))
                .andExpect(jsonPath("$.code").value("RND_AGENT"))
                .andExpect(jsonPath("$.workspaceType").value("R_AND_D"))
                .andExpect(jsonPath("$.status").value("ACTIVE"));
    }

    @Test
    void shouldListProjectWorkspaces() throws Exception {
        Long projectId = createProject("workspace-list");

        mockMvc.perform(post("/api/projects/{projectId}/workspaces", projectId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name": "QA Workspace",
                                  "code": "QA_SPACE",
                                  "workspaceType": "TEST",
                                  "description": "Testing workspace"
                                }
                                """))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/projects/{projectId}/workspaces", projectId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].code").value("QA_SPACE"));
    }

    @Test
    void shouldReturnNotFoundWhenProjectMissing() throws Exception {
        mockMvc.perform(post("/api/projects/999/workspaces")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "name": "QA Workspace",
                                  "code": "QA_SPACE",
                                  "workspaceType": "TEST"
                                }
                                """))
                .andExpect(status().isNotFound());
    }

    private Long createProject(String code) {
        Project project = new Project();
        project.setName("Gateway Project");
        project.setCode(code);
        project.setProjectType("TECH_PLATFORM");
        project.setBranchStrategy("TRUNK_BASED");
        project.setStatus("ACTIVE");
        projectMapper.insert(project);
        return project.getId();
    }
}
