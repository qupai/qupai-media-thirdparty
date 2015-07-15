#!/bin/bash
EXTRA_OPTIONS=()

OS=Android
ARCH=armeabi-v7a

case $OS in
Android)
    GNU_BUILD_OS=linux

    EXTRA_OPTIONS+=(
        --extra-cflags=-DANDROID
        --extra-cflags=-gdwarf-2
    )

    case $ARCH in
    armeabi-v7a*)
        GNU_BUILD_ARCH=armv7-a
        CROSSCOMPILE_PREFIX=arm-linux-androideabi-

        TARGET_ARCH=arm

        EXTRA_OPTIONS+=(
            --extra-cflags=-mfpu=vfpv3-d16
            --extra-cflags=-march=$GNU_BUILD_ARCH
        )

        ;;
    esac

    case $ARCH in
    armeabi-v7a-hard)
        APP_PLATFORM=android-19

        EXTRA_OPTIONS+=(
            --libm="-lm_hard"
            --extra-cflags=-mhard-float
            --extra-cflags=-D_NDK_MATH_NO_SOFTFP=1
            --extra-ldflags=-Wl,--no-warn-mismatch
        )
        ;;
    armeabi-v7a)
        APP_PLATFORM=android-8

        EXTRA_OPTIONS+=(
            --extra-cflags=-mfloat-abi=softfp
        )
        ;;
    esac

    SYSROOT="${ANDROID_NDK_ROOT}/platforms/${APP_PLATFORM}/arch-${TARGET_ARCH}"
    ;;
Windows)
    EXTRA_OPTIONS+=(
        --extra-cflags=-mssse3
        --extra-cflags=-mfpmath=sse
        --cross-prefix=x86_64-w64-mingw32-
    )
    GNU_BUILD_OS=mingw32

    GNU_BUILD_ARCH=x86_64
    ;;
Linux)
    ;;
esac

if [ ! -z "$SYSROOT" ]; then
    EXTRA_OPTIONS+=( --sysroot="$SYSROOT" )
fi

# we are building static only
# EXTRA_OPTIONS+=( --libdir=/lib/static )

${X264_SOURCE_DIR}/configure \
    --prefix=/ \
    --cross-prefix="$CROSSCOMPILE_PREFIX" \
    --host=$GNU_BUILD_ARCH-$GNU_BUILD_OS \
    "${EXTRA_OPTIONS[@]}" \
    --disable-opencl \
    --enable-pic \
    --bit-depth=8 \
    --chroma-format=420 \
    --disable-interlaced \
    --enable-static \
    --disable-lavf \
    --disable-avs \
    --disable-swscale \
    
