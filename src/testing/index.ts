import { resolvePath } from '@typespec/compiler';
import { TypeSpecTestLibrary, createTestLibrary } from '@typespec/compiler/testing';
import { fileURLToPath } from 'url';

export const ProtobufGrpcJsonTranscodingTestLibrary: TypeSpecTestLibrary = createTestLibrary({
  name: '@fox-hound-tools/protobuf-grpc-json-transcoding',
  packageRoot: resolvePath(fileURLToPath(import.meta.url), '../../../'),
});
