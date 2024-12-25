namespace Shared;
/**
 * Visibility of a resource.
 *
 * - "read": output of any operation.
 * - "create": input to operations that create an entity..
 * - "query": input to operations that read data.
 * - "update": input to operations that update data.
 * - "delete": input to operations that delete data.
 */
union Lifecycle {
  /**
   * output of any operation.
   */
  Read: "read",

  /**
   * input to operations that create an entity.
   */
  Create: "create",

  /**
   * input to operations that read data.
   */
  Query: "query",

  /**
   * input to operations that update data.
   */
  Update: "update",

  /**
   * input to operations that delete data.
   */
  Delete: "delete",
}
