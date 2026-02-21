import "@typespec/http";

// Import common
import "./common/errors.tsp";
import "./common/responses.tsp";
import "./common/parameters.tsp";
import "./common/headers.tsp";

// Import features
import "./pets/models.tsp";
import "./pets/routes.tsp";

import "./users/models.tsp";
import "./users/routes.tsp";

import "./store/models.tsp";
import "./store/routes.tsp";

using TypeSpec.Http;

@service(#{ title: "Pet Store API" })
@server("https://api.petstore.com", "Production")
@server("https://staging.petstore.com", "Staging")
namespace PetStore;