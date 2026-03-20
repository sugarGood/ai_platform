package com.aiplatform.backend.capability;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AiCapabilityControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldListSeededCapabilities() throws Exception {
        mockMvc.perform(get("/api/agent/capabilities"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.length()").value(9))
                .andExpect(jsonPath("$[0].code").value("GENERAL_CHAT"))
                .andExpect(jsonPath("$[1].code").value("CODE_GENERATION"));
    }
}


