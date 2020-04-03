#!/bin/sh
wget https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip
unzip -q android-ndk-r14b-linux-x86_64.zip

cd android-ndk-r14b
./build/tools/make_standalone_toolchain.py --arch arm --install-dir /tmp/arm-toolchain
./build/tools/make_standalone_toolchain.py --arch arm64 --install-dir /tmp/arm64-toolchain
./build/tools/make_standalone_toolchain.py --arch x86 --install-dir /tmp/x86-toolchain
./build/tools/make_standalone_toolchain.py --arch x86_64 --install-dir /tmp/x86_64-toolchain
