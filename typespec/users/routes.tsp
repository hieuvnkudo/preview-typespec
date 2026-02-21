import "@typespec/http";
import "./models.tsp";
import "../common/errors.tsp";
import "../common/responses.tsp";
import "../common/parameters.tsp";
import "../common/headers.tsp";

using TypeSpec.Http;

namespace PetStore;

@route("/users")
@tag("Users")
interface Users {
  @doc("Create user")
  @post
  create(
    @body
    user: User
  ): User | ValidationError | Error;

  @doc("Create list of users with given input array")
  @route("createWithArray")
  @post
  createWithArray(
    @body
    users: User[]
  ): void | Error;

  @doc("Create list of users with given input list")
  @route("createWithList")
  @post
  createWithList(
    @body
    users: User[]
  ): void | Error;

  @doc("Login user")
  @route("login")
  @get
  login(
    @query
    username: string,
    @query
    password: string
  ): {
    @header "x-rate-limit": int32;
    @header "x-expires-after": utcDateTime;
    sessionId: string;
  } | Error;

  @doc("Logout user")
  @route("logout")
  @get
  logout(): void;

  @doc("Get user by username")
  @route("{username}")
  @get
  getUser(
    @path
    username: string
  ): User | NotFoundError | Error;

  @doc("Updated user")
  @route("{username}")
  @put
  updateUser(
    @path
    username: string,
    @body
    user: User,
    ...AuthHeaders
  ): void | NotFoundError | ValidationError | Error;

  @doc("Delete user")
  @route("{username}")
  @delete
  deleteUser(
    @path
    username: string,
    ...AuthHeaders
  ): void | NotFoundError | Error;
}