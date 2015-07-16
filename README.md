# qupai-media-thirdparty
一. 配置androd ndk 

    将android ndk的主目录添加到环境变量中,并严格按照如下命名
    ANDROID_NDK_ROOT=/to/path/android-ndk-r*

二. 执行编译脚本
    mkdir build && cd build
    
    cmake .. -DQUPAI_SDK_LIB_DIR=/to/path/SDK_LIB_DIR #生成的动态库所安装的目录
    make
    make install
