#!/bin/sh

echo 'clean-gradle'

set -e

if [ ! "$SSH_PRIVATE_KEY" ]; then
  echo SSH_PRIVATE_KEY not exists
  exit 1
fi

user=$(whoami)

echo "user: $user"
echo "home:" ~

if [ "root" = "$user" ]
then
  USER_HOME=/root
else
  USER_HOME=/home/$user
fi

GRADLE_USER_HOME=$USER_HOME/.gradle
echo "GRADLE_USER_HOME: $GRADLE_USER_HOME"

echo "clean GRADLE_USER_HOME: $GRADLE_USER_HOME"
ls -lh "$GRADLE_USER_HOME"
rm -rf "$GRADLE_USER_HOME"

if [ ! ~ = "$USER_HOME" ]
then
  echo "clean ~/.gradle"
  ls -lh ~/.gradle
  rm -rf ~/.gradle
fi

echo 'clean-gradle successfully'
