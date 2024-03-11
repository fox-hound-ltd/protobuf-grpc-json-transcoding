import { resolvePath } from '@typespec/compiler';
import { describe, expect, it } from 'vitest';

import { exsitsFile } from '../src/util.js';
import { createProtobufGrpcJsonTranscodingTestRunner } from './test-host.js';

describe('exsitsFile', () => {
  it('exsits file', async () => {
    const runner = await createProtobufGrpcJsonTranscodingTestRunner();
    await runner.compile('', {
      outputDir: 'tsp-output',
    });
    await runner.program.host.writeFile(resolvePath('tsp-output', 'test.proto'), 'test');
    expect(await exsitsFile(runner.program, 'tsp-output/test.proto')).toBeTruthy();
  });
  it('not exsits file', async () => {
    const runner = await createProtobufGrpcJsonTranscodingTestRunner();
    await runner.compile('', {
      outputDir: 'tsp-output',
    });
    expect(await exsitsFile(runner.program, 'tsp-output/test.proto')).toBeFalsy();
  });
  it('exsits multi level file', async () => {
    const runner = await createProtobufGrpcJsonTranscodingTestRunner();
    await runner.compile('', {
      outputDir: 'tsp-output',
    });
    await runner.program.host.writeFile(resolvePath('tsp-output', 'test', 'test.proto'), 'test');
    expect(await exsitsFile(runner.program, 'tsp-output/test/test.proto')).toBeTruthy();
  });
});
