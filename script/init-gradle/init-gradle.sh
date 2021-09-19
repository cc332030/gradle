#!/bin/sh

set -e

GRADLE_USER_HOME=$(eval echo ~$USER)/.gradle

echo
echo "GRADLE_USER_HOME: $GRADLE_USER_HOME"

mkdir -p "$GRADLE_USER_HOME"

GRADLE_PROPERTIES=gradle.properties
GRADLE_PROPERTIES_PATH=$GRADLE_USER_HOME/$GRADLE_PROPERTIES

echo "

org.gradle.java.installations.auto-detect=false

repoSnapshotSonatype=https://oss.sonatype.org/content/repositories/snapshots
repoReleaseSonatype=https://oss.sonatype.org/service/local/repositories/releases/content/
repoStageSonatype=https://oss.sonatype.org/service/local/staging/deploy/maven2

signing.keyId=$GPG_SIGN_KEY
signing.password=$GPG_PASSWORD
signing.secretKeyRingFile=$(echo ~)/.gnupg/secring.gpg

ossrhUsername=$OSSRH_USERNAME
ossrhPassword=$OSSRH_PASSWORD
" > "$GRADLE_PROPERTIES_PATH"

## gradle parallel
if [ -f $GRADLE_PROPERTIES ]; then

  SNAPSHOT=$(cat "$GRADLE_PROPERTIES" | grep version= | grep '\-SNAPSHOT' | cut -d = -f 2)
  if [ "$SNAPSHOT" ]; then
    echo
    echo "SNAPSHOT: $SNAPSHOT"
    echo "org.gradle.parallel=true" >> "$GRADLE_PROPERTIES_PATH"
  fi
fi
