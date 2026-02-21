import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

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

// Pagination Parameters
model PageParameters {
  @doc("Page number")
  @query
  page?: int32 = 1;

  @doc("Items per page")
  @query
  pageSize?: int32 = 20;

  @doc("Sort field")
  @query
  sortBy?: string;

  @doc("Sort direction")
  @query
  sortOrder?: "asc" | "desc" = "asc";
}
