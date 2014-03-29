Ubuntu-Diskless-Cluster
=======================

Ubuntu Diskless Cluster

# How to Use ?

Run the following scripts one by one:
```bash
scripts/00.update-and-upgrade.sh
scripts/01.install-pkg-needed-by-client.sh
scripts/02.gen_kernel_img.sh
scripts/03.install-pkg-needed-by-master.sh
scripts/04.setup-master.sh
scripts/05.install.sh
```

# How to modify client settings ?

There're 2 ways:

### The first one

Modify files (ex: rc.local) in **client.conf/**. After that, execute ```sudo ./update.sh```. This script will mount kernel image, apply new configurations, and unmount it.
  
### The second one

Use ```sudo ./mount.sh``` to mount the kernel image and chroot into it. You'll be free to modify anything in the kernel image. When you're done, just ```Ctrl + D``` to leave the image and execute ```sudo ./umount.sh``` to un-mount the file system.
