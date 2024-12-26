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
model Widget<TItem extends {}> {
  @key
  @path
  @field(1)
  id: int32;

  @visibility(Shared.Lifecycle.Create, Shared.Lifecycle.Update)
  @field(2)
  weight: int32;

  @field(3)
  items: TItem[];
}

@message
model WidgetItem {
  @key
  @path
  @field(1)
  id: int32;

  @field(2)
  type: int32;
}

model WidgetQuery {}

alias WidgetRead = Widget<Resource.ResourceResponse<WidgetItem>>;
alias WidgetCreate = Widget<Resource.ResourceCreateRequest<WidgetItem>>;
alias WidgetUpdate = Widget<Resource.ResourceUpdateParameterRequest<WidgetItem, WidgetItem>>;

@Protobuf.service
@route("/widgets")
@tag("Widgets")
interface Widgets
  extends Resource.ResourceGridOperations<WidgetRead, WidgetQuery, WidgetCreate, WidgetUpdate>,
    Resource.ResourceCreateMany<WidgetRead, WidgetCreate>,
    Resource.ResourceUpdateMany<WidgetRead, WidgetUpdate>,
    Resource.ResourceDeleteMany<WidgetRead> {}
