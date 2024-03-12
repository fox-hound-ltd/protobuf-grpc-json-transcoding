import { EmitContext, resolvePath } from '@typespec/compiler';
import { getOpenAPI3 } from '@typespec/openapi3';
import { $onEmit as protobuf$onEmit } from '@typespec/protobuf';
import fs from 'fs';
import { fileURLToPath } from 'url';

import {
  capitalize,
  exsitsFile,
  getDocument,
  getFilePathAndName,
  getOpetionContents,
  getPath,
  getServiceOperations,
  hasBothServiceAndPackageDecorators,
  replaceServiceOperations,
} from './util.js';

export async function $onEmit(context: EmitContext) {
  if (!context.program.compilerOptions.noEmit) {
    let generateGoogleApiProto = false;
    // Generate Protobuf
    await protobuf$onEmit(context);
    // 命名規則をそれぞれ確認して合致させる
    const openapi3 = await getOpenAPI3(context.program);
    for (const key in openapi3) {
      if (Object.prototype.hasOwnProperty.call(openapi3, key)) {
        const namespace = openapi3[key].service.type;
        if (hasBothServiceAndPackageDecorators(namespace)) {
          const [filePath, fileName] = getFilePathAndName(namespace);
          const targetFile = resolvePath(context.emitterOutputDir, filePath, fileName);
          if (await exsitsFile(context.program, targetFile)) {
            // Get the openapi3 document
            const document = getDocument(openapi3[key]);
            const paths = document.paths;
            let text = (await context.program.host.readFile(targetFile)).text;
            let addImportGoogleApiAnnotationsLine = false;
            // Add `option (google.api.http)` to the file
            namespace.interfaces.forEach((i) => {
              // Get service from interface block
              let operations = getServiceOperations(text, i.name);
              i.operations.forEach((o) => {
                // Get operation name
                const operationName = o.name;
                // Replace the rpc block
                const exp = new RegExp(` {2}rpc ${capitalize(operationName)}\\((.*)\\) returns \\((.*)\\);`, 'm');
                const result = exp.exec(operations);
                if (result) {
                  const [, req, res] = result;
                  const path = getPath(paths, i.name, operationName);
                  if (path.result) {
                    const newText =
                      `  rpc ${capitalize(operationName)}(${req}) returns (${res}) {\n` +
                      `    option (google.api.http) = {\n` +
                      getOpetionContents(path.path, path.method, path.operation) +
                      `    };\n` +
                      `  }`;
                    generateGoogleApiProto = true;
                    operations = operations.replace(exp, newText);
                    addImportGoogleApiAnnotationsLine = true;
                  }
                }
              });
              text = replaceServiceOperations(text, i.name, operations);
            });
            if (addImportGoogleApiAnnotationsLine) {
              // Add `import google/api/annotations.proto` to the file
              text = applyImportGoogleApi(text);
            }
            context.program.host.writeFile(targetFile, text);
          }
        }
      }
    }

    if (generateGoogleApiProto) {
      // Generate Google API Proto
      await applyGoogleApiProto(context);
    }
  }
}

/**
 * Add `import google/api/annotations.proto` to the file
 * @param text
 */
function applyImportGoogleApi(text: string) {
  const exp = new RegExp(/package (.*);\n/);
  const exsitsAnotherImport = /import "google\/protobuf\/.*\.proto";/.test(text);
  return text.replace(exp, `$&\nimport "google/api/annotations.proto";${exsitsAnotherImport ? '' : '\n'}`);
}

/**
 * Apply Google API Proto
 * - annotations.proto
 * - http.proto
 */
async function applyGoogleApiProto(context: EmitContext) {
  // Generate directly
  await context.program.host.mkdirp(resolvePath(context.emitterOutputDir, 'google/api'));
  const httpProto = fs.readFileSync(resolvePath(fileURLToPath(import.meta.url), '../../../', 'google/api/http.proto'), {
    encoding: 'utf-8',
  });
  context.program.host.writeFile(
    resolvePath(context.emitterOutputDir, 'google/api/http.proto'),
    `// Generated by Microsoft TypeSpec` + '\n' + httpProto,
  );
  const annotationsProto = fs.readFileSync(
    resolvePath(fileURLToPath(import.meta.url), '../../../', 'google/api/annotations.proto'),
    {
      encoding: 'utf-8',
    },
  );
  context.program.host.writeFile(
    resolvePath(context.emitterOutputDir, 'google/api/annotations.proto'),
    `// Generated by Microsoft TypeSpec` + '\n' + annotationsProto,
  );
}
