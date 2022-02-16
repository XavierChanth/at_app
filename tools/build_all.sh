#!/bin/bash
TOOL_PATH="${BASH_SOURCE%/*}"

# cd to project root
cd "$TOOL_PATH/.." || exit 1

# Run the builds without format and analuze
dart pub global run melos run build:at_template -- --no-format <<< n;
dart pub global run melos run build:templates -- --no-format  <<< n;
dart pub global run melos run build:generated <<< n;

# Format and analyze manually, so that the output appears at the end
dart format -l 120 packages/at_template/
dart format -l 120 packages/at_app/

dart analyze packages/at_template/
dart analyze packages/at_app/
