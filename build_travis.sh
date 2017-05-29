#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
  make mac_shared
else
  make linux_shared CXX=$CXX CXXFLAGS="${CXXFLAGS}" LDFLAGS="$LDFLAGS"
  mv build/libworld.so build/${_ARCHNAME_}libworld.so
fi
