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
