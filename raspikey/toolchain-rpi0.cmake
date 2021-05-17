
set(TOOLCHAIN_HOME  "d:/tools/raspberry-gcc")
set(TOOLCHAIN_BIN "d:/tools/raspberry-gcc/bin")
set(TOOLCHAIN_HOST "arm-linux-gnueabihf")
set(TOOLCHAIN_CC "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-gcc.exe")
set(TOOLCHAIN_CXX "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-g++.exe")
set(TOOLCHAIN_LD "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-ld.exe")
set(TOOLCHAIN_AR "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-ar.exe")
set(TOOLCHAIN_RANLIB "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-ranlib.exe")
set(TOOLCHAIN_STRIP "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-strip.exe")
set(TOOLCHAIN_NM "${TOOLCHAIN_BIN}/${TOOLCHAIN_HOST}-nm.exe")

set(SYSROOT_PATH "d:/tools/raspberry-gcc/arm-linux-gnueabihf/sysroot")
set(CMAKE_SYSROOT "${SYSROOT_PATH}")
set(CMAKE_SYSTEM_NAME "Linux")
set(CMAKE_SYSTEM_PROCESSOR "arm")
set(CMAKE_C_COMPILER ${TOOLCHAIN_CC})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_CXX})
set(CMAKE_CROSSCOMPILING TRUE)

set(LIB_DIRS 
	"${TOOLCHAIN_HOME}/arm-linux-gnueabihf/lib"
	"${TOOLCHAIN_HOME}/lib"
	"${SYSROOT_PATH}/opt/vc/lib"
	"${SYSROOT_PATH}/lib/${TOOLCHAIN_HOST}"
	"${SYSROOT_PATH}/usr/local/lib"
	"${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}"
	"${SYSROOT_PATH}/usr/lib"
	"${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}/blas"
	"${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}/lapack"
)

set(COMMON_FLAGS "-I${SYSROOT_PATH}/usr/include ")
FOREACH(LIB ${LIB_DIRS})
	set(COMMON_FLAGS "${COMMON_FLAGS} -L${LIB} -Wl,-rpath-link,${LIB}")
ENDFOREACH()

set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH};${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}")

set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard -pthread -Wno-psabi ${COMMON_FLAGS}" CACHE STRING "Flags for Raspberry PI 1 B+ Zero")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -std=c++14" CACHE STRING "Flags for Raspberry PI 1 B+ Zero")

set(CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX};${CMAKE_PREFIX_PATH};${CMAKE_SYSROOT}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

#SET (CMAKE_C_COMPILER_WORKS 1)
#SET (CMAKE_CXX_COMPILER_WORKS 1)
