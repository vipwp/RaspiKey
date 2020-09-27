
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
    raspkey_depens/include/glib-2.0;
    raspkey_depens/glib-2.0/include;
    raspkey_depens/include/dbus-1.0;
    raspkey_depens/dbus-1.0/include;
    raspkey_depens/include;
)


add_executable (raspikey ${SOURCE_LIST})

target_link_libraries(raspikey 
	pthread
	${PROJECT_SOURCE_DIR}/raspkey_depens/libglib-2.0.a
	${PROJECT_SOURCE_DIR}/raspkey_depens/libdbus-1.a
	${PROJECT_SOURCE_DIR}/raspkey_depens/libboost_system.a
)

# Copy executable to the Pi reference device for testing
# add_custom_command(TARGET raspikey POST_BUILD
#    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:raspikey> R:/boot/raspikey/raspikey
# )
