import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

model Order {
  @doc("Order ID")
  id?: int64;

  @doc("Pet ID")
  @minValue(1)
  petId: int64;

  @doc("Quantity ordered")
  @minValue(1)
  quantity: int32 = 1;

  @doc("Ship date")
  shipDate?: utcDateTime;

  @doc("Order Status")
  status?: "placed" | "approved" | "delivered" = "placed";

  @doc("Complete status")
  complete?: boolean = false;
}