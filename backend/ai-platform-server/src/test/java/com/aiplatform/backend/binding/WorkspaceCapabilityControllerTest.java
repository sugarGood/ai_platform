package com.aiplatform.backend.binding;

import com.aiplatform.backend.entity.Project;
import com.aiplatform.backend.entity.ProjectWorkspace;
import com.aiplatform.backend.mapper.ProjectMapper;
import com.aiplatform.backend.mapper.ProjectWorkspaceMapper;
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
class WorkspaceCapabilityControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ProjectMapper projectMapper;

    @Autowired
    private ProjectWorkspaceMapper projectWorkspaceMapper;

    @Test
    void shouldBindCapabilityToWorkspace() throws Exception {
        Long workspaceId = createWorkspace("bind-create", "OPS_SPACE");

        mockMvc.perform(post("/api/workspaces/{workspaceId}/capabilities", workspaceId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "aiCapabilityId": 2,
                                  "providerId": 10,
                                  "modelId": 101,
                                  "monthlyRequestQuota": 500,
                                  "monthlyTokenQuota": 100000,
                                  "monthlyCostQuota": 199.99,
                                  "overQuotaStrategy": "ALLOW_WITH_ALERT"
                                }
                                """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.workspaceId").value(workspaceId))
                .andExpect(jsonPath("$.aiCapabilityId").value(2))
                .andExpect(jsonPath("$.capabilityCode").value("CODE_GENERATION"))
                .andExpect(jsonPath("$.overQuotaStrategy").value("ALLOW_WITH_ALERT"));
    }

    @Test
    void shouldListWorkspaceCapabilities() throws Exception {
        Long workspaceId = createWorkspace("bind-list", "PRODUCT_SPACE");

        mockMvc.perform(post("/api/workspaces/{workspaceId}/capabilities", workspaceId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "aiCapabilityId": 1
                                }
                                """))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/workspaces/{workspaceId}/capabilities", workspaceId))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].capabilityCode").value("GENERAL_CHAT"))
                .andExpect(jsonPath("$[0].status").value("ACTIVE"));
    }

    @Test
    void shouldRejectDuplicateBinding() throws Exception {
        Long workspaceId = createWorkspace("bind-dup", "DATA_SPACE");

        String requestBody = """
                {
                  "aiCapabilityId": 1,
                  "providerId": 0,
                  "modelId": 0
                }
                """;

        mockMvc.perform(post("/api/workspaces/{workspaceId}/capabilities", workspaceId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isCreated());

        mockMvc.perform(post("/api/workspaces/{workspaceId}/capabilities", workspaceId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestBody))
                .andExpect(status().isConflict());
    }

    private Long createWorkspace(String projectCode, String workspaceCode) {
        Project project = new Project();
        project.setName("Gateway Binding Project");
        project.setCode(projectCode);
        project.setProjectType("TECH_PLATFORM");
        project.setBranchStrategy("TRUNK_BASED");
        project.setStatus("ACTIVE");
        projectMapper.insert(project);

        ProjectWorkspace workspace = new ProjectWorkspace();
        workspace.setProjectId(project.getId());
        workspace.setName(workspaceCode);
        workspace.setCode(workspaceCode);
        workspace.setWorkspaceType("OPS");
        workspace.setStatus("ACTIVE");
        projectWorkspaceMapper.insert(workspace);
        return workspace.getId();
    }
}
