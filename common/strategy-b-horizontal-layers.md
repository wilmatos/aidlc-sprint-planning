# Strategy B: Horizontal Layers

**Use when:** Separate frontend/backend teams, parallel work, contract-first integration.

**Decompose:** Add a CONTRACT unit first (API shape, schemas, error codes, auth model). Backend implements contract. Frontend mocks contract, replaces mocks at integration. Integration unit closes streams.

**Contract unit contains:** API schema, request/response examples, error shapes, auth flow, pagination conventions, versioning strategy.

**Example:**
```
01-foundation        (shared infra, auth)
02-api-contract      (OpenAPI spec, shared types, error model)
03-backend-core      (implements contract endpoints)
04-frontend-core     (mocks contract, builds UI)
05-integration       (replace mocks with real API, E2E tests)
```
