import "@typespec/http";
import "./models.tsp";
import "../common/models.tsp";

using TypeSpec.Http;

namespace PetStore;

@route("/pets")
@tag("Pets")
interface Pets {
  @doc("List all pets")
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
    pet: Pet,
    ...AuthHeaders
  ): Pet | ValidationError | Error;

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
    pet: Pet,
    ...AuthHeaders
  ): Pet | NotFoundError | ValidationError | Error;

  @doc("Update pet with partial data (PATCH)")
  @patch(#{implicitOptionality: true})
  patch(
    @path
    id: int64,
    @body
    pet: PetUpdateInput,
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