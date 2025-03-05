import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Protobuf;
using TypeSpec.Http;

@TypeSpec.service(#{ title: "Address Book" })
@package({
  name: "addressbook",
})
namespace AddressBookNamespace;

@Protobuf.service
@route("book")
interface AddressBook {
  @get List(): GetBookResult;
  @get Get(@field(1) @path id: string): Book;
  @post Add(...Book): Book;
  @put Update(...Book): Book;
  @delete Delete(@field(1) @path id: string): void;
}

model Book {
  @visibility(Lifecycle.Update)
  @path
  @field(1)
  id: string;

  @field(2) name: string;
}

model GetBookResult {
  @field(1) books: Book[];
}
