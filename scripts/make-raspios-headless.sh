#!/bin/bash

# Creates Raspbian modified base image with headless setup script support in /boot partition
#

script_path=$(readlink -f "$0")
script_dir=$(readlink -f `dirname $0`)

if [ $(id -u) -ne 0 ]; then
	echo "$script_path must be run as root."
	exit 1
fi

set -e
#set -v

src_url=https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2020-08-24/2020-08-20-raspios-buster-armhf-lite.zip
src_img_name=2020-08-20-raspios-buster-armhf-lite
rootpath=./root
bootpath=./boot

# Retrieve official source image
if [ ! -f "${src_img_name}.zip" ]; then 
	wget $src_url
fi
unzip -o "${src_img_name}.zip"

# Mount source image
mkdir $rootpath
mkdir $bootpath
losetup -P /dev/loop99 "${src_img_name}.img"
mount /dev/loop99p1 $bootpath
mount /dev/loop99p2 $rootpath

# Modify /etc/rc.local to run /boot/start.sh
sed -i 's/^.*exit 0.*$//g' $rootpath/etc/rc.local
cat <<EOT >> $rootpath/etc/rc.local

echo -n "Checking for /boot/*.zip to autoextract... "
zipFile=\$(find /boot -maxdepth 1 -name '*.zip' -print -quit)
if [ -f "\$zipFile" ] && [ -x "\$(command -v unzip)" ]; then
  echo "Found \$zipFile, extracting..."
  unzip -o -d /boot \$zipFile
  rm -f \$zipFile
else
  echo "Not found."
fi

echo -n "Checking for /boot/start.sh to execute... "
if [ -f /boot/start.sh ]; then
  echo "Found /boot/start.sh, executing..."
  chmod +x /boot/start.sh
  /boot/start.sh
else
  echo "Not found."
fi

exit 0
EOT

# Disable Raspbian sdcard autoresize on first boot
sed -i 's/init=[^ ]*//g' $bootpath/cmdline.txt
if [ -f $rootpath/etc/init.d/resize2fs_once ]; then
    rm $rootpath/etc/init.d/resize2fs_once
fi
if [ -f $rootpath/etc/rc3.d/S01resize2fs_once ]; then
    rm $rootpath/etc/rc3.d/S01resize2fs_once
fi

# Unmount source image
umount $bootpath
umount $rootpath
losetup -d /dev/loop99
rmdir $bootpath
rmdir $rootpath

# Compress to new image
xz -e -9 -c ${src_img_name}.img | pv > ${src_img_name}-headless.xz
rm ${src_img_name}.img



