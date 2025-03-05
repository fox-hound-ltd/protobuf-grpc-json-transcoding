import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service(#{ title: "main" })
@package({
  name: "main",
})
namespace DemoService;
