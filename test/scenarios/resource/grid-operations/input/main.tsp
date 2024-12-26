import "@typespec/http";
import "@typespec/protobuf";
import "@fox-hound-tools/protobuf-grpc-json-transcoding";
using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service({
  title: "Widget Service",
})
@package({
  name: "main",
})
namespace DemoService;

@message
model Widget {
  @key
  @path
  @field(1)
  id: string;

  @visibility(Shared.Lifecycle.Create, Shared.Lifecycle.Update)
  @field(2)
  weight: int32;

  @field(3) color: string;
}

model WidgetQuery {}

@Protobuf.service
@route("/widgets")
@tag("Widgets")
interface Widgets
  extends Resource.ResourceGridOperations<Widget, WidgetQuery>,
    Resource.ResourceCreateMany<Widget, Widget>,
    Resource.ResourceUpdateMany<Widget, Widget>,
    Resource.ResourceDeleteMany<Widget> {}
