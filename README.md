# qupai-media-thirdparty
一. 配置androd ndk 

    将android ndk的主目录添加到环境变量中,并严格按照如下命名
    ANDROID_NDK_ROOT=/to/path/android-ndk-r*

二. 下载和配置fdk-aac, x264, ffmpeg

    1. 下载 fdk-aac, x264, ffmpeg

    2. 将fdk-aac, x264, ffmpeg的主目录添加到环境变量中,并严格按照如下命名
       FDK_AAC_SOURCE_DIR=/to/path/fdk-aac
       X264_SOURCE_DIR=/to/path/x264
       FFMPEG_SOURCE_DIR=/to/path/ffmpeg

    3. 进入fdk-aac主目录,并执行 ./autogen.sh

三. 执行编译脚本
    mkdir build && cd build
    cmake .. -DQUPAI_SDK_LIB_DIR=/to/path/SDK_LIB_DIR #生成的动态库所安装的目录
    make
    make install
