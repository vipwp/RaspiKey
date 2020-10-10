# cmake build script.
#
# Notes:
# To use the "deploy" target you nee to set the REFERENCE_PI_DEVICE_ADDRESS variable to the IP address of the PI device.
#


cmake_minimum_required (VERSION 3.8)

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
    ${SYSROOT_PATH}/beast_http_server;
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

set_target_properties(raspikey PROPERTIES LINK_FLAGS_RELEASE -s) # Strip Release build
#set_target_properties(raspikey PROPERTIES LINK_FLAGS -s) # Strip all builds

execute_process(
    COMMAND cat version.txt
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} OUTPUT_VARIABLE VERSION_TXT ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND git rev-list --all --count
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} OUTPUT_VARIABLE GIT_COMMIT_COUNT ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(
    COMMAND git rev-parse --short HEAD 
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} OUTPUT_VARIABLE GIT_SHORT_SHA ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
)

string(TOLOWER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE_TOLOWER)
set(SEMVER_STRING ${VERSION_TXT}.${GIT_COMMIT_COUNT}-${CMAKE_BUILD_TYPE_TOLOWER}+${GIT_SHORT_SHA})

# Copy executable to the Pi reference device for testing
add_custom_target(deploy 
    COMMAND sshpass -p raspberry scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${PROJECT_SOURCE_DIR}/setup/raspikey/raspikey_usb pi@$ENV{REFERENCE_PI_DEVICE_ADDRESS}:/home/pi/ 
    COMMAND sshpass -p raspberry scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $<TARGET_FILE:raspikey> pi@$ENV{REFERENCE_PI_DEVICE_ADDRESS}:/home/pi/ 
    COMMAND sshpass -p raspberry scp -ro StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${PROJECT_SOURCE_DIR}/ui/dist pi@$ENV{REFERENCE_PI_DEVICE_ADDRESS}:/home/pi/html
    VERBATIM
    #DEPENDS raspikey ui
    DEPENDS raspikey
)

add_custom_target(ui 
    COMMAND npm install && npm run build
    VERBATIM
    DEPENDS raspikey
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/ui
)

add_custom_target(clean_all 
    COMMAND rm -fr ${PROJECT_SOURCE_DIR}/build/*
    VERBATIM
)

add_custom_target(pack
    COMMAND rm -fr ${PROJECT_SOURCE_DIR}/setup/raspikey/html 
    COMMAND cp -R ${PROJECT_SOURCE_DIR}/ui/dist ${PROJECT_SOURCE_DIR}/setup/raspikey/html 
    COMMAND cp -f ${PROJECT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/raspikey ${PROJECT_SOURCE_DIR}/setup/raspikey 
    COMMAND 7z a -mx=9 ${PROJECT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/raspikey-setup.${SEMVER_STRING}.zip ${PROJECT_SOURCE_DIR}/setup/*

    COMMAND echo "Packed raspikey-setup.${SEMVER_STRING}.zip"
    VERBATIM
    DEPENDS raspikey ui
)



