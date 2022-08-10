#!/bin/sh

set -e

echo 'init-gradle'

WORK_PATH=~/.gradle
echo "WORK_PATH: ${WORK_PATH}"

mkdir -p "$WORK_PATH"

GRADLE_PROPERTIES=gradle.properties
GRADLE_PROPERTIES_PATH=$WORK_PATH/$GRADLE_PROPERTIES

GPG_HOME=~/.gnupg

echo "

org.gradle.daemon=false

org.gradle.java.installations.auto-detect=false

repoSnapshotSonatype=https://oss.sonatype.org/content/repositories/snapshots
repoReleaseSonatype=https://oss.sonatype.org/service/local/repositories/releases/content/
repoStageSonatype=https://oss.sonatype.org/service/local/staging/deploy/maven2

# PgpSignatory, RSA only
signing.keyId=$GPG_SIGN_KEY
signing.password=$GPG_PASSWORD
signing.secretKeyRingFile=$GPG_HOME/secring.gpg

# use gpg agent, useGpgCmd() GnupgSignatory, ECC & RSA
signing.gnupg.executable=gpg
signing.gnupg.homeDir=$GPG_HOME
signing.gnupg.keyName=$GPG_SIGN_KEY
signing.gnupg.passphrase=$GPG_PASSWORD

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
echo "USER_HOME: ${USER_HOME}"

if [ ! ~ = "$USER_HOME" ]
then
  ln -s $WORK_PATH "$USER_HOME"
fi

echo 'init-gradle successfully'
