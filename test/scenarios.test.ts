import fs from 'fs';
import { describe, expect, it } from 'vitest';

import { emit } from './test-host.js';

describe('scenarios', () => {
  it('emit addressbook', async () => {
    const results = await emit(
      fs.readFileSync(__dirname + '/scenarios/addressbook/input/main.tsp', { encoding: 'utf-8' }),
      {
        autoUsing: false,
      },
    );
    expect(results['addressbook.proto']).toBeDefined();
    expect(results['addressbook.proto']).toEqual(
      fs.readFileSync(__dirname + '/scenarios/addressbook/expected/addressbook.proto', { encoding: 'utf-8' }),
    );
  });
  it(`emit widget from typespec official demo`, async () => {
    const results = await emit(fs.readFileSync(__dirname + '/scenarios/widget/input/main.tsp', { encoding: 'utf-8' }), {
      autoUsing: false,
    });
    expect(results['widget.proto']).toBeDefined();
    expect(results['widget.proto']).toEqual(
      fs.readFileSync(__dirname + '/scenarios/widget/expected/widget.proto', { encoding: 'utf-8' }),
    );
  });
  it(`emit multiple service`, async () => {
    await fileTest('multiple');
  });
  it(`emit no interface`, async () => {
    await fileTest('no-interface');
  });
  it(`emit multi params binding route`, async () => {
    await fileTest('multi-params-binding-route');
  });
  it(`emit custom request body`, async () => {
    await fileTest('custom-request-body');
  });
});

/**
 * Testing with fixed paths and file names
 */
async function fileTest(path: string) {
  const results = await emit(fs.readFileSync(__dirname + `/scenarios/${path}/input/main.tsp`, { encoding: 'utf-8' }), {
    autoUsing: false,
  });
  expect(results['main.proto']).toBeDefined();
  expect(results['main.proto']).toEqual(
    fs.readFileSync(__dirname + `/scenarios/${path}/expected/main.proto`, { encoding: 'utf-8' }),
  );
}
