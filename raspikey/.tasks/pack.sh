#!/usr/bin

set -e

if [ $# -lt 1 ]; then 
    echo "Missing workspaceRoot input parameter"
    exit 1
fi

workspaceRoot=$1
echo "workspaceRoot=$workspaceRoot"

verPatch=$(git rev-list --all --count)
verMajorMinor=$(<version.txt)
version="$verMajorMinor.$verPatch"
sha=$(git rev-parse --short HEAD)

echo "$version"

rm -fr $workspaceRoot/setup/raspikey/html 
cp -R $workspaceRoot/ui/dist $workspaceRoot/setup/raspikey/html 
cp -f $workspaceRoot/build/Release/raspikey $workspaceRoot/setup/raspikey 
rm -f $workspaceRoot/build/*.zip 
7z a -mx=9 $workspaceRoot/build/raspikey-setup.$version+$sha.zip $workspaceRoot/setup/*

