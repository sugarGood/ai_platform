# Backend Project/Service Bootstrap Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first runnable backend slice for the AI platform: a Spring Boot service with project CRUD and project-scoped service CRUD backed by MyBatis-Plus and tested with Spring Boot tests.

**Architecture:** Create a new `backend/` Spring Boot module using layered packages for controller, service, mapper, entity, and dto. Persist the first two domain aggregates (`Project`, `ServiceEntity`) with MyBatis-Plus mapper interfaces, expose REST endpoints, and use H2 plus SQL initialization for tests so the slice is runnable even before the remote MySQL instance is reachable.

**Tech Stack:** Java 17, Spring Boot 3, Spring Web, MyBatis-Plus, Bean Validation, H2 (tests/runtime dev), MySQL driver, Maven, JUnit 5, MockMvc

---

## Chunk 1: Backend Skeleton

### Task 1: Create Maven Spring Boot Module

**Files:**
- Create: `backend/pom.xml`
- Create: `backend/src/main/java/com/aiplatform/backend/AiPlatformBackendApplication.java`
- Create: `backend/src/main/resources/application.yml`
- Create: `backend/src/test/resources/application-test.yml`
- Create: `backend/src/test/java/com/aiplatform/backend/AiPlatformBackendApplicationTests.java`

- [ ] **Step 1: Write the failing context-load test**

```java
package com.aiplatform.backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class AiPlatformBackendApplicationTests {

    @Test
    void contextLoads() {
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `mvn -f backend/pom.xml test -Dtest=AiPlatformBackendApplicationTests`
Expected: FAIL because the Maven module and application classes do not exist yet.

- [ ] **Step 3: Write the minimal Spring Boot bootstrap code**

Create a `spring-boot-starter-parent` Maven project with:
- `spring-boot-starter-web`
- `mybatis-plus-spring-boot3-starter`
- `spring-boot-starter-validation`
- `spring-boot-starter-test`
- `com.h2database:h2`
- `com.mysql:mysql-connector-j`

Create a minimal `@SpringBootApplication` entrypoint with `@MapperScan`, plus default/test datasource config using H2 and SQL init scripts.

- [ ] **Step 4: Run test to verify it passes**

Run: `mvn -f backend/pom.xml test -Dtest=AiPlatformBackendApplicationTests`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add backend/pom.xml backend/src/main backend/src/test
git commit -m "feat: bootstrap backend module"
```

## Chunk 2: Project CRUD

### Task 2: Implement Project Create/List/Get API

**Files:**
- Create: `backend/src/main/java/com/aiplatform/backend/project/entity/Project.java`
- Create: `backend/src/main/java/com/aiplatform/backend/project/dto/CreateProjectRequest.java`
- Create: `backend/src/main/java/com/aiplatform/backend/project/dto/ProjectResponse.java`
- Create: `backend/src/main/java/com/aiplatform/backend/project/mapper/ProjectMapper.java`
- Create: `backend/src/main/java/com/aiplatform/backend/project/service/ProjectService.java`
- Create: `backend/src/main/java/com/aiplatform/backend/project/controller/ProjectController.java`
- Create: `backend/src/main/java/com/aiplatform/backend/common/exception/ApiExceptionHandler.java`
- Create: `backend/src/test/resources/db/schema-h2.sql`
- Test: `backend/src/test/java/com/aiplatform/backend/project/ProjectControllerTest.java`

- [ ] **Step 1: Write the failing web tests**

```java
@SpringBootTest
@AutoConfigureMockMvc
class ProjectControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldCreateProject() throws Exception {
        mockMvc.perform(post("/api/projects")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "商城系统",
                          "code": "mall",
                          "projectType": "PRODUCT",
                          "branchStrategy": "TRUNK_BASED"
                        }
                        """))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.name").value("商城系统"))
            .andExpect(jsonPath("$.code").value("mall"));
    }

    @Test
    void shouldListProjects() throws Exception {
        mockMvc.perform(get("/api/projects"))
            .andExpect(status().isOk());
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectControllerTest`
Expected: FAIL with missing controller / bean / endpoint errors.

- [ ] **Step 3: Write minimal implementation**

Implement:
- MyBatis-Plus `Project` entity with core fields only
- `ProjectMapper extends BaseMapper<Project>`
- service methods for create/list/get
- controller endpoints:
  - `POST /api/projects`
  - `GET /api/projects`
  - `GET /api/projects/{id}`
- H2 schema initialization for the `projects` table
- validation and a simple exception handler for `404` / validation errors

- [ ] **Step 4: Run test to verify it passes**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectControllerTest`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add backend/src/main/java/com/aiplatform/backend/project backend/src/main/java/com/aiplatform/backend/common backend/src/test/java/com/aiplatform/backend/project
git commit -m "feat: add project management api"
```

## Chunk 3: Service CRUD

### Task 3: Implement Service Create/List API Under Project

**Files:**
- Create: `backend/src/main/java/com/aiplatform/backend/service/entity/ServiceEntity.java`
- Create: `backend/src/main/java/com/aiplatform/backend/service/dto/CreateServiceRequest.java`
- Create: `backend/src/main/java/com/aiplatform/backend/service/dto/ServiceResponse.java`
- Create: `backend/src/main/java/com/aiplatform/backend/service/mapper/ServiceEntityMapper.java`
- Create: `backend/src/main/java/com/aiplatform/backend/service/service/ServiceEntityService.java`
- Create: `backend/src/main/java/com/aiplatform/backend/service/controller/ProjectServiceController.java`
- Test: `backend/src/test/java/com/aiplatform/backend/service/ProjectServiceControllerTest.java`

- [ ] **Step 1: Write the failing endpoint tests**

```java
@SpringBootTest
@AutoConfigureMockMvc
class ProjectServiceControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void shouldCreateServiceUnderProject() throws Exception {
        mockMvc.perform(post("/api/projects/1/services")
                .contentType(MediaType.APPLICATION_JSON)
                .content("""
                        {
                          "name": "mall-backend",
                          "serviceType": "BACKEND",
                          "defaultBranch": "main"
                        }
                        """))
            .andExpect(status().isCreated());
    }
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectServiceControllerTest`
Expected: FAIL with missing entity / repository / endpoint errors.

- [ ] **Step 3: Write minimal implementation**

Implement:
- MyBatis-Plus `ServiceEntity` mapped to `services`
- `ServiceEntityMapper extends BaseMapper<ServiceEntity>`
- project ownership validation
- H2 schema initialization for the `services` table
- controller endpoints:
  - `POST /api/projects/{id}/services`
  - `GET /api/projects/{id}/services`

- [ ] **Step 4: Run test to verify it passes**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectServiceControllerTest`
Expected: PASS

- [ ] **Step 5: Run the focused test suite**

Run: `mvn -f backend/pom.xml test`
Expected: PASS with all backend tests green.

- [ ] **Step 6: Commit**

```bash
git add backend/src/main/java/com/aiplatform/backend/service backend/src/test/java/com/aiplatform/backend/service
git commit -m "feat: add project service api"
```
