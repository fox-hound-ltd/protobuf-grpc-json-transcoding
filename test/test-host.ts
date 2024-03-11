import { Diagnostic, resolvePath } from '@typespec/compiler';
import {
  BasicTestRunner,
  createTestHost,
  createTestLibrary,
  createTestWrapper,
  expectDiagnosticEmpty,
  findTestPackageRoot,
} from '@typespec/compiler/testing';
import { namespace as httpNamespace } from '@typespec/http';
import { HttpTestLibrary } from '@typespec/http/testing';
import { namespace as protobufNamespace } from '@typespec/protobuf';

import { ProtobufGrpcJsonTranscodingTestLibrary } from '../src/testing/index.js';

interface TestEmitOptions {
  autoUsing: boolean;
}

export async function createProtobufGrpcJsonTranscodingTestHost() {
  return createTestHost({
    libraries: [
      ProtobufGrpcJsonTranscodingTestLibrary,
      createTestLibrary({
        name: '@typespec/protobuf',
        packageRoot: resolvePath(await findTestPackageRoot(import.meta.url), 'node_modules', '@typespec/protobuf'),
      }),
      HttpTestLibrary,
    ],
  });
}

export async function createProtobufGrpcJsonTranscodingTestRunner(options: TestEmitOptions = { autoUsing: true }) {
  const host = await createProtobufGrpcJsonTranscodingTestHost();

  return createTestWrapper(host, {
    compilerOptions: {
      noEmit: false,
      emit: ['@fox-hound-tools/protobuf-grpc-json-transcoding'],
    },
    autoUsings: options.autoUsing ? [protobufNamespace, httpNamespace] : [],
  });
}

const emitterOutputDir = './tsp-output/@fox-hound-tools/protobuf-grpc-json-transcoding';
export async function emitWithDiagnostics(
  code: string,
  options: TestEmitOptions,
): Promise<[Record<string, string>, readonly Diagnostic[]]> {
  const runner = await createProtobufGrpcJsonTranscodingTestRunner(options);
  await runner.compileAndDiagnose(code, {
    outputDir: 'tsp-output',
  });
  const result: Record<string, string> = await readDirRecursive(runner);
  return [result, runner.program.diagnostics];
}

async function readDirRecursive(runner: BasicTestRunner, dir: string = ''): Promise<Record<string, string>> {
  const result: Record<string, string> = {};
  const files = await runner.program.host.readDir(resolvePath(emitterOutputDir, dir));
  for (const file of files) {
    const path = resolvePath(dir, file);
    if ((await runner.program.host.stat(resolvePath(emitterOutputDir, path))).isFile()) {
      result[path] = (await runner.program.host.readFile(resolvePath(emitterOutputDir, path))).text;
    } else {
      Object.assign(result, await readDirRecursive(runner, path));
    }
  }
  return result;
}

export async function emit(
  code: string,
  options: TestEmitOptions = { autoUsing: true },
): Promise<Record<string, string>> {
  const [result, diagnostics] = await emitWithDiagnostics(code, options);
  expectDiagnosticEmpty(diagnostics);
  return result;
}
