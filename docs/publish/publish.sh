#!/bin/sh

set -e

#git_url=git@github.com:cc332030/c-commons-java.git
#branch=main
git_url="$1"
branch="$2"

# shellcheck disable=SC2154
echo "git_url: ${url}, branch: ${branch}"

work_dir="/tmp/gradle/$(date +%N)"
echo "work_dir: ${work_dir}"

mkdir -p "${work_dir}"

git clone --depth=1 "${git_url}" -b "${branch}" "${work_dir}"

image=adoptopenjdk/openjdk11-openj9:alpine

docker pull "${image}"
docker image prune -f

docker run --rm \
  \
  --privileged=true \
  \
  -v /etc/localtime:/etc/localtime \
  \
  -v /home:/root \
  -v "${work_dir}":/gradle \
  \
  -w /gradle \
  \
  "${image}" \
  chmod +x gradlew && ./gradlew publish

rm -rf "${work_dir}"
