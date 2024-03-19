import { ModelProperty, Namespace, Program, StringLiteral, resolvePath } from '@typespec/compiler';
import { getOpenAPI3 } from '@typespec/openapi3';

export function hasBothServiceAndPackageDecorators(namespace: Namespace): boolean {
  return (
    namespace.decorators.some((decorator) => decorator.definition?.name === '@package') &&
    namespace.decorators.some((decorator) => decorator.definition?.name === '@service')
  );
}

export function getFilePathAndName(namespace: Namespace): [string, string] {
  let packageName: string | undefined;
  namespace.decorators.forEach((decorator) => {
    if (decorator.definition?.name === '@package') {
      decorator.args.forEach((argument) => {
        if (argument.value.kind === 'Model') {
          packageName = (
            (argument.value.properties.get('name') as ModelProperty | undefined)?.type as StringLiteral | undefined
          )?.value;
        }
      });
    }
  });
  const packageSlug = packageName?.split('.') ?? ['main'];
  return [resolvePath('', ...packageSlug.slice(0, -1)), packageSlug[packageSlug.length - 1] + '.proto'];
}

/**
 * Exsits the file.
 * @param program Emit program.
 * @param path Path to the file.
 */
export async function exsitsFile(program: Program, path: string): Promise<boolean> {
  try {
    return (await program.host.stat(path)).isFile();
  } catch (error) {
    return false;
  }
}

/**
 * Get service from interface block.
 * @param text Text of the file.
 * @param name Name of the interface.
 */
export function getServiceOperations(text: string, serviceName: string) {
  const exp = new RegExp(`service ${serviceName} {\n((.|\n)*)\n}\n`);
  const result = exp.exec(text);
  if (result) {
    return result[1];
  }
  return '';
}

/**
 * Replace service from interface block.
 * @param text Text of the file.
 * @param serviceName Name of the interface.
 * @param newOperations New operations block.
 */
export function replaceServiceOperations(text: string, serviceName: string, newOperations: string) {
  const exp = new RegExp(`service ${serviceName} {\n((.|\n)*)\n}\n`);
  return text.replace(exp, `service ${serviceName} {\n${newOperations}\n}\n`);
}

// From openapi3
// FIXME: need to update library to export this type
type OpenAPI3ServiceRecord = Awaited<ReturnType<typeof getOpenAPI3>>[number];
type OpenAPI3Document = Extract<OpenAPI3ServiceRecord, { versioned: false }>['document'];
type OpenAPI3PathItem = OpenAPI3Document['paths'][string];
type OpenAPI3Operation = Required<OpenAPI3PathItem>['get'];
/**
 * Get document form OpenAPI3ServiceRecord.
 */
export function getDocument(serviceRecord: OpenAPI3ServiceRecord): OpenAPI3Document {
  if (serviceRecord.versioned) {
    return serviceRecord.versions[0].document;
  }

  return serviceRecord.document;
}

type GetPathResult =
  | {
      result: true;
      path: string;
      method: string;
      operation: OpenAPI3Operation;
    }
  | {
      result: false;
      path: undefined;
      method: undefined;
      operation: undefined;
    };

/**
 * Get path from OpenAPI3Document.
 * @param paths
 * @param interfaceName
 * @param operationName
 * @returns
 */
export function getPath(paths: OpenAPI3Document['paths'], interfaceName: string, operationName: string): GetPathResult {
  let result: GetPathResult = {
    result: false,
    path: undefined,
    method: undefined,
    operation: undefined,
  };
  for (const key in paths) {
    if (Object.prototype.hasOwnProperty.call(paths, key)) {
      const element = paths[key];
      (['get', 'post', 'put', 'delete', 'patch'] as const).forEach((method) => {
        if (element[method]?.operationId === `${interfaceName}_${operationName}`) {
          result = {
            result: true,
            path: key,
            method,
            operation: element[method] as OpenAPI3Operation,
          };
        }
      });
    }
  }

  return result;
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
export function getOpetionContents(path: string, method: string, operation: OpenAPI3Operation): string {
  if (method === 'get') {
    return `      get: "${path}"\n`;
  }
  if (method === 'post') {
    // Map required fields to body
    if (
      operation.parameters.length > 0 &&
      operation.requestBody &&
      operation.requestBody.content &&
      operation.requestBody.content['application/json'] &&
      operation.requestBody.content['application/json'].schema &&
      operation.requestBody.content['application/json'].schema.required &&
      Array.isArray(operation.requestBody.content['application/json'].schema.required)
    ) {
      const required: string[] = operation.requestBody.content['application/json'].schema.required;
      // TODO: if required count > 1, to error.
      return `      post: "${path}"\n` + `      body: "${required.join()}"\n`;
    }
    // TODO: support custom response_body
    return `      post: "${path}"\n` + `      body: "*"\n`;
  }
  if (method === 'put') {
    return `      put: "${path}"\n` + `      body: "*"\n`;
  }
  if (method === 'patch') {
    return `      patch: "${path}"\n` + `      body: "*"\n`;
  }
  if (method === 'delete') {
    return `      delete: "${path}"\n`;
  }
  return '';
}

/**
 * Simple utility function to capitalize a string.
 */
export function capitalize<S extends string>(s: S) {
  return (s.slice(0, 1).toUpperCase() + s.slice(1)) as Capitalize<S>;
}
