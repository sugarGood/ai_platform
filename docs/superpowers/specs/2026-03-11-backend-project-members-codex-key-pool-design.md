# Backend Project Members and Codex Key Pool Design

## Background

The backend already provides the first runnable project management slice:

- `POST /api/projects`
- `GET /api/projects`
- `POST /api/projects/{projectId}/services`
- `GET /api/projects/{projectId}/services`

The implementation uses Spring Boot, MyBatis-Plus, H2-backed tests, and a simple layered package structure:

- controller
- dto
- entity
- mapper
- service

The next business line is project members plus AI key pool and quota monitoring. To stay aligned with the current backend maturity, this design keeps the scope to a single-provider, project-scoped slice that is independently testable and does not require external provider integration.

## Goal

Build the next minimal runnable backend slice so a project can:

1. Manage its member roster
2. Manage a Codex-only AI key pool
3. Query a project-level quota usage summary derived from stored key quota snapshots

The result should extend the existing backend style without introducing real provider SDK calls, scheduler jobs, unified error payloads, or full key-management security infrastructure.

## Scope

### In Scope

- Project-scoped member create and list APIs
- Project-scoped AI key create and list APIs
- Project-scoped Codex quota usage summary API
- Project existence validation for all new routes
- Duplicate-resource detection for members and AI keys
- Bean Validation for request payloads
- H2 schema and Spring Boot integration tests for the new endpoints

### Out of Scope

- Member update and delete APIs
- AI key update, delete, rotate, or reveal APIs
- Real Codex usage pulling or provider SDK integration
- Scheduled quota refresh jobs
- Encryption, KMS integration, or secret vaulting
- Authentication and authorization
- Unified error response envelope
- Multi-provider AI key abstraction beyond allowing a `provider` field constrained to `CODEX`

## Product Decisions

### Why Codex Only First

The broader product direction includes multi-model key governance, but the backend is still in a narrow bootstrap phase. Supporting only `CODEX` in the first slice keeps the model grounded in a real business object without prematurely introducing provider abstractions, fallback policies, or external synchronization concerns.

### Why Usage Is a Snapshot Instead of Real Monitoring

The first version treats key usage as stored quota data:

- `monthlyQuota`
- `usedQuota`
- `alertThresholdPercent`
- `status`

This provides a stable data contract for later monitoring work while avoiding the complexity of external polling, retries, credentials management, and provider-specific usage semantics.

## Architecture

The design follows the same structure as the existing project and service modules.

### New Resource Lines

- `POST /api/projects/{projectId}/members`
- `GET /api/projects/{projectId}/members`
- `POST /api/projects/{projectId}/ai-keys`
- `GET /api/projects/{projectId}/ai-keys`
- `GET /api/projects/{projectId}/ai-keys/usage`

### Package Structure

Add two new backend areas:

- `backend/src/main/java/com/aiplatform/backend/member/...`
- `backend/src/main/java/com/aiplatform/backend/aikey/...`

Each area will contain:

- controller
- dto
- entity
- mapper
- service

Project existence checks should continue to use `ProjectMapper` directly from the service layer, matching the current `ServiceEntityService` pattern.

The usage summary logic should live in the AI key service layer as a simple aggregation over the project's stored keys. A separate reporting or analytics layer is unnecessary for this slice.

## Data Model

### Project Members

Create a `project_members` table to represent the project roster in the absence of a global user system.

Suggested fields:

- `id`
- `project_id`
- `name`
- `email`
- `role`
- `status`

Suggested constraints:

- `role` supports `OWNER|DEVELOPER`
- `status` defaults to `ACTIVE`
- `project_id + email` is unique within a project

This table deliberately acts as a project-local member directory. When a real user or SSO system exists later, the table can evolve to store user references instead of remaining a standalone identity source.

### Project AI Keys

Create a `project_ai_keys` table to represent Codex credentials and their quota snapshots.

Suggested fields:

- `id`
- `project_id`
- `name`
- `provider`
- `secret_key`
- `masked_key`
- `monthly_quota`
- `used_quota`
- `alert_threshold_percent`
- `status`

Suggested constraints:

- `provider` supports `CODEX` only in this phase
- `status` supports `ACTIVE|DISABLED`
- `project_id + name` is unique within a project
- `monthly_quota >= 1`
- `used_quota >= 0`
- `alert_threshold_percent` is between `1` and `100`

The design intentionally stores a derived `masked_key` alongside `secret_key` so list responses never need to recompute or expose the secret input.

### Computed Monitoring State

Monitoring state is not stored as an explicit column. Instead:

- a key is `exhausted` when `usedQuota >= monthlyQuota`
- a key is `alerting` when `usedQuota / monthlyQuota` meets or exceeds `alertThresholdPercent`

This keeps the model simple and lets future synchronization update a single source of truth: `used_quota`.

## API Design

### Create Project Member

`POST /api/projects/{projectId}/members`

Request:

```json
{
  "name": "Alice",
  "email": "alice@example.com",
  "role": "OWNER"
}
```

Response:

```json
{
  "id": 1,
  "projectId": 100,
  "name": "Alice",
  "email": "alice@example.com",
  "role": "OWNER",
  "status": "ACTIVE"
}
```

### List Project Members

`GET /api/projects/{projectId}/members`

Response:

```json
[
  {
    "id": 1,
    "projectId": 100,
    "name": "Alice",
    "email": "alice@example.com",
    "role": "OWNER",
    "status": "ACTIVE"
  }
]
```

### Create Project AI Key

`POST /api/projects/{projectId}/ai-keys`

Request:

```json
{
  "name": "codex-main",
  "provider": "CODEX",
  "secretKey": "sk-example-secret",
  "monthlyQuota": 1000000,
  "usedQuota": 120000,
  "alertThresholdPercent": 80
}
```

Response:

```json
{
  "id": 1,
  "projectId": 100,
  "name": "codex-main",
  "provider": "CODEX",
  "maskedKey": "sk-****cret",
  "monthlyQuota": 1000000,
  "usedQuota": 120000,
  "alertThresholdPercent": 80,
  "status": "ACTIVE"
}
```

### List Project AI Keys

`GET /api/projects/{projectId}/ai-keys`

Response:

```json
[
  {
    "id": 1,
    "projectId": 100,
    "name": "codex-main",
    "provider": "CODEX",
    "maskedKey": "sk-****cret",
    "monthlyQuota": 1000000,
    "usedQuota": 120000,
    "alertThresholdPercent": 80,
    "status": "ACTIVE"
  }
]
```

The raw `secretKey` must never appear in any response.

### Project AI Key Usage Summary

`GET /api/projects/{projectId}/ai-keys/usage`

Response:

```json
{
  "projectId": 100,
  "provider": "CODEX",
  "totalMonthlyQuota": 3000000,
  "totalUsedQuota": 900000,
  "remainingQuota": 2100000,
  "usageRatePercent": 30,
  "activeKeyCount": 2,
  "disabledKeyCount": 1,
  "alertingKeyCount": 1,
  "exhaustedKeyCount": 0
}
```

If a project has no AI keys yet, this endpoint should still return a valid zeroed summary instead of an error.

## Validation Rules

### Members

- `name` must be non-blank
- `email` must be non-blank and email-shaped
- `role` must match `OWNER|DEVELOPER`

### AI Keys

- `name` must be non-blank
- `provider` must match `CODEX`
- `secretKey` must be non-blank
- `monthlyQuota` must be at least `1`
- `usedQuota` must be at least `0`
- `alertThresholdPercent` must be between `1` and `100`
- `usedQuota` must not exceed `monthlyQuota`

The last rule is cross-field business validation and belongs in the service layer instead of Bean Validation annotations alone.

## Error Handling

The first version should add only the minimum new behavior needed for correctness.

### Existing Behavior to Reuse

- `ProjectNotFoundException` remains the `404` path for missing projects

### New Conflict Cases

Add:

- `ProjectMemberAlreadyExistsException`
- `ProjectAiKeyAlreadyExistsException`

Expected status codes:

- duplicate member email within the same project: `409`
- duplicate AI key name within the same project: `409`

### Invalid Request Cases

Continue using Spring validation behavior for malformed payloads and unsupported enum-like values:

- blank fields
- invalid role
- invalid provider
- negative or inconsistent quota values

These should return `400`.

## Security Boundary

This slice is explicitly not a full secret-management implementation.

### Temporary Storage Policy

- persist `secret_key` in the database
- never return `secret_key` in any response
- always return `masked_key` instead
- do not provide a detail endpoint that reveals the raw secret
- do not provide update or rotate operations yet

This is a deliberate bootstrap compromise. A later phase can replace the storage implementation with encryption or external secret management without changing the list and usage APIs.

## Testing Strategy

Follow the same integration-test style already used by `ProjectControllerTest` and `ProjectServiceControllerTest`:

- `@SpringBootTest`
- `@AutoConfigureMockMvc`
- `@ActiveProfiles("test")`
- H2 schema initialization from `schema-h2.sql`
- cleanup with `@Sql`
- create projects dynamically through the existing project API

### Member Tests

Create `ProjectMemberControllerTest` to cover:

- creating a member under an existing project
- listing members under a project
- `404` when the project does not exist
- `409` when the same email is added twice to the same project
- `400` for invalid role or blank input

### AI Key Tests

Create `ProjectAiKeyControllerTest` to cover:

- creating a Codex key under an existing project
- listing keys under a project
- verifying responses expose `maskedKey` but not `secretKey`
- `404` when the project does not exist
- `409` when the same key name is added twice to the same project
- `400` for unsupported provider or invalid quota payloads

### Usage Summary Tests

Create `ProjectAiKeyUsageControllerTest` to cover:

- aggregation of total monthly quota
- aggregation of total used quota
- remaining quota calculation
- counts for active and disabled keys
- counts for alerting and exhausted keys
- `404` when the project does not exist
- zero summary when a project has no keys

## Implementation Slices

The work should be implemented in two independent chunks.

### Chunk 1: Project Members

- schema changes for `project_members`
- member entity, dto, mapper, service, controller
- duplicate-member conflict handling
- member endpoint tests

### Chunk 2: Codex Key Pool and Usage Summary

- schema changes for `project_ai_keys`
- AI key entity, dto, mapper, service, controller
- key masking behavior
- usage summary aggregation
- AI key and usage endpoint tests

This keeps each chunk independently runnable and aligned with the incremental backend cadence already established in the repository.

## Acceptance Criteria

The design is successful when:

- project members can be created and listed through project-scoped APIs
- Codex AI keys can be created and listed through project-scoped APIs
- raw secrets are not exposed in responses
- a usage summary endpoint returns stable project-level quota metrics
- missing projects return `404`
- duplicate members and keys return `409`
- invalid payloads return `400`
- all backend tests pass against the H2 test profile

## Spec Review

**Status:** Approved after collaborative review

**Notes:**

- Scope is intentionally limited to a single-provider backend slice.
- Monitoring is modeled as quota aggregation over stored snapshots, not live provider integration.
- Security treatment of stored secrets is temporary by design and should be revisited in a later phase.
