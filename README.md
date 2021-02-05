# docker-php80-fpm

A PHP 8.0 based Docker base image.

[![Build Docker images](https://github.com/Ilyes512/docker-php80-fpm/workflows/Build%20Docker%20images/badge.svg)](https://github.com/Ilyes512/docker-php80-fpm/actions?query=workflow%3A%22Build+Docker+images%22)

## Pulling the images

```
docker pull ilyes512/php80-fpm:builder-latest
docker pull ilyes512/php80-fpm:runtime-latest
docker pull ilyes512/php80-fpm:vscode-latest
```

The tag scheme: `{TARGET}-{VERSION}`

- **{TARGET}**: `runtime`, `builder` or `vscode`
- **{VERSION}**: `latest` or tag i.e. `1.0.0`

## Building the docker image(s)

There are 2 targets at the moment:

  - **runtime**: this is for *production*. It does not contain any development tools like Composer and Xdebug.
  - **builder**: this is for *development*. This is based on the runtime-target and it adds Composer, Xdebug etc.
  - **vscode**: this is for *development* using
  [VS Code Remote](https://code.visualstudio.com/docs/remote/remote-overview). This is based on the builder-target
  and adds some VS Code deps.

Building runtime-target:

```
docker build --tag ilyes512/php80-fpm:runtime-latest --target runtime .
```

Building builder-target:

```
docker build --tag ilyes512/php80-fpm:builder-latest --target builder .
```

Building vscode-target:

```
docker build --tag ilyes512/php80-fpm:vscode-latest --target vscode .
```

## Task commands

Available [Task](https://taskfile.dev/#/) commands:

```
task: Available tasks for this project:

* d:build:      Build all PHP Docker image targets
* d:lint:       Apply a Dockerfile linter (https://github.com/hadolint/hadolint)
```
