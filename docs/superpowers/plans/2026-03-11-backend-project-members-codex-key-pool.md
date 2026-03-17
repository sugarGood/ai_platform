# Backend Project Members and Codex Key Pool Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add project-scoped member management plus a Codex-only AI key pool and usage summary to the existing Spring Boot backend.

**Architecture:** Extend the current layered backend structure with two new project-scoped resource lines. Keep project existence validation in the service layer via `ProjectMapper`, persist members and AI keys with MyBatis-Plus entities/mappers, and compute usage summary on read from stored quota snapshots rather than external provider integrations.

**Tech Stack:** Java 17, Spring Boot 3, Spring Web, MyBatis-Plus, Bean Validation, H2, Maven, JUnit 5, MockMvc

---

## Chunk 1: Project Members

### Task 1: Add the failing member endpoint tests

**Files:**
- Modify: `backend/src/test/resources/db/schema-h2.sql`
- Create: `backend/src/test/java/com/aiplatform/backend/member/ProjectMemberControllerTest.java`

- [ ] **Step 1: Extend the H2 schema with the project member table**

Add a `project_members` table to `backend/src/test/resources/db/schema-h2.sql` with:

```sql
CREATE TABLE IF NOT EXISTS project_members (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    role VARCHAR(32) NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT uk_project_member_email UNIQUE (project_id, email)
);
```

- [ ] **Step 2: Write the failing member controller tests**

Create `backend/src/test/java/com/aiplatform/backend/member/ProjectMemberControllerTest.java` with tests for:

```java
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Sql(statements = {
        "DELETE FROM project_members",
        "DELETE FROM services",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
class ProjectMemberControllerTest {

    @Test
    void shouldCreateMemberUnderProject() throws Exception { }

    @Test
    void shouldListMembersUnderProject() throws Exception { }

    @Test
    void shouldReturnNotFoundWhenProjectMissing() throws Exception { }

    @Test
    void shouldReturnConflictWhenMemberEmailDuplicated() throws Exception { }

    @Test
    void shouldRejectInvalidRole() throws Exception { }
}
```

Use the same helper pattern as `ProjectServiceControllerTest` to create a project via `POST /api/projects` before each member test.

- [ ] **Step 3: Run the member test class to verify it fails**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectMemberControllerTest`

Expected: FAIL with missing controller, mapper, or endpoint errors because the member resource has not been implemented yet.

- [ ] **Step 4: Commit the red test scaffold**

```bash
git add backend/src/test/resources/db/schema-h2.sql backend/src/test/java/com/aiplatform/backend/member/ProjectMemberControllerTest.java
git commit -m "test: add failing project member api tests"
```

### Task 2: Implement project member persistence and endpoints

**Files:**
- Create: `backend/src/main/java/com/aiplatform/backend/member/entity/ProjectMember.java`
- Create: `backend/src/main/java/com/aiplatform/backend/member/dto/CreateProjectMemberRequest.java`
- Create: `backend/src/main/java/com/aiplatform/backend/member/dto/ProjectMemberResponse.java`
- Create: `backend/src/main/java/com/aiplatform/backend/member/mapper/ProjectMemberMapper.java`
- Create: `backend/src/main/java/com/aiplatform/backend/member/service/ProjectMemberService.java`
- Create: `backend/src/main/java/com/aiplatform/backend/member/controller/ProjectMemberController.java`
- Create: `backend/src/main/java/com/aiplatform/backend/common/exception/ProjectMemberAlreadyExistsException.java`

- [ ] **Step 1: Create the member entity and DTOs**

Add:

```java
@TableName("project_members")
public class ProjectMember {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectId;
    private String name;
    private String email;
    private String role;
    private String status;
}
```

And a request record:

```java
public record CreateProjectMemberRequest(
        @NotBlank String name,
        @NotBlank @Email String email,
        @NotBlank @Pattern(regexp = "OWNER|DEVELOPER") String role
) {
}
```

- [ ] **Step 2: Add the mapper and conflict exception**

Create:

```java
public interface ProjectMemberMapper extends BaseMapper<ProjectMember> {
}
```

And:

```java
@ResponseStatus(HttpStatus.CONFLICT)
public class ProjectMemberAlreadyExistsException extends RuntimeException {
    public ProjectMemberAlreadyExistsException(Long projectId, String email) {
        super("Project member already exists: projectId=%d, email=%s".formatted(projectId, email));
    }
}
```

- [ ] **Step 3: Implement the member service**

Implement `ProjectMemberService` with:

- `create(Long projectId, CreateProjectMemberRequest request)`
- `listByProjectId(Long projectId)`

Behavior:

- verify the project exists using `ProjectMapper`
- query for duplicate email within the same project before insert
- set `status` to `ACTIVE`
- return members ordered by `id`

Suggested duplicate check:

```java
ProjectMember existing = projectMemberMapper.selectOne(
        Wrappers.<ProjectMember>lambdaQuery()
                .eq(ProjectMember::getProjectId, projectId)
                .eq(ProjectMember::getEmail, request.email())
);
if (existing != null) {
    throw new ProjectMemberAlreadyExistsException(projectId, request.email());
}
```

- [ ] **Step 4: Implement the member controller**

Expose:

```java
@RestController
@RequestMapping("/api/projects/{projectId}/members")
public class ProjectMemberController {

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectMemberResponse create(@PathVariable Long projectId,
                                        @Valid @RequestBody CreateProjectMemberRequest request) { }

    @GetMapping
    public List<ProjectMemberResponse> list(@PathVariable Long projectId) { }
}
```

- [ ] **Step 5: Run the member tests to verify green**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectMemberControllerTest`

Expected: PASS with all member endpoint scenarios green.

- [ ] **Step 6: Run the current backend suite**

Run: `mvn -f backend/pom.xml test`

Expected: PASS with the original project/service tests and the new member tests all green.

- [ ] **Step 7: Commit the member implementation**

```bash
git add backend/src/main/java/com/aiplatform/backend/member backend/src/main/java/com/aiplatform/backend/common/exception/ProjectMemberAlreadyExistsException.java backend/src/test/java/com/aiplatform/backend/member/ProjectMemberControllerTest.java backend/src/test/resources/db/schema-h2.sql
git commit -m "feat: add project member api"
```

## Chunk 2: Codex Key Pool and Usage Summary

### Task 3: Add the failing AI key endpoint tests

**Files:**
- Modify: `backend/src/test/resources/db/schema-h2.sql`
- Create: `backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyControllerTest.java`
- Create: `backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyUsageControllerTest.java`

- [ ] **Step 1: Extend the H2 schema with the AI key table**

Add a `project_ai_keys` table to `backend/src/test/resources/db/schema-h2.sql`:

```sql
CREATE TABLE IF NOT EXISTS project_ai_keys (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_id BIGINT NOT NULL,
    name VARCHAR(128) NOT NULL,
    provider VARCHAR(32) NOT NULL,
    secret_key VARCHAR(255) NOT NULL,
    masked_key VARCHAR(255) NOT NULL,
    monthly_quota BIGINT NOT NULL,
    used_quota BIGINT NOT NULL,
    alert_threshold_percent INT NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT uk_project_ai_key_name UNIQUE (project_id, name)
);
```

- [ ] **Step 2: Write the failing AI key controller tests**

Create `backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyControllerTest.java` with tests for:

- creating a Codex key under a project
- listing project keys
- verifying `maskedKey` is present
- verifying `secretKey` is absent from responses
- `404` when the project is missing
- `409` when a key name is reused within a project
- `400` when `provider` is not `CODEX`
- `400` when `usedQuota > monthlyQuota`

Use cleanup:

```java
@Sql(statements = {
        "DELETE FROM project_ai_keys",
        "DELETE FROM project_members",
        "DELETE FROM services",
        "DELETE FROM projects"
}, executionPhase = ExecutionPhase.BEFORE_TEST_METHOD)
```

- [ ] **Step 3: Write the failing usage summary tests**

Create `backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyUsageControllerTest.java` with tests for:

- quota aggregation across multiple keys
- active versus disabled counts
- alerting versus exhausted counts
- missing-project `404`
- zero summary for a project with no keys

- [ ] **Step 4: Run the AI key tests to verify red**

Run:

- `mvn -f backend/pom.xml test -Dtest=ProjectAiKeyControllerTest`
- `mvn -f backend/pom.xml test -Dtest=ProjectAiKeyUsageControllerTest`

Expected: both FAIL because the AI key resources do not exist yet.

- [ ] **Step 5: Commit the red AI key test scaffold**

```bash
git add backend/src/test/resources/db/schema-h2.sql backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyControllerTest.java backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyUsageControllerTest.java
git commit -m "test: add failing codex key pool api tests"
```

### Task 4: Implement project AI key create and list endpoints

**Files:**
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/entity/ProjectAiKey.java`
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/dto/CreateProjectAiKeyRequest.java`
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/dto/ProjectAiKeyResponse.java`
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/mapper/ProjectAiKeyMapper.java`
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/service/ProjectAiKeyService.java`
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/controller/ProjectAiKeyController.java`
- Create: `backend/src/main/java/com/aiplatform/backend/common/exception/ProjectAiKeyAlreadyExistsException.java`
- Create: `backend/src/main/java/com/aiplatform/backend/common/exception/InvalidAiKeyQuotaException.java`

- [ ] **Step 1: Create the AI key entity and request/response DTOs**

Entity:

```java
@TableName("project_ai_keys")
public class ProjectAiKey {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long projectId;
    private String name;
    private String provider;
    private String secretKey;
    private String maskedKey;
    private Long monthlyQuota;
    private Long usedQuota;
    private Integer alertThresholdPercent;
    private String status;
}
```

Request:

```java
public record CreateProjectAiKeyRequest(
        @NotBlank String name,
        @NotBlank @Pattern(regexp = "CODEX") String provider,
        @NotBlank String secretKey,
        @NotNull @Min(1) Long monthlyQuota,
        @NotNull @Min(0) Long usedQuota,
        @NotNull @Min(1) @Max(100) Integer alertThresholdPercent
) {
}
```

- [ ] **Step 2: Add the conflict and bad-request exceptions**

Create:

```java
@ResponseStatus(HttpStatus.CONFLICT)
public class ProjectAiKeyAlreadyExistsException extends RuntimeException { }
```

And:

```java
@ResponseStatus(HttpStatus.BAD_REQUEST)
public class InvalidAiKeyQuotaException extends RuntimeException { }
```

- [ ] **Step 3: Implement masking and validation in the AI key service**

`ProjectAiKeyService#create(Long projectId, CreateProjectAiKeyRequest request)` should:

- verify the project exists
- reject duplicate key names within the project
- reject payloads where `usedQuota > monthlyQuota`
- derive `maskedKey`
- persist the key with default `status = "ACTIVE"`

Suggested masking helper:

```java
private String maskSecretKey(String secretKey) {
    if (secretKey.length() <= 6) {
        return "****";
    }
    return secretKey.substring(0, 3) + "****" + secretKey.substring(secretKey.length() - 4);
}
```

Add `listByProjectId(Long projectId)` ordered by `id`.

- [ ] **Step 4: Implement the AI key controller**

Expose:

```java
@RestController
@RequestMapping("/api/projects/{projectId}/ai-keys")
public class ProjectAiKeyController {

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectAiKeyResponse create(@PathVariable Long projectId,
                                       @Valid @RequestBody CreateProjectAiKeyRequest request) { }

    @GetMapping
    public List<ProjectAiKeyResponse> list(@PathVariable Long projectId) { }
}
```

- [ ] **Step 5: Run the AI key controller tests to verify green**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectAiKeyControllerTest`

Expected: PASS with create/list/conflict/not-found/validation behavior working.

- [ ] **Step 6: Commit the AI key endpoint implementation**

```bash
git add backend/src/main/java/com/aiplatform/backend/aikey backend/src/main/java/com/aiplatform/backend/common/exception/ProjectAiKeyAlreadyExistsException.java backend/src/main/java/com/aiplatform/backend/common/exception/InvalidAiKeyQuotaException.java backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyControllerTest.java backend/src/test/resources/db/schema-h2.sql
git commit -m "feat: add codex key pool api"
```

### Task 5: Implement the usage summary endpoint

**Files:**
- Modify: `backend/src/main/java/com/aiplatform/backend/aikey/service/ProjectAiKeyService.java`
- Modify: `backend/src/main/java/com/aiplatform/backend/aikey/controller/ProjectAiKeyController.java`
- Create: `backend/src/main/java/com/aiplatform/backend/aikey/dto/ProjectAiKeyUsageResponse.java`
- Modify: `backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyUsageControllerTest.java`

- [ ] **Step 1: Add the usage response DTO**

Create:

```java
public record ProjectAiKeyUsageResponse(
        Long projectId,
        String provider,
        Long totalMonthlyQuota,
        Long totalUsedQuota,
        Long remainingQuota,
        Integer usageRatePercent,
        Integer activeKeyCount,
        Integer disabledKeyCount,
        Integer alertingKeyCount,
        Integer exhaustedKeyCount
) {
}
```

- [ ] **Step 2: Implement the usage aggregation method**

Add `usageSummary(Long projectId)` in `ProjectAiKeyService`:

- verify the project exists
- load the project's keys
- aggregate quotas and counts
- return zero values when the key list is empty

Suggested aggregation rules:

```java
long totalMonthlyQuota = keys.stream().mapToLong(ProjectAiKey::getMonthlyQuota).sum();
long totalUsedQuota = keys.stream().mapToLong(ProjectAiKey::getUsedQuota).sum();
long remainingQuota = Math.max(totalMonthlyQuota - totalUsedQuota, 0L);
int usageRatePercent = totalMonthlyQuota == 0 ? 0 : (int) ((totalUsedQuota * 100) / totalMonthlyQuota);
```

Alert rules:

- exhausted if `usedQuota >= monthlyQuota`
- alerting if not exhausted and `usedQuota * 100 >= monthlyQuota * alertThresholdPercent`

- [ ] **Step 3: Expose the usage route**

Add to `ProjectAiKeyController`:

```java
@GetMapping("/usage")
public ProjectAiKeyUsageResponse usage(@PathVariable Long projectId) {
    return projectAiKeyService.usageSummary(projectId);
}
```

- [ ] **Step 4: Run the usage tests to verify green**

Run: `mvn -f backend/pom.xml test -Dtest=ProjectAiKeyUsageControllerTest`

Expected: PASS with correct aggregation and zero-summary behavior.

- [ ] **Step 5: Run the full backend suite**

Run: `mvn -f backend/pom.xml test`

Expected: PASS with all project, service, member, AI key, and usage tests green.

- [ ] **Step 6: Commit the usage summary implementation**

```bash
git add backend/src/main/java/com/aiplatform/backend/aikey backend/src/test/java/com/aiplatform/backend/aikey/ProjectAiKeyUsageControllerTest.java
git commit -m "feat: add codex key usage summary api"
```

## Chunk 3: Completion Check

### Task 6: Final verification and cleanup

**Files:**
- Modify: `backend/src/test/resources/db/schema-h2.sql`
- Review: `backend/src/main/java/com/aiplatform/backend/member/...`
- Review: `backend/src/main/java/com/aiplatform/backend/aikey/...`
- Review: `backend/src/test/java/com/aiplatform/backend/member/...`
- Review: `backend/src/test/java/com/aiplatform/backend/aikey/...`

- [ ] **Step 1: Verify only intended API surface was added**

Confirm the backend exposes only:

- `POST /api/projects/{projectId}/members`
- `GET /api/projects/{projectId}/members`
- `POST /api/projects/{projectId}/ai-keys`
- `GET /api/projects/{projectId}/ai-keys`
- `GET /api/projects/{projectId}/ai-keys/usage`

And confirm no update/delete/detail-secret endpoints were added.

- [ ] **Step 2: Verify secret exposure boundaries**

Review the AI key response DTOs and tests to ensure:

- `secretKey` is accepted on create only
- `secretKey` is not serialized in any response
- `maskedKey` appears in create and list responses

- [ ] **Step 3: Re-run focused suites for confidence**

Run:

- `mvn -f backend/pom.xml test -Dtest=ProjectMemberControllerTest,ProjectAiKeyControllerTest,ProjectAiKeyUsageControllerTest`
- `mvn -f backend/pom.xml test`

Expected: PASS for both commands.

- [ ] **Step 4: Prepare branch for review**

Run:

```bash
git status --short
git log --oneline -5
```

Expected:

- only intended source and test files are modified
- the branch history clearly shows the member and Codex key pool work

- [ ] **Step 5: Request code review**

Use the `requesting-code-review` skill after implementation is complete and verified.

---

Plan complete and saved to `docs/superpowers/plans/2026-03-11-backend-project-members-codex-key-pool.md`. Ready to execute?
