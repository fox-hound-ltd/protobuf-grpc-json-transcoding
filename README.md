# @fox-hound-tools/protobuf-grpc-json-transcoding

[![npm version](https://img.shields.io/npm/v/@fox-hound-tools/protobuf-grpc-json-transcoding.svg)](https://www.npmjs.com/package/@fox-hound-tools/protobuf-grpc-json-transcoding)
[![npm publish workflow](https://github.com/fox-hound-ltd/protobuf-grpc-json-transcoding/actions/workflows/npm-publish.yaml/badge.svg)](https://github.com/fox-hound-ltd/protobuf-grpc-json-transcoding/actions/workflows/npm-publish.yaml)
[![build and test workflow](https://github.com/fox-hound-ltd/protobuf-grpc-json-transcoding/actions/workflows/test.yaml/badge.svg)](https://github.com/fox-hound-ltd/protobuf-grpc-json-transcoding/actions/workflows/test.yaml)

# Development

## 1. Install dependencies

```bash
pnpm install
```

## 2. Build

```bash
pnpm run build
```

## 3. Test

```bash
pnpm test
```

# Sample

## 1. Generate protofiles from typespec

```bash
pnpm run sample:generate
```

## 2. Run server

```bash
dotnet run --project sample/Server
```

## 3. Access to the server

http://localhost:5000
