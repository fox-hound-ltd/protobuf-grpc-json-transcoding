import { JSONSchemaType, createTypeSpecLibrary } from '@typespec/compiler';

/**
 * Options that the Protobuf emitter accepts.
 *
 * Copy from @typespec/protobuf/src/lib.ts
 */
interface ProtobufEmitterOptions {
  /**
   * Don't emit anything.
   */
  'noEmit'?: boolean;

  /**
   * Omit unreachable types.
   *
   * By default, types under a package namespace will be emitted if they are fully annotated with `@field` decorators.
   * With this flag on, only types that are explicitly marked with `@message` or that are referenced by an operation
   * in an interface decoarated with `@service` will be emitted.
   */
  'omit-unreachable-types'?: boolean;
}

const EmitterOptionsSchema: JSONSchemaType<ProtobufEmitterOptions> = {
  type: 'object',
  additionalProperties: false,
  properties: {
    'noEmit': {
      type: 'boolean',
      nullable: true,
      description:
        'If set to `true`, this emitter will not write any files. It will still validate the TypeSpec sources to ensure they are compatible with Protobuf, but the files will simply not be written to the output directory.',
    },
    'omit-unreachable-types': {
      type: 'boolean',
      nullable: true,
      description:
        'By default, the emitter will create `message` declarations for any models in a namespace decorated with `@package` that have an `@field` decorator on every property. If this option is set to true, this behavior will be disabled, and only messages that are explicitly decorated with `@message` or that are reachable from a service operation will be emitted.',
    },
  },
  required: [],
};

/**
 * Represents a type specification library for protobuf-grpc-json-transcoding.
 * @name @fox-hound-tools/protobuf-grpc-json-transcoding
 * @requires @typespec/protobuf
 * @requires @typespec/http
 */
export const $lib = createTypeSpecLibrary({
  name: '@fox-hound-tools/protobuf-grpc-json-transcoding',
  diagnostics: {},
  requireImports: ['@typespec/protobuf', '@typespec/http'],
  emitter: {
    options: EmitterOptionsSchema,
  },
});

export const { reportDiagnostic, createDiagnostic } = $lib;
