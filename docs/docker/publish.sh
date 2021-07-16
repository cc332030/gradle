#!/bin/sh

set -e

#git_url=git@github.com:cc332030/c-commons-java.git
git_url="$1"
branch="$2"

# shellcheck disable=SC2154
echo "git_url: ${git_url} -b ${branch}"

work_dir="/tmp/gradle/$(date +%N)"
echo "work_dir: ${work_dir}"

mkdir -p "${work_dir}"
cd "${work_dir}"

git clone --depth=1 "${git_url}" .

chmod +x gradlew
./gradlew publish

rm -rf "${work_dir}"
