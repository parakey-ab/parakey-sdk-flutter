#!/bin/bash
# Updates Flutter adapter version and native SDK versions in preparation for github release

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

PACKAGE='packages/parakey_sdk_flutter'

replace_version() {
  local file=$1
  local query=$2
  local new_version=$3

  sed -i '' "/$query/s/[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/$new_version/" "$file"

  if ! [ $? -eq 0 ]; then
    echo "Couldn't update $file_path"
    exit 1
  fi
}

read_flutter_version
read_android_version
read_ios_version

replace_version 'README.md' 'ref:' $flutter_version
replace_version "$PACKAGE/pubspec.yaml" '^version:' $flutter_version

replace_version "$PACKAGE/android/build.gradle.kts" 'co.parakey:' $android_version

replace_version "$PACKAGE/ios/parakey_sdk_flutter/Package.swift" 'parakey-ab' $ios_version

replace_version 'scripts/generate_test_project.sh' 'ref:' $flutter_version

echo_green "All files updated"

echo -e ""
echo_yellow "Make sure to run 'flutter build ios --config-only' in '$PACKAGE/example' to update all lock files"
echo -e "Once pushed, create github release with version: $flutter_version"
