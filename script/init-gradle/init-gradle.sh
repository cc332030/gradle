#!/bin/sh

set -e

echo 'init-gradle'

WORK_PATH=~/.gradle
mkdir -p "$WORK_PATH"

echo "~"
echo ~

echo "ls -alh ~"
ls -alh ~

echo "WORK_PATH: $WORK_PATH"

GRADLE_PROPERTIES=gradle.properties
GRADLE_PROPERTIES_PATH=$WORK_PATH/$GRADLE_PROPERTIES

echo "

org.gradle.java.installations.auto-detect=false

repoSnapshotSonatype=https://oss.sonatype.org/content/repositories/snapshots
repoReleaseSonatype=https://oss.sonatype.org/service/local/repositories/releases/content/
repoStageSonatype=https://oss.sonatype.org/service/local/staging/deploy/maven2

signing.keyId=$GPG_SIGN_KEY
signing.password=$GPG_PASSWORD
signing.secretKeyRingFile=$USER_HOME/.gnupg/secring.gpg

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

user=$(whoami)
if [ "root" = "$user" ]
then
  USER_HOME=/root
else
  USER_HOME=/home/$user
fi

if [ ! ~ = "$USER_HOME" ]
then
  ln -s $WORK_PATH "$USER_HOME"
fi

echo "ls -alh ~/.gradle"
ls -alh ~/.gradle

echo "ls -alh /root"
ls -alh /root

echo "ls -alh /root/.gradle"
ls -alh /root/.gradle

echo 'init-gradle successfully'
