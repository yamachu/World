#!/bin/sh
wget https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip
unzip -q android-ndk-r14b-linux-x86_64.zip

cd android-ndk-r14b
[[ $TRAVIS_OS_NAME != 'osx' && ${_ARCHNAME_} == 'Android_arm_' ]] && ./build/tools/make_standalone_toolchain.py --arch arm --install-dir /tmp/arm-toolchain || :
[[ $TRAVIS_OS_NAME != 'osx' && ${_ARCHNAME_} == 'Android_arm64_' ]] && ./build/tools/make_standalone_toolchain.py --arch arm64 --install-dir /tmp/arm64-toolchain || :
[[ $TRAVIS_OS_NAME != 'osx' && ${_ARCHNAME_} == 'Android_x86_' ]] && ./build/tools/make_standalone_toolchain.py --arch x86 --install-dir /tmp/x86-toolchain || :
[[ $TRAVIS_OS_NAME != 'osx' && ${_ARCHNAME_} == 'Android_x86_64_' ]] && ./build/tools/make_standalone_toolchain.py --arch x86_64 --install-dir /tmp/x86_64-toolchain || :
