#!/usr/bin/env bash

set -e

ln -s /home/.gnupg ~/.gnupg
ln -s /home/.gradle ~/.gradle

cp -r /home/.ssh ~/.ssh
chmod -R 700 ~/.ssh

# shellcheck disable=SC2154
echo "git_url: ${git_url}"

work_dir=/tmp/gradle
echo "work_dir: ${work_dir}"

cd "${work_dir}"

git clone --depth=1 "${git_url}" source

cd source
chmod +x gradlew

./gradlew publish
