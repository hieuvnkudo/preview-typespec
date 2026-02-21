import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

// Authentication Headers
model AuthHeaders {
  @doc("Bearer token")
  @header
  authorization?: string;

  @doc("API Key")
  @header
  "x-api-key"?: string;

  @doc("Refresh token")
  @header
  "x-refresh-token"?: string;
}

// Request Tracking Headers
model RequestIdHeaders {
  @doc("Request ID for tracing")
  @header
  "x-request-id"?: string;

  @doc("Correlation ID")
  @header
  "x-correlation-id"?: string;
}
