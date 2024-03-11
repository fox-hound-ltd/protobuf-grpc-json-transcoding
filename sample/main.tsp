import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service({
  title: "Greet Service",
})
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
}
