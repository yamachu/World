#!/bin/sh

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
  echo "OSX build"

  my_python=$(which python3.5)
  ${my_python:=python3} version_replace.py

  make mac_shared
  make clean
  export CXX=`xcrun --sdk iphoneos -f clang++`
  export AR=`xcrun --sdk iphoneos -f ar`
  export RANLIB=`xcrun --sdk iphoneos -f ranlib`
  echo "iOS build"
  make ios_static CXX=$CXX AR=$AR RANLIB=$RANLIB CXXFLAGS="-O1 -Wall -fPIC -isysroot `xcrun --sdk iphonesimulator --show-sdk-path` -arch x86_64 -miphoneos-version-min=7.0"
  mv build/ios_libworld.a build/x86_64_ios_libworld.a
  make clean
  make ios_static CXX=$CXX AR=$AR RANLIB=$RANLIB CXXFLAGS="-O1 -Wall -fPIC -isysroot `xcrun --sdk iphonesimulator --show-sdk-path` -arch i386 -miphoneos-version-min=7.0"
  mv build/ios_libworld.a build/i386_ios_libworld.a
  make clean
  make ios_static CXX=$CXX AR=$AR RANLIB=$RANLIB CXXFLAGS="-O1 -Wall -fPIC -isysroot `xcrun --sdk iphoneos --show-sdk-path` -arch armv7 -miphoneos-version-min=7.0"
  mv build/ios_libworld.a build/armv7_ios_libworld.a
  make clean
  make ios_static CXX=$CXX AR=$AR RANLIB=$RANLIB CXXFLAGS="-O1 -Wall -fPIC -isysroot `xcrun --sdk iphoneos --show-sdk-path` -arch armv7s -miphoneos-version-min=7.0"
  mv build/ios_libworld.a build/armv7s_ios_libworld.a
  make clean
  make ios_static CXX=$CXX AR=$AR RANLIB=$RANLIB CXXFLAGS="-O1 -Wall -fPIC -isysroot `xcrun --sdk iphoneos --show-sdk-path` -arch arm64 -miphoneos-version-min=7.0"
  mv build/ios_libworld.a build/arm64_ios_libworld.a
  make clean
  `xcrun --sdk iphoneos -f lipo` -create \
  -arch armv7 build/armv7_ios_libworld.a \
  -arch armv7s build/armv7s_ios_libworld.a \
  -arch arm64 build/arm64_ios_libworld.a \
  -arch x86_64 build/x86_64_ios_libworld.a \
  -arch i386 build/i386_ios_libworld.a \
  -output build/ios_libworld.a
else
  python3.5 version_replace.py
  make linux_shared CXX=$CXX CXXFLAGS="${CXXFLAGS}" LDFLAGS="$LDFLAGS"
  mv build/libworld.so build/${_ARCHNAME_}libworld.so
fi
