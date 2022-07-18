#!/bin/sh

echo 'clean-gradle'

set -e

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
  CLEAN_PATH=~/.gradle
  echo "clean $CLEAN_PATH"
  ls -lh $CLEAN_PATH
  rm -rf $CLEAN_PATH
fi

echo 'clean-gradle successfully'
