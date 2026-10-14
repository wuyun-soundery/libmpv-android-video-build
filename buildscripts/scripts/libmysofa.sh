#!/bin/bash -e

. ../../include/depinfo.sh
. ../../include/path.sh

build=_build$ndk_suffix

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf $build
	exit 0
else
	exit 255
fi

abi=
case "$ndk_triple" in
	aarch64-linux-android) abi=arm64-v8a ;;
	arm-linux-androideabi) abi=armeabi-v7a ;;
	i686-linux-android)    abi=x86 ;;
	x86_64-linux-android)  abi=x86_64 ;;
esac

cmake -S . -B $build \
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_HOME/ndk/$v_ndk/build/cmake/android.toolchain.cmake" \
	-DANDROID_ABI=$abi \
	-DANDROID_PLATFORM=android-21 \
	-DANDROID_STL=c++_static \
	-DBUILD_TESTS=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DBUILD_STATIC_LIBS=ON \
	-DCMAKE_INSTALL_PREFIX="$prefix_dir" \
	-DCMAKE_BUILD_TYPE=Release

cmake --build $build -j$cores
cmake --install $build
