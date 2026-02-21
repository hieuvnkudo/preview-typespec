import "@typespec/http";

using TypeSpec.Http;

namespace PetStore;

model User {
  @doc("User ID")
  id?: int64;

  @doc("Username")
  @minLength(3)
  @maxLength(50)
  @pattern("^[a-zA-Z0-9_-]+$")
  username: string;

  @doc("First name")
  firstName?: string;

  @doc("Last name")
  lastName?: string;

  @doc("Email address")
  @format("email")
  email: string;

  @doc("Password")
  @minLength(8)
  @format("password")
  password: string;

  @doc("Phone number")
  @format("phone")
  phone?: string;

  @doc("User status")
  userStatus?: int32;
}