import { createTypeSpecLibrary } from '@typespec/compiler';

export const $lib = createTypeSpecLibrary({
  name: '@fox-hound-tools/protobuf-grpc-json-transcoding',
  diagnostics: {},
  requireImports: ['@typespec/protobuf', '@typespec/http'],
});

export const { reportDiagnostic, createDiagnostic } = $lib;
