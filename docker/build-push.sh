@echo off

set -e

source .env

if [ ! "${PROJECT}" ]; then
  echo "no PROJECT"
  exit 0
fi

if [ ! "${AUTHOR}" ]; then
  echo "no AUTHOR"
  exit 0
fi

if [ ! "${DOCKER_PASSWORD}" ]; then
  echo "no DOCKER_PASSWORD"
  exit 0
fi

REGISTRY="${REGISTRY:=docker.io}"

IMAGE=${REGISTRY}/${AUTHOR}/${PROJECT}
IMAGE_WITH_TAG=${IMAGE}:latest
IMAGE_BUILD_CACHE=${IMAGE}:buildcache

curl -O https://github.com/cc332030/gradle/raw/master/docker/dockerfile
docker build . \
  --cache-from type=registry,ref="${IMAGE_BUILD_CACHE}" \
  --cache-to type=registry,ref="${IMAGE_BUILD_CACHE}",mode=max \
  --build-arg \
    JAVA_VERSION="${JAVA_VERSION}" \
    BOOT_COMMAND="${BOOT_COMMAND}" \
    BOOT_JAR_PATH="${BOOT_JAR_PATH}" \
  --tag "${IMAGE_WITH_TAG}"

docker login -u="${AUTHOR}" -p="${DOCKER_PASSWORD}"
docker push "${IMAGE_WITH_TAG}"
