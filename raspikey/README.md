## Development environment setup

You will need a Raspberry Pi Zero "reference" device and a Linux (x86) development PC. The Linux development PC needs to have network access to the reference device.

### Required on the reference Pi device

* Raspbian (2020-08-20-raspios-buster-armhf-lite).
* Libraries: libglib2.0-dev, libdbus-1-dev, libboost-all-dev, libssl-dev.

### Required on the Linux development PC

* cmake 3.16.3+, nodejs v10.19.0+, npm 6.14.4+, 7z, sshpass.
* GCC 8.3 arm-linux-gnueabihf cross compiler [toolchain](https://github.com/Pro/raspi-toolchain/releases/download/v1.0.1/raspi-toolchain.tar.gz).
* *Optionally:* VSCode with extensions: Task Explorer, CMake Tools, CMake, C/C++.


## Development PC setup and build instructions (Ubuntu 20.04):

### 1. Install package dependencies

```sh
sudo apt-get install -y cmake nodejs npm p7zip-full sshpass
```

### 2. Install code dependencies

```sh
sudo -s

mkdir /opt/pi-rootfs
rsync -vR --progress -rl --delete-after --safe-links pi@[Pi IP address]:/{lib,usr,opt/vc/lib} /opt/pi-rootfs

wget https://github.com/Pro/raspi-toolchain/releases/download/v1.0.1/raspi-toolchain.tar.gz
tar xvf raspi-toolchain.tar.gz -C /opt
```
> ATTENTION: Replace *[Pi IP address]* with your reference Pi device's IP address.

To optionally export/mount the reference Pi device's root FS via NFS:
```sh
sudo -s
apt-get install nfs-kernel-server -y
echo -e '\n/ *(rw,crossmnt,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)' >> /etc/exports
exportfs -ra
```

Windows client access:
```sh
mount \\[Pi IP address]\! R:
```

Linux client access:
```sh
sudo -s
mkdir /mnt/raspikey-dev
sudo mount -t nfs [Pi IP address]:/ /mnt/raspikey-dev
```

### 3. Build

```sh
git clone https://github.com/samartzidis/RaspiKey.git
cd ./RaspiKey/raspikey
sh ./configure.sh
cmake --build ./build/Release --config MinSizeRel --target pack -- -j 10
```



