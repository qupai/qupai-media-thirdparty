cmake_minimum_required( VERSION 2.8.6 )
set ( CMAKE_VERBOSE_MAKEFILE on)

set ( ANDROID_NDK_ROOT $ENV{ANDROID_NDK_ROOT} )
message ( ${ANDROID_NDK_ROOT})
if ( NOT EXISTS ${ANDROID_NDK_ROOT} )
    message( FATAL_ERROR "android ndk path is null, please set android-ndk root path in env path" )
endif()

if (NOT DEFINED QUPAI_TARGET_PLATFORM )
    message ( FATAL_ERROR "QUPAI_TARGET_PLATFORM not defined, please set QUPAI_TARGET_PLATFORM= [x86, x86_64, arm, arm64]")
endif()

if ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "x86")
    find_path( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/x86-4.9/prebuilt/*  NO_DEFAULT_PATH )
    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   i686-linux-android-gcc PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_CXX_COMPILER i686-linux-android-g++ PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_AR           i686-linux-android-ar  PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-9/arch-x86  CACHE PATH "" )

    set (CROSS_PREFIX  ${TOOLCHAIN_ROOT}/bin/i686-linux-android-)

    set (ARCH    "i686")

    set (EXTRA_OPTIONS "")

elseif ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "x86_64")

    message ("ANDROID_NDK_ROOT" ${ANDROID_NDK_ROOT})

    find_path( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/x86_64-4.9/prebuilt/*  NO_DEFAULT_PATH )
    message ( "TOOLCHAIN_ROOT" ${TOOLCHAIN_ROOT})
    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   x86_64-linux-android-gcc PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_CXX_COMPILER x86_64-linux-android-g++ PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_AR           x86_64-linux-android-ar  PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-21/arch-x86_64  CACHE PATH "" )

    set (CROSS_PREFIX  ${TOOLCHAIN_ROOT}/bin/x86_64-linux-android-)

    set (ARCH    "x86_64")

    set (EXTRA_OPTIONS "")

elseif ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "arm")
    
    find_path( TOOLCHAIN_ROOT bin ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/*  NO_DEFAULT_PATH)

    message ( "arm TOOLCHAIN_ROOT " ${TOOLCHAIN_ROOT})

    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   arm-linux-androideabi-gcc  ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH)
    find_program ( CMAKE_CXX_COMPILER arm-linux-androideabi-g++  ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH)
    find_program ( CMAKE_AR           arm-linux-androideabi-ar   ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH)

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-8/arch-arm  CACHE PATH "" )

    set (CROSS_PREFIX  ${TOOLCHAIN_ROOT}/bin/arm-linux-androideabi-)

    set (ARCH    "armv7-a")

    set (EXTRA_OPTIONS "--extra-cflags=-DANDROID" "--extra-cflags=-gdwarf-2" "--extra-cflags=-mfloat-abi=softfp" "--extra-cflags=-mfpu=vfpv3-d16" "--extra-cflags=-march=armv7-a")
elseif ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "arm64")
    find_path( TOOLCHAIN_ROOT bin  ${ANDROID_NDK_ROOT}/toolchains/aarch64-linux-android-4.9/prebuilt/* NO_DEFAULT_PATH)
    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   aarch64-linux-android-gcc  ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_CXX_COMPILER aarch64-linux-android-g++  ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_AR           aarch64-linux-android-ar   ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-21/arch-arm64  CACHE PATH "" )

    set (CROSS_PREFIX  ${TOOLCHAIN_ROOT}/bin/aarch64-linux-android-)

    set (ARCH    "aarch64")

    set (EXTRA_OPTIONS "--extra-cflags=-DANDROID")
else ()
    message( FATAL_ERROR "QUPAI_TARGET_PLATFORM not defined, please set QUPAI_TARGET_PLATFORM= [x86, x86_64, arm, arm64]" )
endif()

set ( LIBRARY_INSTALL_DIR ${CMAKE_SOURCE_DIR}/libs)


# set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
# set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
# set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )
message (STATUS "CMAKE_C_COMPILER    : " ${CMAKE_C_COMPILER})
message (STATUS "CMAKE_CXX_COMPILER  : " ${CMAKE_CXX_COMPILER})
message (STATUS "CMAKE_AR            : " ${CMAKE_AR})
message (STATUS "CMAKE_SYSROOT       : " ${CMAKE_SYSROOT})
message (STATUS "CROSS_PREFIX        : " ${CROSS_PREFIX})
message (STATUS "ARCH                : " ${ARCH})

project(qupai-media-thirdparty)

include( ExternalProject )

externalproject_add( 
  fdk-aac-project
  GIT_REPOSITORY https://github.com/mstorsjo/fdk-aac.git
  CONFIGURE_COMMAND cp ${CMAKE_SOURCE_DIR}/fdk-aac/CMakeLists.txt ${CMAKE_SOURCE_DIR}/build/fdk-aac-project-prefix/src/fdk-aac-project
  TEST_BEFORE_INSTALL 0
  BUILD_IN_SOURCE 1
  BUILD_COMMAND cmake . -DFDK_AAC_SOURCE_DIR=${CMAKE_SOURCE_DIR}/build/fdk-aac-project-prefix/src/fdk-aac-project -DCMAKE_INSTALL_PREFIX=${CMAKE_SOURCE_DIR}/libs -DQUPAI_TARGET_PLATFORM=${QUPAI_TARGET_PLATFORM} && make -j8
  INSTALL_COMMAND make install
)

externalproject_add(
  x264-project
  GIT_REPOSITORY http://git.videolan.org/git/x264.git
  CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/build/x264-project-prefix/src/x264-project/configure --prefix=/
                                                    --cross-prefix=${CROSS_PREFIX}
                                                    --host=${ARCH}-linux
                                                    --sysroot=${CMAKE_SYSROOT}
                                                    ${EXTRA_OPTIONS}
                                                    --disable-opencl
                                                    --enable-pic
                                                    --bit-depth=8
                                                    --chroma-format=420
                                                    --disable-interlaced
                                                    --enable-static
                                                    --disable-lavf
                                                    --disable-avs
                                                    --disable-swscale
  TEST_BEFORE_INSTALL 0
  BUILD_IN_SOURCE 1
  BUILD_COMMAND make -j8
  INSTALL_COMMAND make install DESTDIR=${LIBRARY_INSTALL_DIR}
)

externalproject_add(
  ffmpeg-project
  DEPENDS fdk-aac-project x264-project
  GIT_REPOSITORY git://source.ffmpeg.org/ffmpeg.git
  CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/build/ffmpeg-project-prefix/src/ffmpeg-project/configure --prefix=/
                                                --arch=${ARCH}
                                                --target-os=linux
                                                --cross-prefix=${CROSS_PREFIX}
                                                --sysroot=${CMAKE_SYSROOT}
                                                ${EXTRA_OPTIONS}
                                                --extra-cflags="-I${CMAKE_SOURCE_DIR}/libs/include"
                                                --extra-ldflags="-L${CMAKE_SOURCE_DIR}/libs/lib" 
                                                --enable-gpl 
                                                --enable-version3 
                                                --enable-nonfree 
                                                --enable-pic 
                                                --disable-swscale-alpha 
                                                --disable-doc 
                                                --disable-network 
                                                --disable-ffprobe 
                                                --disable-ffserver 
                                                --disable-avdevice 
                                                --disable-postproc 
                                                --disable-everything 
                                                --enable-demuxer=image2 
                                                --enable-demuxer=image2pipe 
                                                --enable-demuxer=image_png_pipe 
                                                --enable-demuxer=matroska 
                                                --enable-demuxer=mov 
                                                --enable-demuxer=mpegts 
                                                --enable-demuxer=mp3 
                                                --enable-demuxer=pcm_s16le 
                                                --enable-demuxer=rawvideo 
                                                --enable-muxer=image2 
                                                --enable-muxer=image2pipe 
                                                --enable-muxer=matroska 
                                                --enable-muxer=mov 
                                                --enable-muxer=mpegts 
                                                --enable-muxer=mp4 
                                                --enable-muxer=pcm_s16le 
                                                --enable-muxer=rawvideo 
                                                --enable-decoder=amrnb 
                                                --enable-decoder=amrwb 
                                                --enable-decoder=libfdk_aac 
                                                --enable-decoder=mp3 
                                                --enable-decoder=pcm_s16le 
                                                --enable-decoder=ffv1 
                                                --enable-decoder=hevc 
                                                --enable-decoder=h263 
                                                --enable-decoder=h263p 
                                                --enable-decoder=h264 
                                                --enable-decoder=mpeg4 
                                                --enable-decoder=png 
                                                --enable-decoder=rawvideo 
                                                --enable-encoder=libfdk_aac 
                                                --enable-encoder=pcm_s16le 
                                                --enable-encoder=ffv1 
                                                --enable-encoder=libx264 
                                                --enable-encoder=png 
                                                --enable-encoder=rawvideo 
                                                --enable-libfdk-aac 
                                                --enable-libx264 
                                                --enable-bsf=aac_adtstoasc 
                                                --enable-bsf=h264_mp4toannexb 
                                                --enable-filter=amovie 
                                                --enable-filter=movie 
                                                --enable-filter=amerge 
                                                --enable-filter=amix 
                                                --enable-filter=aresample 
                                                --enable-filter=pan 
                                                --enable-filter=resample 
                                                --enable-filter=volume 
                                                --enable-filter=null 
                                                --enable-filter=anull 
                                                --enable-filter=crop 
                                                --enable-filter=transpose 
                                                --enable-filter=scale 
                                                --enable-filter=alphaextract 
                                                --enable-parser=aac 
                                                --enable-parser=aac_latm 
                                                --enable-parser=mpegaudio 
                                                --enable-parser=h263 
                                                --enable-parser=h264 
                                                --enable-parser=mpeg4video 
                                                --enable-parser=png 
                                                --enable-protocol=file 
  TEST_BEFORE_INSTALL 0
  BUILD_IN_SOURCE 1
  BUILD_COMMAND make -j8
  INSTALL_COMMAND make install DESTDIR=${LIBRARY_INSTALL_DIR}
)

include_directories(${LIBRARY_INSTALL_DIR}/include)
link_directories(${LIBRARY_INSTALL_DIR}/lib)

add_library(avutil STATIC IMPORTED)
set_target_properties(avutil PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libavutil.a")

add_library(avcodec STATIC IMPORTED)
set_target_properties(avcodec PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libavcodec.a")

add_library(avformat STATIC IMPORTED)
set_target_properties(avformat PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libavformat.a")

add_library(swscale STATIC IMPORTED)
set_target_properties(swscale PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libswscale.a")

add_library(swresample STATIC IMPORTED)
set_target_properties(swresample PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libswresample.a")

add_library(avfilter STATIC IMPORTED)
set_target_properties(avfilter PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libavfilter.a")

add_library(x264 STATIC IMPORTED)
set_target_properties(x264 PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libx264.a")

add_library(fdk STATIC IMPORTED)
set_target_properties(fdk PROPERTIES IMPORTED_LOCATION "${LIBRARY_INSTALL_DIR}/lib/libfdk-aac.a")

add_library(qupai-media-thirdparty SHARED)
set_target_properties(qupai-media-thirdparty PROPERTIES LINKER_LANGUAGE CXX )

target_link_libraries (qupai-media-thirdparty -Wl,--whole-archive avfilter swresample swscale avformat avcodec avutil x264 fdk z -Wl,--no-whole-archive)

install(TARGETS qupai-media-thirdparty LIBRARY DESTINATION ${QUPAI_SDK_LIB_DIR})
