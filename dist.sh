#!/bin/bash

UPDATE_BINARY_URL="https://raw.githubusercontent.com/topjohnwu/Magisk/master/scripts/module_installer.sh"

mkdir -p ./module/META-INF/com/google/android
curl "${UPDATE_BINARY_URL}" > ./module/META-INF/com/google/android/update-binary
echo "#MAGISK" > ./module/META-INF/com/google/android/updater-script

VERSION=$(sed -ne "s/version=\(.*\)/\1/gp" ./module/module.prop)
NAME=$(sed -ne "s/id=\(.*\)/\1/gp" ./module/module.prop)
ZIP_FILENAME="${NAME}-${VERSION}.zip"

mkdir -p ./dist

rm -f ./dist/${ZIP_FILENAME}
(
  cd ./module
  zip ../dist/${ZIP_FILENAME} -r * -x ".*" "*/.*"
)

RELEASE_URL="https://github.com/Loukious/Custom-Certificate-Authorities/releases/download/${VERSION}/${ZIP_FILENAME}"
CHANGELOG_URL="https://raw.githubusercontent.com/Loukious/Custom-Certificate-Authorities/master/CHANGELOG.md"

echo "{
    \"version\": \"${VERSION}\",
    \"versionCode\": ${VERSION//[^0-9]/},
    \"zipUrl\": \"${RELEASE_URL}\",
    \"changelog\": \"${CHANGELOG_URL}\"
}" > ./dist/updateJson.json