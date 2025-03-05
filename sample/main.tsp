import "@typespec/http";
import "@typespec/protobuf";
import "@typespec/rest";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service(#{ title: "Greet" })
@package({
  name: "greet",
})
namespace Greet;

@doc("HelloRequest!")
@message
model HelloRequest {
  @field(1)
  @doc("Name!")
  name: string;
}

@doc("HelloRequestFrom!")
@message
model HelloRequestFrom {
  @field(1)
  @doc("Name!")
  name: string;

  @field(2)
  @doc("From!")
  from: string;
}

@doc("HelloRequestFromWithType!")
@message
model HelloRequestFromWithType {
  @field(1)
  @doc("Type!")
  type: string;

  @field(2)
  @doc("Params!")
  params: HelloRequestFrom;
}

@doc("HelloReply!")
@message
model HelloReply {
  @field(1)
  @doc("Message!")
  message: string;
}

@doc("Greeter service!")
@Protobuf.service
@route("/v1/greeter")
interface Greeter {
  @doc("SayHello method!")
  @route("{name}")
  @get
  SayHello(...HelloRequest): HelloReply;

  @doc("SayHelloFrom method!")
  @post
  SayHelloFrom(...HelloRequestFrom): HelloReply;

  @doc("SayHelloFromWithType method!")
  @post
  @route("/type/{type}")
  SayHelloFromWithType(...HelloRequestFromWithType): HelloReply;
}
