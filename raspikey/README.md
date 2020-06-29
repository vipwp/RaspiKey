### Required libraries on the reference Pi device

* libglib2.0-dev
* libdbus-1-dev
* libboost-all-dev
* libssl-dev

Required cross compiler toolchain on Windows build node: https://github.com/samartzidis/RaspiKey/releases/download/raspberry-gcc6.3.0-r5/raspberry-gcc6.3.0-r5.exe

### To NFS export / filesystem from the reference Pi device and mount it on the Windows build node

1. sudo apt-get install nfs-kernel-server -y
2. sudo nano /etc/exports
    ```
    / *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
    ```
3.  sudo exportfs -ra

4. On the Windows build node:
    ```
    mount \\[rpi-IP-address]\! r:
    ```

