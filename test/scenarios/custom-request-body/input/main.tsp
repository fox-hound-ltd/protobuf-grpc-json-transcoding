import "@typespec/http";
import "@typespec/protobuf";

using TypeSpec.Http;
using TypeSpec.Protobuf;
@TypeSpec.service(#{ title: "main" })
@package({
  name: "main",
})
namespace DemoService;

model AddAddressRequest {
  @field(1)
  apiVersion: int32;

  @field(2)
  address: Address;
}

model Address {
  @field(1)
  street: string;

  @field(2)
  city: string;

  @field(3)
  country: string;
}

model AddAddressReply {
  @field(1)
  addressId: string;
}

@Protobuf.service
interface AddressService {
  @route("{apiVersion}/address")
  AddAddress(...AddAddressRequest): AddAddressReply;
}
