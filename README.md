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
