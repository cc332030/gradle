#!/bin/sh

set -e

if test -f ".env"; then
  . ./.env
fi

if [ ! "${PROJECT}" ]; then
  echo "no PROJECT"
  exit 0
fi

if [ ! "${AUTHOR}" ]; then
  echo "no AUTHOR"
  exit 0
fi

if [ ! "${DOCKER_TOKEN}" ]; then
  echo "no DOCKER_TOKEN"
  exit 0
fi

REGISTRY="${REGISTRY:=docker.io}"

IMAGE=${REGISTRY}/${AUTHOR}/${PROJECT}
IMAGE_WITH_TAG=${IMAGE}:latest
IMAGE_BUILD_CACHE=${IMAGE}:buildcache

curl -sLO https://github.com/cc332030/gradle/raw/master/docker/dockerfile

docker login -u="${AUTHOR}" -p="${DOCKER_TOKEN}"

docker buildx rm multiarch || true
docker buildx create --name multiarch --driver docker-container --use
docker buildx build \
  --build-arg JAVA_VERSION="${JAVA_VERSION}" \
  --build-arg BOOT_COMMAND="${BOOT_COMMAND}" \
  --build-arg BOOT_JAR_PATH="${BOOT_JAR_PATH}" \
  --cache-from type=registry,ref="${IMAGE_BUILD_CACHE}" \
  --cache-to type=registry,ref="${IMAGE_BUILD_CACHE}",mode=max \
  --tag "${IMAGE_WITH_TAG}" \
  --push .
