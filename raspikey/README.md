### Required on the reference Pi device

* Raspbian (2018-11-13-raspbian-stretch-lite).
* Libraries: libglib2.0-dev, libdbus-1-dev, libboost-all-dev, libssl-dev.

### Required on the Windows 10 build node

* VSCode, cmake 3.17+, nodejs v10.16.3+, yarn 1.9.2+.
* GCC 6.3 ARM cross compiler [toolchain](https://github.com/samartzidis/RaspiKey/releases/download/raspberry-gcc6.3.0-r5/raspberry-gcc6.3.0-r5.exe).
* NFS export / filesystem from the reference Pi device and mount it on the Windows build node.<br/>
    On the Pi node:
    ```
    sudo -s
    apt-get install nfs-kernel-server -y
    echo -e '\n/ *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)' >> /etc/exports
    exportfs -ra
    ```
    On the Windows build node:
    ```
    mount \\[rpi-IP-address]\! R:
    ```
    The Pi root filesystem should be available as R:\

