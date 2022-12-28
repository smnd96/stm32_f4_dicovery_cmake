cmake -G "Ninja" -DCMAKE_TOOLCHAIN_FILE="arm-none-eabi-gcc.cmake" -DCMAKE_BUILD_TYPE=Debug
cmake --build . -- -j 12