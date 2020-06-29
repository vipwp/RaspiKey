### Required libraries for building on vanilla Ubuntu 18.04
* libglib2.0-dev
* libdbus-1-dev
* libboost-all-dev
* libssl-dev

Cross compiler toolchain: http://sysprogs.com/getfile/478/raspberry-gcc6.3.0-r5.exe 

To add the toolchain to VSCode edit ```C:\Users\[username]\AppData\Local\CMakeTools\cmake-tools-kits.json``` and add:
```
{
    "name": "arm-linux-gnueabihf",
    "visualStudio": "8b5a544e",
    "compilers": {
      "C": "C:\\SysGCC\\raspberry\\bin\\arm-linux-gnueabihf-gcc.exe",
      "CXX": "C:\\SysGCC\\raspberry\\bin\\arm-linux-gnueabihf-g++.exe"
    },
    "toolchainFile": "${workspaceFolder}\\toolchain.cmake"
  }
```

### To NFS FS export foor FS from rpi0
1. sudo apt-get install nfs-kernel-server -y
2. nano /etc/exports
    ```
    / *(rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
    ```
3.  sudo exportfs -ra

### To mount NFS volume R: on the Windows build node:
```mount \\[rpi-IP-address]\! r:```

