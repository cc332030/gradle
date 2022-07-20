#!/bin/sh

echo 'init-gradle-clean'

set -e

ls -alh ~/.gradle

rm -rf ~/.gradle/gradle.properties

ls -alh ~/.gradle

echo 'init-gradle-clean successfully'
