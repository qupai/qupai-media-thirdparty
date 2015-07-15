#!/bin/bash

echo "FFMPEG_SOURCE_DIR=$FFMPEG_SOURCE_DIR"

EXTRA_OPTIONS=()

FDK_AAC_INSTALL_DIR=$1
X264_INSTALL_DIR=$2

OS=Android
ARCH=armeabi-v7a

case $OS in
Android)
    GNU_BUILD_OS=linux

    case $ARCH in
    armeabi-v7a*)
        TARGET_ARCH=arm
        GNU_BUILD_ARCH=armv7-a

        CROSSCOMPILE_PREFIX=arm-linux-androideabi-

        EXTRA_OPTIONS+=(
            --extra-cflags=-march=$GNU_BUILD_ARCH
            --extra-cflags=-mfpu=vfpv3-d16
            --extra-cflags=-DANDROID
        )
        ;;
    esac


    case $ARCH in
    armeabi-v7a-hard)
        APP_PLATFORM=android-19

        EXTRA_OPTIONS+=(
            --extra-cflags=-mhard-float
            --extra-cflags=-D_NDK_MATH_NO_SOFTFP=1
            --extra-libs=-lm_hard
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
        --extra-libs=-lwinpthread
    )

    case $ARCH in
    x86_64)
        CROSSCOMPILE_PREFIX=x86_64-w64-mingw32-
        EXTRA_OPTIONS+=(
            --extra-cflags=-m64
        )
        ;;
    esac

    GNU_BUILD_OS=mingw32
    GNU_BUILD_ARCH=$ARCH
    ;;
Linux)
    GNU_BUILD_OS=linux
    GNU_BUILD_ARCH=$ARCH
    ;;
esac

INSTALL_SUBDIR=${OS}/${ARCH}

echo FDK_AAC_INSTALL_DIR=$FDK_AAC_INSTALL_DIR
echo X264_INSTALL_DIR=$X264_INSTALL_DIR

if [ ! -z "$SYSROOT" ]; then
    EXTRA_OPTIONS+=( --sysroot="$SYSROOT" )
fi

if [ ! -z "$CROSSCOMPILE_PREFIX" ]; then
    EXTRA_OPTIONS+=( --cross-prefix="$CROSSCOMPILE_PREFIX" )
fi

$FFMPEG_SOURCE_DIR/configure \
    --prefix=/ \
    --arch=$GNU_BUILD_ARCH \
    --target-os=$GNU_BUILD_OS \
    "${EXTRA_OPTIONS[@]}" \
    --extra-cflags="-I${FDK_AAC_INSTALL_DIR}/include" \
    --extra-cflags="-I${X264_INSTALL_DIR}/include" \
    --extra-ldflags="-L${FDK_AAC_INSTALL_DIR}/lib" \
    --extra-ldflags="-L${X264_INSTALL_DIR}/lib" \
    \
    --enable-gpl \
    --enable-version3 \
    --enable-nonfree \
    \
    --enable-pic \
    \
    --disable-swscale-alpha \
    --disable-doc \
    --disable-network \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-postproc \
    \
    --disable-everything \
    \
    --enable-demuxer=image2 \
    --enable-demuxer=image2pipe \
    --enable-demuxer=image_png_pipe \
    --enable-demuxer=matroska \
    --enable-demuxer=mov \
    --enable-demuxer=mpegts \
    --enable-demuxer=mp3 \
    --enable-demuxer=pcm_s16le \
    --enable-demuxer=rawvideo \
    \
    --enable-muxer=image2 \
    --enable-muxer=image2pipe \
    --enable-muxer=matroska \
    --enable-muxer=mov \
    --enable-muxer=mpegts \
    --enable-muxer=mp4 \
    --enable-muxer=pcm_s16le \
    --enable-muxer=rawvideo \
    \
    --enable-decoder=amrnb \
    --enable-decoder=amrwb \
    --enable-decoder=libfdk_aac \
    --enable-decoder=mp3 \
    --enable-decoder=pcm_s16le \
    \
    --enable-decoder=ffv1 \
    --enable-decoder=hevc \
    --enable-decoder=h263 \
    --enable-decoder=h263p \
    --enable-decoder=h264 \
    --enable-decoder=mpeg4 \
    --enable-decoder=png \
    --enable-decoder=rawvideo \
    \
    --enable-encoder=libfdk_aac \
    --enable-encoder=pcm_s16le \
    \
    --enable-encoder=ffv1 \
    --enable-encoder=libx264 \
    --enable-encoder=png \
    --enable-encoder=rawvideo \
    \
    --enable-libfdk-aac \
    --enable-libx264 \
    \
    --enable-bsf=aac_adtstoasc \
    --enable-bsf=h264_mp4toannexb \
    \
    --enable-filter=amovie \
    --enable-filter=movie \
    \
    --enable-filter=amerge \
    --enable-filter=amix \
    --enable-filter=aresample \
    --enable-filter=pan \
    --enable-filter=resample \
    --enable-filter=volume \
    --enable-filter=null \
    --enable-filter=anull \
    --enable-filter=crop \
    --enable-filter=transpose \
    --enable-filter=scale \
    --enable-filter=alphaextract \
    \
    --enable-parser=aac \
    --enable-parser=aac_latm \
    --enable-parser=mpegaudio \
    \
    --enable-parser=h263 \
    --enable-parser=h264 \
    --enable-parser=mpeg4video \
    --enable-parser=png \
    \
    --enable-protocol=file \



