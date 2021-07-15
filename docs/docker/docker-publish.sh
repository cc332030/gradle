#!/usr/bin/env bash

set -e

docker run --rm \
  \
  --privileged=true \
  \
  -v /etc/localtime:/etc/localtime \
  \
  -v /home:/home \
  -v /home/program/gradle:/gradle \
  \
  -e git_url:"$1" \
  \
  adoptopenjdk/openjdk11-openj9 \
  /gradle/publish
