
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


# Copy executable to the Pi reference device for testing
add_custom_target(deploy 
    COMMAND sshpass -p raspberry scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $<TARGET_FILE:raspikey> pi@${REFERENCE_PI_DEVICE_ADDRESS}:/tmp 
    VERBATIM
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
    COMMAND 7z a -mx=9 ${PROJECT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/raspikey-setup.${VERSION_TXT}.${GIT_COMMIT_COUNT}-${CMAKE_BUILD_TYPE}+${GIT_SHORT_SHA}.zip ${PROJECT_SOURCE_DIR}/setup/*

    COMMAND echo "Packed ${PROJECT_SOURCE_DIR}/build/raspikey-setup.${VERSION_TXT}.${GIT_COMMIT_COUNT}-${CMAKE_BUILD_TYPE}+${GIT_SHORT_SHA}.zip"
    VERBATIM
    DEPENDS raspikey ui
)



