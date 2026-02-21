# AGENTS.md - Development Guidelines for preview-typespec

## Project Overview
TypeScript + Hono (Cloudflare Workers) API với TypeSpec definitions. Serves Swagger UI cho OpenAPI spec từ TypeSpec.

## Build & Development Commands

### Package Management
```bash
# Install dependencies (use pnpm for TypeSpec tools)
pnpm install

# Alternative with npm
npm install
```

### TypeSpec Compilation
```bash
# Compile TypeSpec to OpenAPI
pnpm tsp compile ./typespec

# Output location: ./tsp-output/schema/
```

### Development
```bash
# Start development server (Wrangler dev)
pnpm dev
# or
npm run dev

# Access: http://localhost:8787
```

### Deployment
```bash
# Deploy to Cloudflare Workers
pnpm deploy
# or
npm run deploy

# Generate TypeScript types from Cloudflare bindings
pnpm cf-typegen
# or
npm run cf-typegen
```

### Testing (Recommended Setup)
```bash
# Install test framework (recommended)
pnpm add -D vitest @vitest/ui @testing-library/react

# Run tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run single test file
pnpm test src/path/to/test.ts

# Run with coverage
pnpm test:coverage
```

### Linting (Recommended Setup)
```bash
# Install linting tools (recommended)
pnpm add -D eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser

# Run linter
pnpm lint

# Fix linting issues
pnpm lint:fix

# Format with Prettier (recommended)
pnpm add -D prettier
pnpm format
```

## Code Style Guidelines

### TypeScript
- **Module system**: ES Modules (`"type": "module"`)
- **Import style**: Use named imports, keep imports at top
```typescript
import { Hono } from 'hono'
import { swaggerUI } from '@hono/swagger-ui'
```
- **Type safety**: Always use TypeScript strict mode (enabled in tsconfig)
- **Error handling**: Use try/catch for async operations, return appropriate HTTP status codes
- **Variable naming**: `camelCase` for variables/functions, `PascalCase` for types/classes
- **File naming**: `kebab-case.ts` for files, `PascalCase.tsx` for components

### TypeSpec (.tsp files)
- **Model naming**: `PascalCase` (e.g., `Widget`, `Error`)
- **Field naming**: `snake_case` (e.g., `id`, `widget_name`, `created_at`)
- **Namespace**: Use `namespace DemoService;` for service definitions
- **Imports**: Relative imports with `.tsp` extension
```typescript
import "@typespec/http";
import "./models.tsp";
import "../common/errors.tsp";
```
- **Decorators**: Use `@route`, `@get`, `@post`, `@error` decorators
- **Documentation**: Add JSDoc comments for operations
```typescript
/** List widgets */
@get list(): WidgetList | Error;
```

### Cloudflare Workers/Hono
- **App initialization**: 
```typescript
const app = new Hono<{ Bindings: CloudflareBindings }>()
```
- **Route definitions**: Use Hono's route methods with TypeScript types
- **Middleware**: Use Hono middleware pattern
- **Bindings**: Access Cloudflare bindings via `c.env`

### Error Handling Pattern
```typescript
// TypeSpec error model
@error
model Error {
  code: int32;
  message: string;
  details?: string;
}

// Hono error handling
app.onError((err, c) => {
  console.error(err);
  return c.json({ error: err.message }, 500);
});
```

### API Design
- **REST conventions**: Use HTTP methods appropriately (GET, POST, PATCH, DELETE)
- **Resource naming**: Plural nouns for collections (`/widgets`)
- **Nested routes**: For sub-resources (`/widgets/{id}/analyze`)
- **Response types**: Union types for success/error responses (`Widget | Error`)
- **Pagination**: Use `offset`/`limit` or cursor-based pagination
- **Filtering**: Query parameters for filtering (`?color=red&weight_gt=10`)

## Testing Guidelines

### Unit Tests (when implemented)
- **Location**: `tests/` directory mirroring `src/` structure
- **Naming**: `*.test.ts` or `*.spec.ts` suffix
- **Framework**: Vitest (recommended for ES modules)
- **Assertions**: Use Vitest's `expect()` with TypeScript assertions
- **Mocking**: Use `vi.mock()` for external dependencies

### Example Test Structure
```typescript
import { describe, it, expect, beforeEach } from 'vitest'
import { app } from '../src/index'

describe('Widget API', () => {
  it('GET /widgets returns empty list', async () => {
    const res = await app.request('/widgets')
    expect(res.status).toBe(200)
    expect(await res.json()).toEqual({ items: [] })
  })
})
```

### Integration Tests
- Test TypeSpec compilation
- Test OpenAPI spec generation
- Test Swagger UI serving

## Git & Workflow

### Commit Conventions
```
feat: add new feature
fix: bug fix
docs: documentation changes
style: code style changes (formatting, etc.)
refactor: code restructuring
test: adding or updating tests
chore: maintenance tasks
```

### Branch Strategy
- `main`: Production-ready code
- `dev`: Development branch
- `feat/*`: Feature branches
- `fix/*`: Bug fix branches

### Pull Requests
- Include TypeSpec changes with corresponding TypeScript implementation
- Update OpenAPI spec if API changes
- Test locally before creating PR
- Ensure TypeScript compilation passes

## Development Workflow

### 1. Start Development
```bash
pnpm install
pnpm tsp compile ./typespec
pnpm dev
```

### 2. Make Changes
- Edit TypeSpec files in `typespec/src/`
- Edit TypeScript files in `src/`
- TypeSpec changes require recompilation

### 3. Test Changes
```bash
# Compile TypeSpec
pnpm tsp compile ./typespec

# Check TypeScript
npx tsc --noEmit

# Run tests (when implemented)
pnpm test
```

### 4. Deploy
```bash
pnpm deploy
```

## Tool Configuration

### TypeScript Config (`tsconfig.json`)
- Target: `ESNext`
- Module: `ESNext`
- Strict mode: enabled
- JSX: `react-jsx` (for Hono JSX)
- Module resolution: `Bundler`

### TypeSpec Config (`typespec/tspconfig.yaml`)
- Emitter: `@typespec/openapi3`
- Output: `./tsp-output/schema/`
- OpenAPI version: 3.1.0

### Cloudflare Workers (`wrangler.jsonc`)
- Main: `src/index.ts`
- Compatibility date: current date
- Assets: `./tsp-output/schema/` (OpenAPI spec)

## Best Practices

### Code Organization
- Keep TypeSpec definitions in `typespec/src/`
- Keep implementation in `src/`
- Group related models/routes in same namespace
- Use common error models across services

### Performance
- Minimize dependencies in Workers
- Use Cloudflare Workers caching where appropriate
- Optimize TypeScript bundle size

### Security
- Validate all inputs in TypeSpec and TypeScript
- Use Cloudflare Workers security headers
- Implement rate limiting for public APIs
- Sanitize error messages in production

### Documentation
- Keep TypeSpec docs updated
- Swagger UI automatically updates from OpenAPI spec
- Add examples to complex operations
- Document required bindings and environment variables

## Troubleshooting

### Common Issues
1. **TypeSpec compilation fails**: Check import paths and model references
2. **OpenAPI spec not updating**: Ensure `tsp-output/` is regenerated
3. **Swagger UI not showing**: Check if `/openapi.yaml` is served correctly
4. **Type errors**: Run `npx tsc --noEmit` to identify issues
5. **Deployment failures**: Check Cloudflare Workers quotas and permissions

### Debugging
```bash
# Debug TypeSpec compilation
pnpm tsp compile ./typespec --debug

# Debug Wrangler
WRANGLER_LOG=debug pnpm dev

# Check generated OpenAPI
cat tsp-output/schema/openapi.yaml
```

## Agent Notes
- Always compile TypeSpec before testing API changes
- Update both TypeSpec and implementation when changing APIs
- Test Swagger UI after OpenAPI spec changes
- Consider Cloudflare Workers limits (CPU time, memory)
- Use `pnpm` for consistency with TypeSpec tools
- Check `wrangler.jsonc` for bindings configuration