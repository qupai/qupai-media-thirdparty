cmake_minimum_required( VERSION 2.8.6 )
set ( CMAKE_VERBOSE_MAKEFILE on)

set ( ANDROID_NDK_ROOT $ENV{ANDROID_NDK_ROOT} )

if ( NOT EXISTS ${ANDROID_NDK_ROOT} )
    message( FATAL_ERROR "android ndk path is null, please set android-ndk root path in env path" )
endif()

find_path( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/* )
include ( CMakeForceCompiler )

find_program ( CMAKE_C_COMPILER   arm-linux-androideabi-gcc PATHS ${TOOLCHAIN_ROOT}/bin )
find_program ( CMAKE_CXX_COMPILER arm-linux-androideabi-g++ PATHS ${TOOLCHAIN_ROOT}/bin )
find_program ( CMAKE_AR           arm-linux-androideabi-ar  PATHS ${TOOLCHAIN_ROOT}/bin )

cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-8/arch-arm  CACHE PATH "" )

set ( LIBRARY_INSTALL_DIR ${CMAKE_SOURCE_DIR}/libs)


# set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ONLY )
# set( CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY )
# set( CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY )

project(qupai-media-thirdparty)

include( ExternalProject )

externalproject_add( 
  fdk-aac-project
  SOURCE_DIR $ENV{FDK_AAC_SOURCE_DIR}
  CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/Build.fdk-aac.android.sh
  TEST_BEFORE_INSTALL 0
  BUILD_IN_SOURCE 1
  BUILD_COMMAND make -j8
  INSTALL_COMMAND make install DESTDIR=${LIBRARY_INSTALL_DIR}
)

externalproject_add(
  x264-project
  SOURCE_DIR $ENV{X264_SOURCE_DIR}
  CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/Build.x264.android.sh
  TEST_BEFORE_INSTALL 0
  BUILD_IN_SOURCE 1
  BUILD_COMMAND make -j8
  INSTALL_COMMAND make install DESTDIR=${LIBRARY_INSTALL_DIR}
)

externalproject_add(
  ffmpeg-project
  DEPENDS fdk-aac-project x264-project
  SOURCE_DIR $ENV{FFMPEG_SOURCE_DIR}
  CONFIGURE_COMMAND ${CMAKE_SOURCE_DIR}/Build.ffmpeg.android.sh ${LIBRARY_INSTALL_DIR} ${LIBRARY_INSTALL_DIR}
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
