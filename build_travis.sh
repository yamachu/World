#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
  make mac_shared
else
  make linux_shared
fi