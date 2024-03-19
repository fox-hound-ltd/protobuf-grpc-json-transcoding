import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service({
  title: "Main",
})
@package({
  name: "main",
})
namespace DemoService;

model V1 {
  @field(1) id: int32;
  @field(2) name: string;
}

model V2 {
  @field(1) id: string;
  @field(2) name: string;
}

model V1GetRequest {
  @path @field(1) name: string;
}

model V2GetRequest {
  @path @field(1) id: string;
}

@Protobuf.service
@route("/v1")
interface V1Service {
  @get get(...V1GetRequest): V1;
}

@Protobuf.service
@route("/v2")
interface V2Service {
  @get get(...V2GetRequest): V2;
}
