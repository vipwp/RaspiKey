
cmake_minimum_required (VERSION 3.8)

project ("raspikey")

# Compiler options
set(CMAKE_C_COMPILER ${TOOLCHAIN_BIN}/${triple}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_BIN}/${triple}-g++)

aux_source_directory(. SOURCE_LIST) 
aux_source_directory(./bluetooth SOURCE_LIST) 
aux_source_directory(./gdbus SOURCE_LIST)

# See README.md about mapping the R: drive.

include_directories(
    R:/usr/include/glib-2.0;
    R:/usr/lib/arm-linux-gnueabihf/glib-2.0/include;
    R:/usr/include/dbus-1.0;
    R:/usr/lib/arm-linux-gnueabihf/dbus-1.0/include;
    R:/usr/include;
)


add_executable (raspikey ${SOURCE_LIST})

target_link_libraries(raspikey 
	pthread
	R:/usr/lib/arm-linux-gnueabihf/libglib-2.0.a
	R:/usr/lib/arm-linux-gnueabihf/libdbus-1.a
	R:/usr/lib/arm-linux-gnueabihf/libboost_system.a
)

#add_custom_command(TARGET raspikey POST_BUILD
#    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:raspikey> ../out/raspikey
#)
