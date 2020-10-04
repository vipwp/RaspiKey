#!/bin/bash

scriptPath=$(readlink -f "$0")
scriptDir=$(readlink -f `dirname $0`)

echo "Running $scriptPath"

if [ $(id -u) -ne 0 ]; then
	echo "$scriptPath must be run as root."
	exit 1
fi

# Error handling
# 
error()
{
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "$scriptPath error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "$scriptPath error on or near line ${parent_lineno}; exiting with status ${code}"
  fi

  exit "${code}"
}
trap 'error ${LINENO}' ERR

cat << "EOF"

  _____                 _ _  __             _____      _               
 |  __ \               (_) |/ /            / ____|    | |              
 | |__) |__ _ ___ _ __  _| ' / ___ _   _  | (___   ___| |_ _   _ _ __  
 |  _  // _` / __| '_ \| |  < / _ \ | | |  \___ \ / _ \ __| | | | '_ \ 
 | | \ \ (_| \__ \ |_) | | . \  __/ |_| |  ____) |  __/ |_| |_| | |_) |
 |_|  \_\__,_|___/ .__/|_|_|\_\___|\__, | |_____/ \___|\__|\__,_| .__/ 
                 | |                __/ |                       | |    
                 |_|               |___/                        |_|    

EOF

# Turn on RPi led permanently so that we know when it shut down at the end
echo 1 | sudo tee /sys/class/leds/led0/brightness > /dev/null

# Set hostname to raspikey
#
echo "Configuring hostname"
echo "raspikey" | cat > /etc/hostname
sed -Ei 's/^127\.0\.1\.1.*$/127.0.1.1\traspikey/' /etc/hosts

# Disable ipv6
#
echo "Disabling ipv6"
cat <<EOT >> /etc/sysctl.d/99-sysctl.conf

net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOT


# Configure boot config.txt and /etc/modules
#
echo "Configuring boot config.txt and /etc/modules"
mv /boot/config.txt /boot/config.txt.bak
cat <<EOT > /boot/config.txt
dtparam=audio=off
dtoverlay=dwc2
dtoverlay=pi3-disable-wifi
gpu_mem=32 # Minimise the amount of RAM used by the GPU
EOT

echo "dwc2" | cat >> /etc/modules
echo "libcomposite" | cat >> /etc/modules

# Configure boot cmdline.txt
#
sed -Ei 's/quiet//' /boot/cmdline.txt # Replace quiet parameter from /boot/cmdline.txt if exists

# Setup tmpfs /data filesystem
#
mkdir /data
echo -e "\ntmpfs /data tmpfs nodev,nosuid 0 0" | cat >> /etc/fstab
mount /data

# Redirect the standard /var/lib/bluetooth data dir to /data
#
service bluetooth stop
[ ! -d /var/lib/bluetooth ] || rm -fr /var/lib/bluetooth
ln -s /data /var/lib/bluetooth

# Enable serial console login
#systemctl enable getty@ttyGS0.service

# Disable boot waiting for dhcpd (as it delays boot)
rm /etc/systemd/system/dhcpcd.service.d/wait.conf

# Disable unneeded services
echo "Disabling unneeded services"
systemctl disable apt-daily-upgrade.timer apt-daily.timer systemd-tmpfiles-clean.timer systemd-tmpfiles-clean cron dphys-swapfile systemd-timesyncd networking
systemctl mask systemd-rfkill systemd-rfkill.socket # systemd-update-utmp systemd-update-utmp-runlevel

# Remove unneeded packages
echo "Removing unneeded packages"
apt-get remove -y triggerhappy dphys-swapfile fake-hwclock cron logrotate rsyslog
apt-get remove -y rfkill nfs-common man-db avahi-daemon wireless-tools wpasupplicant rng-tools
apt-get remove -y openssh-server openssh-sftp-server
apt-get -y autoremove --purge

# Configure raspikey_usb.service and libcomposite device to be available on first boot
#
echo "Configuring raspikey_usb.service"
chmod +x $scriptDir/raspikey_usb
cp $scriptDir/raspikey_usb.service /etc/systemd/system/
systemctl enable raspikey_usb.service

# Configure the raspikey.service
#
echo "Configuring raspikey.service"
chmod +x $scriptDir/raspikey
cp $scriptDir/raspikey.service /etc/systemd/system/
systemctl enable raspikey.service

# Convert system to readonly
echo "Converting filesystems to read-only"
/bin/bash $scriptDir/readonly-convert.sh

# Delete various temporary files
echo "Cleaning up"
swapoff -a
rm /var/swap
rm -fr /opt

# Delete the setup files
rm -f /boot/start.sh || true
rm -f $scriptDir/setup.sh || true
rm -f $scriptDir/readonly-convert.sh || true

# Delete all existing logs
rm -fr /var/log/*

# Clear history
history -c

echo "Shutting down"
shutdown -h now








