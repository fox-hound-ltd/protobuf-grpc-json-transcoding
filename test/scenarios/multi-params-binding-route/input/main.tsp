import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service(#{ title: "main" })
@package({
  name: "main",
})
namespace DemoService;

@message
model Request {
  @path
  @field(1)
  version: int32;

  @path
  @field(2)
  name: string;
}

@message
model Response {
  @field(1) message: string;
}

@Protobuf.service
@route("/v1")
interface Service {
  @route("/version/{version}/name/{name}")
  @get
  Get(...Request): Response;
}
