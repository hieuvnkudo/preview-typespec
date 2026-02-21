import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

// Error Models
@error
model Error {
  @doc("Error code")
  code: int32;

  @doc("Error message")
  message: string;

  @doc("Detailed error information")
  details?: string;
}

@error
model ValidationError {
  code: "VALIDATION_ERROR";
  message: string;
  @doc("List of validation errors")
  errors: ValidationErrorItem[];
}

model ValidationErrorItem {
  field: string;
  message: string;
  code: string;
}

@error
model NotFoundError {
  code: "NOT_FOUND";
  message: string;
  resource: string;
}

// Generic Models
model PagedResponse<T> {
  data: T[];
  pagination: {
    total: int32;
    page: int32;
    pageSize: int32;
    totalPages: int32;
  };
}

// Common Parameters
model CommonParameters {
  @doc("Request ID for tracing")
  @header
  requestId: string;

  @doc("API Version")
  @header
  apiVersion?: string = "v1";

  @doc("Response language")
  @query
  language?: string = "en";

  @doc("Include extra fields")
  @query
  include?: string;
}

// Authentication Headers
model AuthHeaders {
  @doc("Bearer token")
  @header
  authorization?: string;
  
  @doc("API Key")
  @header
  "x-api-key"?: string;
}