#!/bin/bash

if [ -z $ANDROID_NDK_HOST ]; then
    ANDROID_NDK_HOST=linux-x86_64
fi

if [ ! -d $ANDROID_NDK_ROOT/prebuilt/$ANDROID_NDK_HOST ]; then
    echo "Invalid: ANDROID_NDK_HOST=$ANDROID_NDK_HOST" && exit -1
fi

TARGET_ARCH=arm
APP_PLATFORM=android-8

SYSROOT=$ANDROID_NDK_ROOT/platforms/$APP_PLATFORM/arch-$TARGET_ARCH
CROSS_PREFIX=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-4.8/prebuilt/$ANDROID_NDK_HOST/bin/arm-linux-androideabi-

echo "ANDROID_NDK_ROOT=$ANDROID_NDK_ROOT"
echo "ANDROID_NDK_HOST=$ANDROID_NDK_HOST"
echo "TARGET_ARCH=$TARGET_ARCH"
echo "SYSROOT=$SYSROOT"
echo "CROSS_PREFIX=$CROSS_PREFIX"

#  need automake
if [ ! -f $FDK_AAC_SOURCE_DIR/configure ]; then
    echo "Invalid: FAAC_SOURCE_DIR=$FDK_AAC_SOURCE_DIR" && exit -1
fi

echo "FAAC_SOURCE_DIR=$FDK_AAC_SOURCE_DIR"

export CC=${CROSS_PREFIX}gcc
export CPP=${CROSS_PREFIX}cpp
export CXX=${CROSS_PREFIX}g++
export CXXFLAGS="--sysroot=$SYSROOT -fPIC -march=armv7-a -mfpu=vfpv3-d16 -DANDROID -mfloat-abi=softfp -fno-rtti -fno-exceptions"
export LDFLAGS="-B$SYSROOT/usr/lib"
export CPPFLAGS="-I$SYSROOT/usr/include"

echo "CC=$CC"
echo "CPP=$CPP"
echo "LDFLAGS=$LDFLAGS"
echo "CPPFLAGS=$CPPFLAGS"
echo "CXX=$CXX"
echo "CXXFLAGS=$CXXFLAGS"

$FDK_AAC_SOURCE_DIR/configure \
    --prefix=/ \
    --host=armv7-a-linux \
    --disable-shared \
    --enable-static \

