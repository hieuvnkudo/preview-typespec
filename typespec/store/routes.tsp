import "@typespec/http";
import "./models.tsp";
import "../common/errors.tsp";
import "../common/responses.tsp";
import "../common/parameters.tsp";
import "../common/headers.tsp";

using TypeSpec.Http;

namespace PetStore;

@route("/store")
@tag("Store")
interface Store {
  @doc("Get inventory by status")
  @route("inventory")
  @get
  getInventory(...AuthHeaders): Record<int32> | Error;

  @doc("Place an order for a pet")
  @route("order")
  @post
  placeOrder(
    @body
    order: Order
  ): Order | ValidationError | Error;

  @doc("Find purchase order by ID")
  @route("order/{orderId}")
  @get
  getOrder(
    @path
    @minValue(1)
    @maxValue(10)
    orderId: int64
  ): Order | NotFoundError | Error;

  @doc("Delete purchase order by ID")
  @route("order/{orderId}")
  @delete
  deleteOrder(
    @path
    orderId: int64,
    ...AuthHeaders
  ): void | NotFoundError | Error;
}