
cmake_minimum_required (VERSION 3.8)

set(REFERENCE_PI_DEVICE_ADDRESS "192.168.0.62") # Replace with IP address of reference PI device

project ("raspikey")

aux_source_directory(. SOURCE_LIST) 
aux_source_directory(./bluetooth SOURCE_LIST) 
aux_source_directory(./gdbus SOURCE_LIST)

# See README.md about mapping the R: drive.

include_directories(
    ${SYSROOT_PATH}/usr/include/glib-2.0;
    ${SYSROOT_PATH}/usr/lib/arm-linux-gnueabihf/glib-2.0/include;
    ${SYSROOT_PATH}/usr/include/dbus-1.0;
    ${SYSROOT_PATH}/usr/lib/arm-linux-gnueabihf/dbus-1.0/include;
    ${SYSROOT_PATH}/usr/include;
)

add_executable (raspikey ${SOURCE_LIST})

target_link_libraries(raspikey 
    #glib-2.0
    #dbus-1
    #boost_system
	${SYSROOT_PATH}/usr/lib/arm-linux-gnueabihf/libglib-2.0.a
	${SYSROOT_PATH}/usr/lib/arm-linux-gnueabihf/libdbus-1.a
	${SYSROOT_PATH}/usr/lib/arm-linux-gnueabihf/libboost_system.a
)

#target_link_libraries(raspikey -static) # Static linking (causes some libc linking warnings)

#set_target_properties(raspikey PROPERTIES LINK_FLAGS_RELEASE -s) # Strip
set_target_properties(raspikey PROPERTIES LINK_FLAGS -s) # Strip

# Copy executable to the Pi reference device for testing
# add_custom_command(TARGET raspikey POST_BUILD
#     COMMAND sshpass -p raspberry scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $<TARGET_FILE:raspikey> pi@${REFERENCE_PI_DEVICE_ADDRESS}:/tmp 
# )


