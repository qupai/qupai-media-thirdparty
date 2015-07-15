# source code: git clone https://android.googlesource.com/platform/external/aac

cmake_minimum_required ( VERSION 2.8 )

set (CMAKE_INSTALL_PREFIX /)
set (ANDROID_NDK_ROOT $ENV{ANDROID_NDK_ROOT})
find_path( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/arm-linux-androideabi-4.8/prebuilt/* )
include ( CMakeForceCompiler )

find_program ( CMAKE_C_COMPILER   arm-linux-androideabi-gcc PATHS ${TOOLCHAIN_ROOT}/bin )
find_program ( CMAKE_CXX_COMPILER arm-linux-androideabi-g++ PATHS ${TOOLCHAIN_ROOT}/bin )
find_program ( CMAKE_AR           arm-linux-androideabi-ar  PATHS ${TOOLCHAIN_ROOT}/bin )

message( ${CMAKE_CXX_COMPILER} )
cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-8/arch-arm  CACHE PATH "" )



project ( fdk-aac )

if ( NOT INCLUDE_INSTALL_DIR )
    set ( INCLUDE_INSTALL_DIR include )
endif ()

if ( NOT ARCHIVE_INSTALL_DIR )
    set ( ARCHIVE_INSTALL_DIR lib )
endif ()

set (FDK_AAC_SOURCE_DIR $ENV{FDK_AAC_SOURCE_DIR})

if ( NOT IS_DIRECTORY ${FDK_AAC_SOURCE_DIR} )
    message ( FATAL_ERROR "FDK_AAC_SOURCE_DIR=${FDK_AAC_SOURCE_DIR} is not a dir" )
endif ()


add_definitions (
    --sysroot=${CMAKE_SYSROOT}
    -fPIC
    -march=armv7-a
    -mfpu=vfpv3-d16
    -DANDROID
    -mfloat-abi=softfp
    -fno-rtti
    -fno-exceptions
)



set ( SOURCE_FILES )

foreach ( subdir
    libAACdec libAACenc libFDK
    libMpegTPDec libMpegTPEnc
    libPCMutils
    libSBRdec libSBRenc
    libSYS )

    set ( __inc_dir ${FDK_AAC_SOURCE_DIR}/${subdir}/include )

    include_directories ( ${__inc_dir} )
    install ( DIRECTORY ${__inc_dir}/ DESTINATION ${INCLUDE_INSTALL_DIR}/fdk-aac/ )

    file ( GLOB __src_files
        ${FDK_AAC_SOURCE_DIR}/${subdir}/src/*.cpp
        ${FDK_AAC_SOURCE_DIR}/${subdir}/src/*.h )
    list ( APPEND SOURCE_FILES ${__src_files} )
endforeach ()

add_library ( fdk-aac STATIC
    ${SOURCE_FILES} )

install ( TARGETS fdk-aac
    ARCHIVE DESTINATION ${ARCHIVE_INSTALL_DIR} )
