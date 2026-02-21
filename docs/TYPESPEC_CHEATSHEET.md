# TypeSpec Cheatsheet - Tài liệu tham khảo đầy đủ

> TypeSpec là ngôn ngữ định nghĩa API cho cloud services, tạo OpenAPI, code và documentation từ một source duy nhất.

---

## 📁 Cấu trúc Project

```
project/
├── typespec/
│   ├── main.tsp              # Entry point - import tất cả modules
│   ├── tspconfig.yaml        # Emitter configuration
│   ├── common/
│   │   └── models.tsp        # Models dùng chung (Error, etc.)
│   ├── feature1/
│   │   ├── models.tsp        # Domain models
│   │   └── routes.tsp        # API routes
│   └── feature2/
│       ├── models.tsp
│       └── routes.tsp
└── package.json
```

---

## 🔧 Cấu hình cơ bản

### tspconfig.yaml
```yaml
emit:
  - "@typespec/openapi3"
options:
  "@typespec/openapi3":
    emitter-output-dir: tsp-output
    output-file: openapi.yaml
```

### main.tsp - Entry Point
```typespec
import "@typespec/http";

// Import tất cả modules
import "./common/models.tsp";
import "./feature/models.tsp";
import "./feature/routes.tsp";

using TypeSpec.Http;

// Service definition
@service(#{
  title: "My API",
  version: "1.0.0"
})
@server("https://api.example.com", "Production")
@server("https://staging.example.com", "Staging")
namespace MyApi;
```

---

## 📦 Imports và Namespaces

### Imports
```typespec
// Import library
import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";

// Import file cục bộ
import "./models.tsp";
import "../common/models.tsp";
```

### Using Statements
```typespec
using TypeSpec.Http;
using TypeSpec.Rest;
```

### Namespaces
```typespec
namespace PetStore;                    // Simple
namespace Org.Services.PetStore;       // Nested
```

### Declarations Uniqueness
```typespec
// Tên declaration phải unique trong cùng scope
model Dog {}
// namespace Dog {}  // ❌ Error: trùng tên Dog
```

---

## 🏗️ Models

### Model cơ bản
```typespec
model Pet {
  id: int64;
  name: string;
  age: int32;
}
```

### Model với Optional Fields
```typespec
model Pet {
  id: int64;           // Required
  name: string;        // Required
  tags?: string[];     // Optional (dùng ?)
}
```

### Model với Default Values
```typespec
model Pet {
  name: string;
  status: PetStatus = PetStatus.available;  // Default value
  pageSize: int32 = 20;
}
```

### Model Inheritance (extends)
```typespec
model Animal {
  species: string;
}

model Pet extends Animal {
  name: string;
}

model Dog extends Pet {
  breed: string;
}
```

### Spread Operator (Composition)
```typespec
model Address {
  street: string;
  city: string;
}

model User {
  name: string;
  ...Address;           // Copy all Address properties
  email: string;
}
// Result: User có street, city, name, email
```

### Nested Models
```typespec
model Tag {
  id: int64;
  name: string;
}

model Pet {
  id: int64;
  name: string;
  tags: Tag[];          // Array of Tag
  primaryTag: Tag;      // Single nested model
}
```

### Intersections
```typespec
// Kết hợp 2 model thành 1 type mới
model Pet { name: string; }
model Animal { species: string; }

// Intersection - có cả properties từ Pet và Animal
alias PetAnimal = Pet & Animal;  // { name: string; species: string; }
```

---

## 📊 Types cơ bản (Scalars)

### Numeric Types
```typespec
model Example {
  // Integers
  a: int8;       // 8-bit signed
  b: int16;      // 16-bit signed
  c: int32;      // 32-bit signed
  d: int64;      // 64-bit signed
  e: uint8;      // 8-bit unsigned
  f: uint16;     // 16-bit unsigned
  g: uint32;     // 32-bit unsigned
  h: uint64;     // 64-bit unsigned
  
  // Floats
  i: float32;     // 32-bit float
  j: float64;     // 64-bit float
  k: decimal;     // Decimal (128-bit)
  
  // Safe integer
  l: safeint;     // Safe integer for JS
}
```

### String & Binary
```typespec
model Example {
  a: string;       // UTF-8 string
  b: bytes;        // Binary data
  c: url;          // URL string
}
```

### Boolean & Null
```typespec
model Example {
  a: boolean;      // true/false
  b: null;         // Null type
}
```

### Date & Time
```typespec
model Example {
  a: plainDate;         // Date only (YYYY-MM-DD)
  b: plainTime;         // Time only (HH:MM:SS)
  c: utcDateTime;        // UTC datetime
  d: offsetDateTime;     // Datetime with timezone offset
  e: duration;          // Duration/interval
}
```

### Custom Scalars
```typespec
// Define custom scalar
scalar uuid extends string;

// With format decorator
scalar email extends string;

// Scalar với template parameter
@doc(T) scalar Password<T extends string>

// Usage
model User {
  id: uuid;
  email: email;
}
```

---

## 🔀 Unions

### Union cơ bản
```typespec
union Pet {
  cat: Cat,
  dog: Dog,
  bird: Bird
}

// Usage
model Person {
  pet: Pet;
}
```

### Union với Primitives
```typespec
union StatusCode {
  int32,
  string
}
```

### Union cho Response Types
```typespec
alias PetResponse = Pet | NotFoundError | ValidationError;

### Inline Union
```typespec
// Union inline với primitive
alias Status = "active" | "inactive" | "pending";

// Function return
op getStatus(): "success" | "error";
```

---

## 📋 Enums

### Enum cơ bản
```typespec
enum Status {
  active,
  inactive,
  pending
}
```

### Enum với giá trị tùy chỉnh
```typespec
enum Status {
  active: "ACTIVE",
  inactive: "INACTIVE",
  pending: "PENDING"
}
```

### Enum với số
```typespec
enum HttpStatus {
  ok: 200,
  notFound: 404,
  error: 500
}

// Enum với float
enum Part {
  quarter: 0.25,
  half: 0.5,
  full: 1.0
}

### Enum Spread
```typespec
// Kế thừa members từ enum khác
enum Direction { Up, Down }

enum Direction2D { 
  ...Direction,     // Copy Up, Down
  Left, 
  Right 
}
```

---

## 📎 Aliases

```typespec
// Type alias
alias PetList = Pet[];

// Complex alias
alias PetResponse = Pet | Error;

// Generic alias
alias Paged<T> = {
  data: T[];
  total: int64;
  page: int32;
  pageSize: int32;
};
```

---

## 🎯 Arrays và Collections

```typespec
model Example {
  // Array syntax
  tags: string[];
  pets: Pet[];
  
  // Array of arrays
  matrix: int32[][];
  
  // Generic Array type
  items: Array<string>;
  
  // Record (key-value map)
  metadata: Record<string>;
}
```

---

## 🔧 Operations

### Operation cơ bản
```typespec
op getPet(id: int64): Pet;
```

### Operation với nhiều parameters
```typespec
op createPet(
  name: string,
  age: int32,
  tags?: string[]
): Pet;
```

### Operation với Union return
```typespec
op getPet(id: int64): Pet | NotFoundError;
```

### Void return
```typespec
op deletePet(id: int64): void;
```

### Named return type
```typespec
op createPet(pet: Pet): {
  @statusCode statusCode: 201;
  @body createdPet: Pet;
};
```

---

## 🛣️ Routes và HTTP

### @route Decorator
```typespec
// Route trên namespace
@route("/pets")
namespace Pets {
  op list(): Pet[];
}

// Route trên interface
@route("/pets")
interface PetRoutes {
  op get(id: int64): Pet;
}

// Route trên operation
@route("/pets/{id}")
op getPet(@path id: int64): Pet;
```

### HTTP Methods
```typespec
@route("/pets")
interface Pets {
  @get list(): Pet[];           // GET /pets
  @post create(@body pet: Pet): Pet;  // POST /pets
  @put update(@path id: int64, @body pet: Pet): Pet;  // PUT /pets/{id}
  @patch patch(@path id: int64, @body pet: PetUpdate): Pet;  // PATCH /pets/{id}
  @delete delete(@path id: int64): void;  // DELETE /pets/{id}
  @head check(): void;          // HEAD /pets
}
```

### Nested Routes
```typespec
@route("/pets/{petId}/toys")
interface PetToys {
  @get list(@path petId: int64): Toy[];
  @post create(@path petId: int64, @body toy: Toy): Toy;
}
```

---

## 🎨 Parameter Decorators

### Path Parameters
```typespec
@route("/pets/{id}")
op getPet(
  @path id: int64
): Pet;
```

### Query Parameters
```typespec
op listPets(
  @query page?: int32 = 1,
  @query pageSize?: int32 = 20,
  @query status?: PetStatus
): Pet[];
```

### Header Parameters
```typespec
op createPet(
  @body pet: Pet,
  @header("X-API-Key") apiKey: string,
  @header ifMatch?: string
): Pet;

// Response headers
op getPet(@path id: int64): {
  @header eTag: string;
  @body pet: Pet;
};
```

### Body Parameter
```typespec
op createPet(
  @body pet: Pet
): Pet;

// Body với tên field cụ thể
op createPet(
  @body pet: { name: string; data: Pet }
): Pet;
```

### Status Code
```typespec
op createPet(@body pet: Pet): {
  @statusCode _: 201;
  @body created: Pet;
} | {
  @statusCode _: 400;
  @body error: ValidationError;
};
```

---

## 🔖 Interfaces

### Interface cơ bản
```typespec
@route("/pets")
@tag("Pets")
interface Pets {
  @get list(): Pet[];
  @post create(@body pet: Pet): Pet;
  @get get(@path id: int64): Pet;
  @put update(@path id: int64, @body pet: Pet): Pet;
  @delete delete(@path id: int64): void;
}
```

### Generic Interface (Template)
```typespec
interface Crud<T> {
  @get list(): T[];
  @post create(@body item: T): T;
  @get get(@path id: string): T;
  @put update(@path id: string, @body item: T): T;
  @delete delete(@path id: string): void;
}

// Sử dụng
@route("/pets")
interface Pets extends Crud<Pet> {}
```

---

## 📝 Documentation Decorators

### @doc - Mô tả
```typespec
@doc("Represents a pet in the pet store")
model Pet {
  @doc("Unique identifier for the pet")
  id: int64;
  
  @doc("Name of the pet")
  name: string;
}

/** 
 * Get a pet by ID
 * @param id The pet ID
 * @returns The pet or 404 error
 */
@get
@route("/pets/{id}")
op getPet(@path id: int64): Pet | NotFoundError;
```

### @summary - Tóm tắt ngắn
```typespec
@summary("List all pets")
@get
op listPets(): Pet[];
```

### @tag - Nhóm operations
```typespec
@tag("Pets")
@route("/pets")
interface Pets {
  @get list(): Pet[];
}

// Hoặc trên operation
@tag("Admin")
@delete
@route("/admin/pets/{id}")
op adminDelete(@path id: int64): void;
```

---

## ✅ Validation Decorators

### String Validation
```typespec
model Pet {
  @minLength(1)
  @maxLength(100)
  name: string;
  
  @pattern("^[a-zA-Z0-9]+$")
  code: string;
  
  @format("email")
  email: string;
  
  @format("uuid")
  id: string;
}
```

### Numeric Validation
```typespec
model Pet {
  @minValue(0)
  @maxValue(100)
  age: int32;
  
  @minValue(0)
  @maxValue(999999.99)
  price: decimal;
  
  @minValueExclusive(0)
  positiveNumber: float64;
}
```

### Array Validation
```typespec
model Pet {
  @minItems(1)
  @maxItems(10)
  tags: string[];
  
  @uniqueItems
  uniqueTags: string[];
}
```

---

## 🔐 Service & Server Decorators

### @service
```typespec
@service(#{
  title: "Pet Store API",
  version: "1.0.0"
})
namespace PetStore;
```

### @server
```typespec
@server("https://api.petstore.com", "Production server")
@server("https://staging.petstore.com", "Staging server")
@server("{scheme}://{host}", "Custom server", #{
  scheme: #{
    type: "string",
    enum: ["https", "http"]
  },
  host: #{
    type: "string",
    default: "api.example.com"
  }
})
namespace PetStore;
```

---

## 👁️ Visibility Decorators

```typespec
model Pet {
  @visibility(Lifecycle.Read)
  id: int64;
  
  name: string;
  
  @visibility(Lifecycle.Create, Lifecycle.Update)
  password: string;
  
  @visibility(Lifecycle.Read, Lifecycle.Create)
  email: string;
}

// Create model từ visibility
@withVisibility(Lifecycle.Create)
model PetCreate {
  ...Pet;
}

@withVisibility(Lifecycle.Read)
model PetRead {
  ...Pet;
}
```

---

## 📖 Examples

### @example cho Types
```typespec
@example(#{
  name: "Max",
  age: 3,
  status: PetStatus.available
})
model Pet {
  name: string;
  age: int32;
  status: PetStatus;
}

// Nhiều examples
@example(#{
  name: "Minimal",
  age: 1
}, #{ title: "Minimal example" })
@example(#{
  name: "Full",
  age: 5,
  tags: ["friendly", "trained"]
}, #{ title: "Full example" })
model Pet {
  name: string;
  age: int32;
  tags?: string[];
}
```

### @opExample cho Operations
```typespec
@opExample(#{
  parameters: #{
    id: 123
  },
  returnType: #{
    name: "Max",
    age: 3
  }
})
@opExample(#{
  parameters: #{
    id: 999
  },
  returnType: #{    
    code: 404,
    message: "Pet not found"
  }
}, #{ title: "Not found case" })
@get
@route("/pets/{id}")
op getPet(@path id: int64): Pet | NotFoundError;
```

---

## 🧩 Templates (Generics)

### Generic Operation
```typespec
// Templated operation
op GetById<T>(@path id: string): T | NotFoundError;

// Specialized operation
op getPet is GetById<Pet>;
op getUser is GetById<User>;
```

### Generic Model
```typespec
model Paged<T> {
  data: T[];
  total: int64;
  page: int32;
  pageSize: int32;
}

model ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: Error;
}

// Usage
op listPets(): Paged<Pet>;
op getPet(@path id: int64): ApiResponse<Pet>;
```

### Generic Interface
```typespec
interface CrudOperations<T, TCreate, TUpdate> {
  @get list(): Paged<T>;
  @post create(@body item: TCreate): T;
  @get get(@path id: string): T;
  @put update(@path id: string, @body item: TUpdate): T;
  @delete delete(@path id: string): void;
}

@route("/pets")
interface Pets extends CrudOperations<Pet, PetCreate, PetUpdate> {}
```

### Template Constraints
```typespec
// Constraint: T phải có property id
model Response<T extends {id: string}> {
  value: T;
}

// Constraint + Default value
model Response<T extends string = ""> {
  value: T;
}

// Multiple constraints
interface Crud<T extends Model, K extends string> {
  get(id: K): T;
}
```

---

## 🏷️ Naming Conventions (Best Practices)

| Type | Convention | Example |
|------|------------|---------|
| Model | PascalCase | `model Pet {}` |
| Model Property | camelCase | `model Pet { furColor: string }` |
| Enum | PascalCase | `enum Direction {}` |
| Enum Member | camelCase | `enum Direction { up, down }` |
| Namespace | PascalCase | `namespace PetStore` |
| Interface | PascalCase | `interface PetRoutes` |
| Operation | camelCase | `op listPets(): Pet[]` |
| Operation Param | camelCase | `op getPet(petId: string): Pet` |
| Union | PascalCase | `union Pet { cat: Cat }` |
| Union Variant | camelCase | `union Pet { cat: Cat }` |
| Alias | camelCase/PascalCase | `alias myString = string` |
| Decorators | camelCase | `@format`, `@resourceCollection` |
| Scalar | camelCase | `scalar uuid extends string` |
| File name | kebab-case | `my-feature.tsp` |
| Template Param | PascalCase | `op GetById<T>(id: string): T` |

---

## 🎨 Best Practices

### 1. File Organization
```typespec
// main.tsp - Entry point, imports tất cả
import "@typespec/http";
import "./common/models.tsp";
import "./pets/models.tsp";
import "./pets/routes.tsp";

using TypeSpec.Http;

@service(#{ title: "Pet Store API" })
@server("https://api.example.com", "Production")
namespace PetStore;
```

```typespec
// common/models.tsp - Shared models
namespace PetStore;

@error
model Error {
  code: int32;
  message: string;
  details?: string;
}

model NotFoundError {
  ...Error;
  code: 404;
}

model ValidationError {
  ...Error;
  code: 400;
  errors: Record<string>;
}
```

### 2. Model Patterns
```typespec
// Base model
model Pet {
  id: int64;
  name: string;
}

// Create model (no id, has password)
model PetCreate {
  ...Pet;
  password: string;
}

// Update model (all optional)
model PetUpdate {
  name?: string;
}

// Response model
model PetResponse {
  @header eTag: string;
  @body pet: Pet;
}
```

### 3. Route Patterns
```typespec
@route("/pets")
@tag("Pets")
interface Pets {
  // List với pagination
  @doc("List all pets")
  @get
  list(
    @query page?: int32 = 1,
    @query pageSize?: int32 = 20,
    @query status?: PetStatus
  ): PagedResponse<Pet> | Error;

  // Create
  @doc("Create a new pet")
  @post
  create(
    @body pet: PetCreate,
    ...AuthHeaders
  ): Pet | ValidationError | Error;

  // Get by ID
  @doc("Get pet by ID")
  @get
  get(@path id: int64): Pet | NotFoundError | Error;

  // Update
  @doc("Update pet")
  @put
  update(
    @path id: int64,
    @body pet: Pet,
    ...AuthHeaders
  ): Pet | NotFoundError | ValidationError | Error;

  // Partial update
  @doc("Update pet with partial data")
  @patch(#{ implicitOptionality: true })
  patch(
    @path id: int64,
    @body pet: PetUpdate,
    ...AuthHeaders
  ): Pet | NotFoundError | ValidationError | Error;

  // Delete
  @doc("Delete a pet")
  @delete
  delete(@path id: int64, ...AuthHeaders): void | NotFoundError | Error;
}
```

### 4. Common Parameters (Spread)
```typespec
// common/models.tsp
model CommonParameters {
  @query traceId?: string;
}

model AuthHeaders {
  @header("Authorization") auth: string;
  @header("X-Request-ID") requestId?: string;
}

// Usage trong route
op list(
  @query page?: int32 = 1,
  ...CommonParameters
): Pet[];

op create(
  @body pet: Pet,
  ...AuthHeaders
): Pet;
```

### 5. Response Patterns
```typespec
// Generic paged response
model PagedResponse<T> {
  @statusCode _: 200;
  @body body: {
    data: T[];
    pagination: {
      total: int64;
      page: int32;
      pageSize: int32;
      totalPages: int32;
    };
  };
}

// Success with custom status
op createPet(@body pet: PetCreate): {
  @statusCode _: 201;
  @header("Location") location: string;
  @body created: Pet;
};
```

---

## 🧪 Ví dụ đầy đủ - Pet Store API

```typespec
// ========== main.tsp ==========
import "@typespec/http";

import "./common/models.tsp";
import "./pets/models.tsp";
import "./pets/routes.tsp";

using TypeSpec.Http;

@service(#{
  title: "Pet Store API",
  version: "1.0.0"
})
@server("https://api.petstore.com", "Production")
@server("https://staging.petstore.com", "Staging")
namespace PetStore;

// ========== common/models.tsp ==========
namespace PetStore;

model CommonParameters {
  @query correlationId?: string;
}

model AuthHeaders {
  @header("Authorization") auth: string;
}

@error
model Error {
  @doc("Error code")
  code: int32;
  
  @doc("Error message")
  message: string;
  
  @doc("Error details")
  details?: string;
}

model NotFoundError {
  ...Error;
  code: 404;
}

model ValidationError {
  ...Error;
  code: 400;
  @doc("Field-specific errors")
  errors: Record<string[]>;
}

model PagedResponse<T> {
  data: T[];
  total: int64;
  page: int32;
  pageSize: int32;
}

// ========== pets/models.tsp ==========
import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

enum PetStatus {
  available: "available",
  pending: "pending",
  sold: "sold"
}

enum Category {
  dog: "dog",
  cat: "cat",
  bird: "bird",
  fish: "fish"
}

@example(#{
  id: 1,
  name: "Max",
  category: Category.dog,
  photoUrls: ["http://example.com/dog.jpg"],
  tags: [#{ id: 1, name: "friendly" }],
  status: PetStatus.available,
  price: 99.99
})
model Pet {
  @doc("Unique identifier")
  @minValue(1)
  id: int64;
  
  @doc("Pet name")
  @minLength(1)
  @maxLength(100)
  name: string;
  
  @doc("Pet category")
  category: Category;
  
  @doc("Photo URLs")
  photoUrls: string[];
  
  @doc("Tags")
  tags?: Tag[];
  
  @doc("Status in store")
  status?: PetStatus;
  
  @doc("Price in USD")
  @minValue(0)
  price?: decimal;
}

model Tag {
  id: int64;
  name: string;
}

model PetCreate {
  @minLength(1)
  @maxLength(100)
  name: string;
  
  category: Category;
  photoUrls: string[];
  tags?: Tag[];
  status?: PetStatus;
  @minValue(0)
  price?: decimal;
}

model PetUpdate {
  @minLength(1)
  @maxLength(100)
  name?: string;
  category?: Category;
  photoUrls?: string[];
  tags?: Tag[];
  status?: PetStatus;
  @minValue(0)
  price?: decimal;
}

// ========== pets/routes.tsp ==========
import "@typespec/http";
import "./models.tsp";
import "../common/models.tsp";

using TypeSpec.Http;

namespace PetStore;

@route("/pets")
@tag("Pets")
interface Pets {
  @doc("List all pets with pagination")
  @get
  list(
    @doc("Filter by status")
    @query
    status?: PetStatus,
    
    @doc("Filter by category")
    @query
    category?: Category,
    
    @doc("Page number")
    @query
    @minValue(1)
    page?: int32 = 1,
    
    @doc("Items per page")
    @query
    @minValue(1)
    @maxValue(100)
    pageSize?: int32 = 20,
    
    ...CommonParameters
  ): PagedResponse<Pet> | Error;

  @doc("Create a new pet")
  @post
  create(
    @doc("Pet object to add")
    @body
    pet: PetCreate,
    ...AuthHeaders
  ): {
    @statusCode _: 201;
    @header("Location") location: string;
    @body createdPet: Pet;
  } | ValidationError | Error;

  @doc("Get pet by ID")
  @get
  get(
    @doc("Pet ID")
    @path
    id: int64
  ): Pet | NotFoundError | Error;

  @doc("Update an existing pet")
  @put
  update(
    @path
    id: int64,
    @body
    pet: PetCreate,
    ...AuthHeaders
  ): Pet | NotFoundError | ValidationError | Error;

  @doc("Update pet with partial data")
  @patch(#{ implicitOptionality: true })
  patch(
    @path
    id: int64,
    @body
    pet: PetUpdate,
    ...AuthHeaders
  ): Pet | NotFoundError | ValidationError | Error;

  @doc("Delete a pet")
  @delete
  delete(
    @path
    id: int64,
    ...AuthHeaders
  ): void | NotFoundError | Error;

  @doc("Find pets by tags")
  @route("findByTags")
  @get
  findByTags(
    @query
    tags: string[]
  ): Pet[] | Error;
}
```

---

## 🛠️ Commands

```bash
# Compile TypeSpec to OpenAPI
pnpm tsp compile ./typespec

# Output: ./tsp-output/schema/openapi.yaml

# Format TypeSpec files
pnpm tsp format "**/*.tsp"

# Validate
pnpm tsp compile ./typespec --warn-as-error
```

---

## 📚 Tài nguyên

- [TypeSpec Documentation](https://typespec.io/docs)
- [TypeSpec GitHub](https://github.com/microsoft/typespec)
- [TypeSpec Playground](https://typespec.io/playground)

---

*Cheatsheet được tạo từ Context7 TypeSpec documentation và best practices*
