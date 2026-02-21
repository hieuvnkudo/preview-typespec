import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

// Generic Response Models
model PagedResponse<T> {
  data: T[];
  pagination: {
    total: int32;
    page: int32;
    pageSize: int32;
    totalPages: int32;
  };
}

// API Response wrapper
model ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: Error;
}
