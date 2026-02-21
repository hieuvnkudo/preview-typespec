# AGENTS.md - Development Guidelines

## Project Overview
TypeSpec-first API design with OpenAPI generation. TypeSpec defines the API contract, Hono/Cloudflare Workers serves Swagger UI.

## Commands

### TypeSpec (Primary)
```bash
# Compile TypeSpec to OpenAPI (REQUIRED before testing)
pnpm tsp compile ./typespec

# Output: ./tsp-output/schema/openapi.yaml
```

### Development
```bash
pnpm install
pnpm tsp compile ./typespec
pnpm dev          # Wrangler dev server at localhost:8787
pnpm deploy       # Deploy to Cloudflare Workers
pnpm cf-typegen   # Generate Cloudflare types
```

### Testing (To Install)
```bash
pnpm add -D vitest @vitest/ui
pnpm test                    # Run all tests
pnpm test src/path/test.ts   # Run single test
```

### Linting (To Install)
```bash
pnpm add -D eslint @typescript-eslint/* prettier
pnpm lint && pnpm lint:fix && pnpm format
```

## TypeSpec Guidelines

### File Organization
```
typespec/
├── main.tsp           # Entry point, imports all modules
├── tspconfig.yaml     # Emitter config (openapi3)
├── common/
│   └── models.tsp     # Shared models (Error, etc.)
└── [feature]/
    ├── models.tsp     # Domain models
    └── routes.tsp     # API routes
```

### Naming Conventions
- **Models**: `PascalCase` (e.g., `Pet`, `UserResponse`)
- **Fields**: `snake_case` (e.g., `created_at`, `user_name`)
- **Namespaces**: Service-level grouping
  ```typespec
  namespace PetStore;
  ```

### Imports
```typespec
import "@typespec/http";
import "./models.tsp";
import "../common/models.tsp";
```

### Patterns
```typespec
// Error model
@error
model Error {
  code: int32;
  message: string;
  details?: string;
}

// Route with docs
/** Get all pets */
@get
@route("/pets")
op list(@query offset?: int32, @query limit?: int32): PetList | Error;

// Resource routes
@route("/pets/{id}")
interface PetRoutes {
  @get get(@path id: string): Pet | Error;
  @post update(@path id: string, @body pet: PetUpdate): Pet | Error;
  @delete delete(@path id: string): void | Error;
}
```

### API Design
- Use plural nouns: `/pets`, `/users`
- Union types for responses: `Pet | Error`
- Query params for filtering/pagination
- Proper HTTP methods: GET, POST, PATCH, DELETE

## TypeScript (Hono)

### Minimal Implementation
```typescript
import { Hono } from 'hono'
import { swaggerUI } from '@hono/swagger-ui'

const app = new Hono()
app.get('/', swaggerUI({ url: '/openapi.yaml' }))
export default app
```

### Style
- ES Modules, strict mode
- `camelCase` variables, `PascalCase` types
- `kebab-case.ts` filenames

## Workflow

1. **Design API**: Edit `.tsp` files
2. **Compile**: `pnpm tsp compile ./typespec`
3. **Verify**: Check `tsp-output/schema/openapi.yaml`
4. **Test**: `pnpm dev` → http://localhost:8787
5. **Deploy**: `pnpm deploy`

## Git Conventions
```
feat: add pet search endpoint
fix: correct user model validation
docs: update API examples
```

## Troubleshooting

| Issue | Fix |
|-------|-----|
| TypeSpec fails | Check import paths end with `.tsp` |
| OpenAPI not updating | Delete `tsp-output/` and recompile |
| Swagger UI blank | Verify `/openapi.yaml` endpoint works |
| Type errors | Run `npx tsc --noEmit` |

## Agent Notes
- **Always compile TypeSpec first** before testing
- TypeSpec is the source of truth - Hono just serves the UI
- Check `wrangler.jsonc` for Cloudflare bindings
