import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service(#{ title: "Widget Service" })
@package({
  name: "widget",
})
namespace DemoService;

model Widget {
  @visibility(Lifecycle.Read, Lifecycle.Update)
  @path
  @field(1)
  id: string;

  @field(2) weight: int32;
  @field(3) color: string;
}

@error
model Error {
  @field(1) code: int32;
  @field(2) message: string;
}

@Protobuf.service
@route("/widgets")
@tag("Widgets")
interface Widgets {
  @get list(): {
    @field(1) widgets: Widget[];
  };
  @get read(@field(1) @path id: string): Widget;
  @post create(...Widget): Widget;
  @patch(#{ implicitOptionality: false }) update(...Widget): Widget;
  @delete delete(@field(1) @path id: string): void;
  @route("{id}/analyze") @post analyze(@field(1) @path id: string): {
    @field(1) result: string;
  };
}
