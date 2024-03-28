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

if [ "${JAVA_VERSION}" ]; then
  BUILD_ARGS="${BUILD_ARGS} --build-arg JAVA_VERSION=${JAVA_VERSION}"
fi
if [ "${BUILD_COMMAND}" ]; then
  BUILD_ARGS="${BUILD_ARGS} --build-arg BUILD_COMMAND=\"${BUILD_COMMAND}\""
fi
if [ "${BOOT_JAR_PATH}" ]; then
  BUILD_ARGS="${BUILD_ARGS} --build-arg BOOT_JAR_PATH=\"${BOOT_JAR_PATH}\""
fi

curl -sLO https://github.com/cc332030/gradle/raw/master/docker/dockerfile

docker login -u="${AUTHOR}" -p="${DOCKER_TOKEN}"

docker buildx rm docker-container || true
docker buildx create --name docker-container --driver docker-container --use
docker buildx build \
  ${BUILD_ARGS} \
  --cache-from type=registry,ref="${IMAGE_BUILD_CACHE}" \
  --cache-to type=registry,ref="${IMAGE_BUILD_CACHE}",mode=max \
  --tag "${IMAGE_WITH_TAG}" \
  --push .
