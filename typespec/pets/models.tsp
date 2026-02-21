import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

// Enums
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

// Models
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

  @doc("List of photo URLs")
  photoUrls: string[];

  @doc("Tags for the pet")
  tags?: Tag[];

  @doc("Pet status in store")
  status?: PetStatus;

  @doc("Price in USD")
  @minValue(0)
  price?: decimal;

  @doc("Date of birth")
  dateOfBirth?: plainDate;
}

model Tag {
  id: int64;
  name: string;
}

model PetUpdateInput {
  @minLength(1)
  @maxLength(100)
  name?: string;
  category?: Category;
  photoUrls?: string[];
  tags?: Tag[];
  status?: PetStatus;
  @minValue(0)
  price?: decimal;
  dateOfBirth?: plainDate;
}

// Spread operator example
model CreatePetRequest {
  ...Pet;
  @doc("Force creation even if similar pet exists")
  force?: boolean;
}