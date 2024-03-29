#!/bin/sh

# curl -sL https://github.com/cc332030/gradle/raw/master/docker/build-push.sh | sh

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

echo "
IMAGE: ${IMAGE}"

IMAGE_WITH_TAG=${IMAGE}:latest
IMAGE_BUILD_CACHE=${IMAGE}:buildcache

if [ "${JAVA_VERSION}" ]; then
  echo "JAVA_VERSION: ${JAVA_VERSION}"
  BUILD_ARGS="${BUILD_ARGS} --build-arg JAVA_VERSION=${JAVA_VERSION}"
fi
if [ "${BUILD_COMMAND}" ]; then
  echo "BUILD_COMMAND: ${BUILD_COMMAND}"
  BUILD_ARGS="${BUILD_ARGS} --build-arg BUILD_COMMAND=\"${BUILD_COMMAND}\""
fi
if [ "${BOOT_JAR_PATH}" ]; then
  echo "BOOT_JAR_PATH: ${BOOT_JAR_PATH}"
  BUILD_ARGS="${BUILD_ARGS} --build-arg BOOT_JAR_PATH=\"${BOOT_JAR_PATH}\""
fi

curl -sLO https://github.com/cc332030/gradle/raw/master/docker/dockerfile

docker login -u="${AUTHOR}" -p="${DOCKER_TOKEN}"

BUILDX_NAME=buildx-c332030

docker buildx rm "${BUILDX_NAME}" || true
docker buildx create --name "${BUILDX_NAME}" --driver docker-container --use
docker buildx build \
  ${BUILD_ARGS} \
  --cache-from type=registry,ref="${IMAGE_BUILD_CACHE}" \
  --cache-to type=registry,ref="${IMAGE_BUILD_CACHE}",mode=max \
  --tag "${IMAGE_WITH_TAG}" \
  --push .
