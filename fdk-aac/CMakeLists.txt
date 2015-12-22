# source code: git clone https://android.googlesource.com/platform/external/aac

cmake_minimum_required ( VERSION 2.8 )

set (ANDROID_NDK_ROOT $ENV{ANDROID_NDK_ROOT})

message (STATUS "QUPAI_TARGET_PLATFORM  : " ${QUPAI_TARGET_PLATFORM})

if ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "x86")
    find_path( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/x86-4.9/prebuilt/*  NO_DEFAULT_PATH )
    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   i686-linux-android-gcc PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_CXX_COMPILER i686-linux-android-g++ PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_AR           i686-linux-android-ar  PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-9/arch-x86  CACHE PATH "" )

    add_definitions (
        --sysroot=${CMAKE_SYSROOT}
        -fPIC
        -fno-rtti
        -fno-exceptions
    )
elseif ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "x86_64")

    find_path( TOOLCHAIN_ROOT bin PATHS ${ANDROID_NDK_ROOT}/toolchains/x86_64-4.9/prebuilt/*  NO_DEFAULT_PATH )
    message ( "TOOLCHAIN_ROOT" ${TOOLCHAIN_ROOT})
    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   x86_64-linux-android-gcc PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_CXX_COMPILER x86_64-linux-android-g++ PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_AR           x86_64-linux-android-ar  PATHS ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-9/arch-x86  CACHE PATH "" )

    add_definitions (
        --sysroot=${CMAKE_SYSROOT}
        -fPIC
        -fno-rtti
        -fno-exceptions
    )
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

elseif ( "${QUPAI_TARGET_PLATFORM}" STREQUAL "arm64")
    find_path( TOOLCHAIN_ROOT bin  ${ANDROID_NDK_ROOT}/toolchains/aarch64-linux-android-4.9/prebuilt/* NO_DEFAULT_PATH)
    message (STATUS "arm64 TOOLCHAIN_ROOT " ${TOOLCHAIN_ROOT})
    include ( CMakeForceCompiler )
    find_program ( CMAKE_C_COMPILER   aarch64-linux-android-gcc  ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_CXX_COMPILER aarch64-linux-android-g++  ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )
    find_program ( CMAKE_AR           aarch64-linux-android-ar   ${TOOLCHAIN_ROOT}/bin NO_DEFAULT_PATH )

    cmake_force_c_compiler      ( ${CMAKE_C_COMPILER} GNU )
    cmake_force_cxx_compiler    ( ${CMAKE_CXX_COMPILER} GNU )

    set ( CMAKE_SYSROOT         ${ANDROID_NDK_ROOT}/platforms/android-8/arch-arm  CACHE PATH "" )

    add_definitions (
        --sysroot=${CMAKE_SYSROOT}
        -fPIC
        -DANDROID
        -fno-rtti
        -fno-exceptions
    )
    
else ()

    message( FATAL_ERROR "QUPAI_TARGET_PLATFORM not defined, please set QUPAI_TARGET_PLATFORM= [x86, x86_64, arm, arm64]" )

endif()

message (STATUS "CMAKE_C_COMPILER    : " ${CMAKE_C_COMPILER})
message (STATUS "CMAKE_CXX_COMPILER  : " ${CMAKE_CXX_COMPILER})
message (STATUS "CMAKE_AR            : " ${CMAKE_AR})
message (STATUS "CMAKE_SYSROOT       : " ${CMAKE_SYSROOT})

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
