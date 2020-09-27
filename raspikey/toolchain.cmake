
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv6)
set(triple arm-linux-gnueabihf)

set(TOOLCHAIN_SYSROOT d:/tools/raspberry-gcc/arm-linux-gnueabihf/sysroot)
set(TOOLCHAIN_BIN d:/tools/raspberry-gcc/bin)

set(CMAKE_SYSROOT ${TOOLCHAIN_SYSROOT})
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_SYSROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)