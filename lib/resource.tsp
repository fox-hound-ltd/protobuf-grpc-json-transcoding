import "@typespec/protobuf";
import "@typespec/http";
import "@typespec/rest";
using TypeSpec.Protobuf;
using TypeSpec.Http;
using TypeSpec.Rest;

@package({
  name: "resource",
  options: {
    csharp_namespace: "Server.Protos.Resource",
  },
})
namespace Resource;

/**
 * Dynamically gathers parent keys of the model type `Resource`.
 *
 * @template Resource The target resource model.
 */
@doc("Dynamically gathers {name} parent keys of the model type Resource.")
@copyResourceKeyParameters("parent")
@friendlyName("{name}ParentKey", Resource)
model ParentKeysOf<Resource> {}

/**
 * Dynamically gathers keys of the model type `Resource`.
 *
 * @template Resource The target resource model.
 */
@doc("Dynamically gathers keys of the model type Resource.")
@copyResourceKeyParameters
@friendlyName("{name}Key", Resource)
model KeysOf<Resource> {}

/**
 * Represents collection operation parameters for the resource of type `Resource`.
 *
 * @template Resource The resource model.
 */
@doc("{name} collection operation parameters for resource Resource.", Resource)
@friendlyName("{name}ParentRequestParameter", Resource)
model ResourceCollectionParameters<Resource extends {}> {
  ...ParentKeysOf<Resource>;
}

/**
 * Represents operation parameters for the resource of type `Resource`.
 *
 * @template Resource The resource model.
 */
@doc("{name} operation parameters for resource Resource.", Resource)
@friendlyName("{name}RequestParameter", Resource)
model ResourceParameters<Resource extends {}> {
  ...KeysOf<Resource>;
}

/**
 * Resource create or update operation model.
 *
 * @template Resource The resource model to create or update.
 */
@doc("{name} create or update operation model.", Resource)
@friendlyName("{name}CreateOrUpdateRequest", Resource)
@withUpdateableProperties
model ResourceCreateOrUpdateRequest<Resource extends {}>
  is OptionalProperties<UpdateableProperties<DefaultKeyVisibility<Resource, Lifecycle.Read>>>;

/**
 * Represents Resource update and key parameter model.
 *
 * @template Resource The resource model to update.
 */
@doc("{name} update and key parameter model.", Resource)
@friendlyName("{name}UpdateRequest", Resource)
@withUpdateableProperties
model ResourceUpdateParameterRequest<Resource extends {}, RequestResource extends {}> {
  ...ResourceParameters<Resource>;
  ...ResourceCreateOrUpdateRequest<RequestResource>;
}

/**
 * Resource update operation model.
 *
 * @template Resource The resource model to create or update.
 */
@doc("{name} update operation model.", Resource)
@friendlyName("{name}UpdateRequest", Resource)
@withUpdateableProperties
model ResourceUpdateRequest<Resource extends {}>
  is UpdateableProperties<DefaultKeyVisibility<Resource, Lifecycle.Read>>;

/**
 * Represents resource update collection operation model.
 *
 * @template Resource The resource model to create.
 */
@doc("{name} update collection operation model.", Resource)
@friendlyName("{name}UpdateCollectionRequest", Resource)
@withVisibility(Lifecycle.Update)
model ResourceUpdateCollectionRequest<Resource extends {}, RequestResource extends {}> {
  @doc("The items on update")
  @field(1)
  value: ResourceUpdateParameterRequest<Resource, RequestResource>[];
}

/**
 * Represents operation response for the resource of type `Resource`.
 */
@doc("{name} operation response for resource Resource.", Resource)
@withVisibility(Lifecycle.Read)
@friendlyName("{name}Response", Resource)
model ResourceResponse<Resource extends {}> {
  ...Resource;
}

/**
 * Represents response of resource items.
 *
 * @template Resource The resource model.
 */
@doc("Response of {name} items", Resource)
@friendlyName("{name}CollectionResponse", Resource)
model Collection<Resource extends {}> {
  @doc("The items on this page")
  @field(1)
  value: ResourceResponse<Resource>[];
}
/**
 * Represents response of resource items.
 *
 * @template Resource The resource model.
 */
@doc("Response of {name} items", Resource)
@friendlyName("{name}CollectionWithCountResponse", Resource)
model CollectionWithCount<Resource extends {}> {
  @doc("The items on this page")
  @field(1)
  value: ResourceResponse<Resource>[];

  @doc("The total count of items")
  @field(2)
  total?: int32;
}

/**
 * Represents resource create operation model.
 *
 * @template Resource The resource model to create.
 */
@doc("{name} create operation model.", Resource)
@friendlyName("{name}CreateRequest", Resource)
@withVisibility(Lifecycle.Create)
model ResourceCreateRequest<Resource extends {}> is DefaultKeyVisibility<Resource, Lifecycle.Read>;

/**
 * Represents resource create collection operation model.
 *
 * @template Resource The resource model to create.
 */
@doc("{name} create collection operation model.", Resource)
@friendlyName("{name}CreateCollectionRequest", Resource)
@withVisibility(Lifecycle.Create)
model ResourceCreateCollectionRequest<Resource extends {}> {
  @doc("The items on create")
  @field(1)
  value: ResourceCreateRequest<Resource>[];
}

/**
 * Represents resource list search operation query model.
 *
 * @template Resource The resource model to create.
 */
@doc("{name} list search operation query model.", Resource)
@friendlyName("{name}ListSearchRequest", Resource)
@withVisibility(Lifecycle.Query)
model ResourceListSearchRequest<Resource extends {}> is DefaultKeyVisibility<Resource, Lifecycle.Read>;

/**
 * Represents resource list search operation query model.
 *
 * @template Resource The resource model to create.
 */
@doc("{name} list search operation query model.", Resource)
@friendlyName("{name}ListSearchRequest", Resource)
@withVisibility(Lifecycle.Query)
model ResourceGridListSearchRequest<Resource extends {}> {
  ...ResourceListSearchRequest<Resource>;
  ...Pagination;
  ...Sort;
  ...Filter;
}

/**
 * Represents the resource GET operation.
 *
 * @template Resource The resource model.
 */
interface ResourceRead<Resource extends {}> {
  /**
   * Gets an instance of the resource.
   *
   * @template Resource The resource model.
   */
  @autoRoute
  @doc("Gets an instance of the {name}.", Resource)
  @readsResource(Resource)
  Get(...ResourceParameters<Resource>): ResourceResponse<Resource>;
}

/**
 * Resource update operation template.
 *
 * @template Resource The resource model to update.
 */
interface ResourceUpdate<Resource extends {}, RequestResource extends {}> {
  /**
   * Updates an existing instance of the resource.
   *
   * @template Resource The resource model to update.
   */
  @autoRoute
  @doc("Updates an existing instance of the {name}.", Resource)
  @updatesResource(Resource)
  Update(...ResourceUpdateParameterRequest<Resource, RequestResource>): ResourceResponse<Resource>;
}

/**
 * Resource updates operation template.
 *
 * @template Resource The resource model to update.
 */
interface ResourceUpdateMany<Resource extends {}, RequestResource extends {}> {
  /**
   * Updates existing instances of the resource.
   *
   * @template Resource The resource model to update.
   */
  @autoRoute
  @doc("Updates existing instances of the {name}.", Resource)
  @patch
  UpdateMany(
    ...ResourceCollectionParameters<Resource>,
    ...ResourceUpdateCollectionRequest<Resource, RequestResource>,
  ): Collection<Resource>;
}

/**
 * Resource delete operation template.
 *
 * @template Resource The resource model to delete.
 */
interface ResourceDelete<Resource extends {}> {
  /**
   * Deletes an existing instance of the resource.
   *
   * @template Resource The resource model to delete.
   */
  @autoRoute
  @doc("Deletes an existing instance of the {name}.", Resource)
  @deletesResource(Resource)
  Delete(...ResourceParameters<Resource>): void;
}

/**
 * Represents resource delete collection operation model.
 *
 * @template Resource The resource model.
 */
@doc("{name} delete collection operation model.", Resource)
@friendlyName("{name}DeleteCollectionRequest", Resource)
@message
model ResourceDeleteCollectionRequest<
  Resource extends {},
  Type extends numeric | string = numeric,
  RequestResource extends {} = {}
> {
  ...RequestResource;

  @field(999)
  ids: Type[];
}

/**
 * Resource deletes operation template.
 *
 * @template Resource The resource model to delete.
 */
interface ResourceDeleteMany<
  Resource extends {},
  Type extends numeric | string = int32,
  RequestResource extends {} = {}
> {
  /**
   * Deletes existing instances of the resource.
   *
   * @template Resource The resource model to delete.
   */
  @autoRoute
  @doc("Deletes existing instances of the {name}.", Resource)
  @delete
  DeleteMany(
    ...ResourceCollectionParameters<Resource>,
    ...ResourceDeleteCollectionRequest<Resource, Type, RequestResource>,
  ): void;
}

/**
 * Resource operation templates for resource instances.
 *
 * @template Resource The resource model.
 */
interface ResourceInstanceOperations<Resource extends {}, UpdateRequestResource extends {} = Resource>
  extends ResourceRead<Resource>,
    ResourceUpdate<Resource, UpdateRequestResource>,
    ResourceDelete<Resource> {}

/**
 * Resource list operation template.
 *
 * @template Resource The resource model to list.
 */
interface ResourceList<Resource extends {}, SearchResource extends {}> {
  /**
   * Lists all instances of the resource.
   *
   * @template Resource The resource model to list.
   */
  @autoRoute
  @doc("Lists all instances of the {name}.", Resource)
  @listsResource(Resource)
  List(...ResourceCollectionParameters<Resource>, ...ResourceListSearchRequest<SearchResource>): Collection<Resource>;
}

/**
 * Resource grid list operation template.
 *
 * @template Resource The resource model to list.
 */
interface ResourceGridList<Resource extends {}, SearchResource extends {}> {
  /**
   * Lists all instances of the resource.
   *
   * @template Resource The resource model to list.
   */
  @autoRoute
  @doc("Lists all instances of the {name}.", Resource)
  @listsResource(Resource)
  List(
    ...ResourceCollectionParameters<Resource>,
    ...ResourceGridListSearchRequest<SearchResource>,
  ): CollectionWithCount<Resource>;
}

/**
 * Resource create operation template.
 *
 * @template Resource The resource model to create.
 */
interface ResourceCreate<Resource extends {}, RequestResource extends {}> {
  /**
   * Creates a new instance of the resource.
   *
   * @template Resource The resource model to create.
   */
  @autoRoute
  @doc("Creates a new instance of the {name}.", Resource)
  @createsResource(Resource)
  Create(
    ...ResourceCollectionParameters<Resource>,
    ...ResourceCreateRequest<RequestResource>,
  ): ResourceResponse<Resource>;
}

/**
 * Resource creates operation template.
 *
 * @template Resource The resource model to create.
 */
interface ResourceCreateMany<Resource extends {}, RequestResource extends {}> {
  /**
   * Creates instances of the resource.
   *
   * @template Resource The resource model to create.
   */
  @autoRoute
  @doc("Creates new instances of the {name}.", Resource)
  @put
  CreateMany(
    ...ResourceCollectionParameters<Resource>,
    ...ResourceCreateCollectionRequest<RequestResource>,
  ): Collection<Resource>;
}

/**
 * Resource operation templates for resource collections.
 *
 * @template Resource The resource model.
 */
interface ResourceCollectionOperations<
  Resource extends {},
  SearchResource extends {},
  CreateRequestResource extends {} = Resource
> extends ResourceList<Resource, SearchResource>, ResourceCreate<Resource, CreateRequestResource> {}

/**
 * Resource grid operation templates for resource collections.
 *
 * @template Resource The resource model.
 */
interface ResourceGridCollectionOperations<
  Resource extends {},
  SearchResource extends {},
  CreateRequestResource extends {} = Resource
> extends ResourceGridList<Resource, SearchResource>, ResourceCreate<Resource, CreateRequestResource> {}

/**
 * Resource operation templates for resources.
 *
 * @template Resource The resource model.
 */
interface ResourceOperations<
  Resource extends {},
  SearchResource extends {},
  CreateRequestResource extends {} = Resource,
  UpdateRequestResource extends {} = Resource
>
  extends ResourceInstanceOperations<Resource, UpdateRequestResource>,
    ResourceCollectionOperations<Resource, SearchResource, CreateRequestResource> {}

/**
 * Resource grid operation templates for resources.
 *
 * @template Resource The resource model.
 */
interface ResourceGridOperations<
  Resource extends {},
  SearchResource extends {},
  CreateRequestResource extends {} = Resource,
  UpdateRequestResource extends {} = Resource
>
  extends ResourceInstanceOperations<Resource, UpdateRequestResource>,
    ResourceGridCollectionOperations<Resource, SearchResource, CreateRequestResource> {}

/**
 * ページネーション
 */
@message
model Pagination {
  @query
  @visibility(Lifecycle.Query)
  @field(1001)
  @pageIndex
  page?: int32;

  @query
  @visibility(Lifecycle.Query)
  @field(1002)
  @pageSize
  pageSize?: int32;
}

/**
 * Grpc JSON transcodingではクエリのオブジェクトが使用できないので、stringで対応する
 */
#deprecated "DO NOT USE stirng sample"
enum SortOrder {
  Ascending: "asc",
  Descending: "desc",
}

/**
 * ソート
 */
@message
model Sort {
  /**
   * ソート条件
   *
   * @description
   * {field}.{SortOrder}
   * @example
   * - id.desc
   * - title.asc
   */
  @query
  @visibility(Lifecycle.Query)
  @field(1003)
  orders?: string[];
}

// Filters are used as a suffix of a field name:

// | Filter              | Description                       |
// | ------------------- | --------------------------------- |
// | `eq`                | Equal                             |
// | ne                  | Not equal                         |
// | lt                  | Less than                         |
// | gt                  | Greater than                      |
// | lte                 | Less than or equal to             |
// | gte                 | Greater than or equal to          |
// | in                  | Included in an array              |
// | nin                 | Not included in an array          |
// | contains            | Contains                          |
// | ncontains           | Doesn't contain                   |
// | containss           | Contains, case sensitive          |
// | ncontainss          | Doesn't contain, case sensitive   |
// | null                | Is null or not null               |
// | startswith          | Starts with                       |
// | nstartswith         | Doesn't start with                |
// | startswiths         | Starts with, case sensitive       |
// | nstartswiths        | Doesn't start with, case sensitive|
// | endswith            | Ends with                         |
// | nendswith           | Doesn't end with                  |
// | endswiths           | Ends with, case sensitive         |
// | nendswiths          | Doesn't end with, case sensitive  |

/**
 * Grpc JSON transcodingではクエリのオブジェクトが使用できないので、stringで対応する
 */
#deprecated "DO NOT USE stirng sample"
enum FilterOperator {
  Equal: "eq",
  NotEqual: "ne",
  LessThan: "lt",
  GreaterThan: "gt",
  LessThanOrEqual: "lte",
  GreaterThanOrEqual: "gte",
  In: "in",
  NotIn: "nin",
  InArray: "ina",
  NotInArray: "nina",
  Contains: "contains",
  NotContains: "ncontains",
  ContainsSensitive: "containss",
  NotContainsSensitive: "ncontainss",
  Between: "between",
  NotBetween: "nbetween",
  Null: "null",
  NotNull: "nnull",
  StartsWith: "startswith",
  NotStartsWith: "nstartswith",
  StartsWithSensitive: "startswiths",
  NotStartsWithSensitive: "nstartswiths",
  EndsWith: "endswith",
  NotEndsWith: "nendswith",
  EndsWithSensitive: "endswiths",
  NotEndsWithSensitive: "nendswiths",
}

/**
 * フィルター
 */
@message
model Filter {
  /**
   * フィルター条件
   *
   * @description
   * {field}.{operator}.{value}
   * @example
   * - id.eq.1
   * - title.contains.hoge
   */
  @query
  @visibility(Lifecycle.Query)
  @field(1004)
  filters?: string[];
}
