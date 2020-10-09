#!/bin/sh

echo "Configuring Debug..."
cmake -G'Unix Makefiles' -Bbuild/Debug --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_TOOLCHAIN_FILE:FILEPATH=toolchain-rpi0.cmake -H.

echo "Configuring Release..."
cmake -G'Unix Makefiles' -Bbuild/Release --no-warn-unused-cli -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_TOOLCHAIN_FILE:FILEPATH=toolchain-rpi0.cmake -H.