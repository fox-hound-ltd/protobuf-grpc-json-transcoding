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
    const results = await emit(
      fs.readFileSync(__dirname + '/scenarios/multiple/input/main.tsp', { encoding: 'utf-8' }),
      {
        autoUsing: false,
      },
    );
    expect(results['multiple.proto']).toBeDefined();
    expect(results['multiple.proto']).toEqual(
      fs.readFileSync(__dirname + '/scenarios/multiple/expected/multiple.proto', { encoding: 'utf-8' }),
    );
  });
  it(`emit no interface`, async () => {
    const results = await emit(
      fs.readFileSync(__dirname + '/scenarios/no-interface/input/main.tsp', { encoding: 'utf-8' }),
      {
        autoUsing: false,
      },
    );
    expect(results['main.proto']).toBeDefined();
    expect(results['main.proto']).toEqual(
      fs.readFileSync(__dirname + '/scenarios/no-interface/expected/main.proto', { encoding: 'utf-8' }),
    );
  });
});
