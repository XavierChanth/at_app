<img src="https://atsign.dev/assets/img/@dev.png?sanitize=true">

### Now for a little internet optimism

# Contributing guidelines

Please also review the [general contributing guidelines](../CONTRIBUTING.md).

## Development Environment Setup

### Prerequisites

When developing the cli tool activate using the local path:

```sh
flutter pub global activate -s path [path-to-repo]
```

When running the create command use the local flag to build at_app from the path:

```sh
flutter pub global run at_app create --local [...options] \<output directory\>
```

### Publishing the project

First build the project:

```sh
dart run build_runner build
```

Then verify with a dry run of the publish:

```sh
flutter pub publish --dry-run
```

If all is well, publish:

```sh
flutter pub publish
```
