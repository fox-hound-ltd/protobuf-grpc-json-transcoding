import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service({
  title: "main",
})
@package({
  name: "main",
})
namespace DemoService;

@message
model DeleteBodyRequest {
  @path
  @field(1)
  id: string;

  @field(2) body: string;
}

@Protobuf.service
@route("/v1")
interface Service {
  @route("/{id}")
  @delete
  Delete(@field(1) @path id: string): void;
  @route("/body/{id}")
  @delete
  DeleteBody(...DeleteBodyRequest): void;
}
