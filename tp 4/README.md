# TP4 : Real services

## Partie 1 : Partitionnement du serveur de stockage

*🌞 Partitionner le disque à l'aide de LVM*

*créer un physical volume (PV) :*

```[ethan@storage ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0   20G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0   19G  0 part
  ├─rl-root 253:0    0   17G  0 lvm  /
  └─rl-swap 253:1    0    2G  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk
sdc           8:32   0    2G  0 disk
sr0          11:0    1 1024M  0 rom

[ethan@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for ethan:
  Physical volume "/dev/sdb" successfully created.

[ethan@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
  
[ethan@storage ~]$ sudo pvs
  PV         VG Fmt  Attr PSize  PFree
  /dev/sdb      lvm2 ---  <2.00g <2.00g
  /dev/sdc      lvm2 ---  <2.00g <2.00g
  ```

*créer un nouveau volume group (VG) :*

    [ethan@storage ~]$ sudo vgcreate storage /dev/sdb /dev/sdc
    Volume group "storage" successfully created
    [ethan@storage ~]$ sudo pvs
    PV         VG      Fmt  Attr PSize PFree
    /dev/sdb   storage lvm2 a--  1.99g 1.99g
    /dev/sdc   storage lvm2 a--  1.99g 1.99g

*créer un nouveau logical volume (LV) : ce sera la partition utilisable :*

    [ethan@storage ~]$ sudo lvcreate -l 100%FREE -n lv_storage storage
    Logical volume "lv_storage" created.
    [ethan@storage ~]$ sudo vgs
    VG      #PV #LV #SN Attr   VSize VFree
    storage   2   1   0 wz--n- 3.98g    0

*🌞 Formater la partition*

    [ethan@storage ~]$ sudo lvdisplay
    --- Logical volume ---
    LV Path                /dev/storage/lv_storage
    LV Name                lv_storage
    VG Name                storage
    LV UUID                OcGx41-3XX6-VseN-13Z8-TyaC-Rcny-pt74xo
    LV Write Access        read/write
    LV Creation host, time storage.tp4.linux, 2024-04-08 13:17:26 +0100
    LV Status              available
    # open                 0
    LV Size                3.98 GiB
    Current LE             1020
    Segments               2
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:2

    [ethan@storage ~]$ sudo mkfs.ext4 /dev/storage/lv_storage
    mke2fs 1.46.5 (30-Dec-2021)
    Creating filesystem with 1044480 4k blocks and 261120 inodes
    Filesystem UUID: ae07851c-2a44-4661-a23d-beffc19f72ee
    Superblock backups stored on blocks:
            32768, 98304, 163840, 229376, 294912, 819200, 884736

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (16384 blocks): done
    Writing superblocks and filesystem accounting information: done

*🌞 Monter la partition*

    [ethan@storage ~]$ sudo touch /storage/test_file
    [ethan@storage ~]$ sudo echo "Hello, World!" | sudo tee -a /storage/test_file
    Hello, World!
    [ethan@storage ~]$ sudo nano /etc/fstab
    [ethan@storage ~]$ sudo mount -a
    [ethan@storage ~]$ df -h | grep '/storage'
    /dev/mapper/storage-lv_storage  3.9G   28K  3.7G   1% /storage

## Partie 2 : Serveur de partage de fichiers

*🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux*

    [ethan@storage ~]$ sudo dnf update
    Rocky Linux 9 - BaseOS                                                 10 kB/s | 4.1 kB     00:00
    Rocky Linux 9 - AppStream                                              14 kB/s | 4.5 kB     00:00
    Rocky Linux 9 - AppStream                                             1.8 MB/s | 7.4 MB     00:04
    Rocky Linux 9 - Extras                                                7.9 kB/s | 2.9 kB     00:00
    Rocky Linux 9 - Extras                                                9.4 kB/s |  14 kB     00:01
    Dependencies resolved.

    [ethan@storage ~]$ sudo dnf install nfs-utils
    Last metadata expiration check: 0:08:34 ago on Mon 08 Avr 2024 13:25:13 AM CET.
    Package nfs-utils-1:2.5.4-20.el9.x86_64 is already installed.
    Dependencies resolved.
    Nothing to do.
    Complete!

    [ethan@storage ~]$ sudo mkdir -p /storage/site_web_1
    [ethan@storage ~]$ sudo mkdir -p /storage/site_web_2
    [ethan@storage ~]$ sudo chown -R nobody /storage/site_web_1
    [ethan@storage ~]$ sudo chown -R nobody /storage/site_web_2
    [ethan@storage ~]$ sudo chmod -R 777 /storage/site_web_1
    [ethan@storage ~]$ sudo chmod -R 777 /storage/site_web_2
    [ethan@storage ~]$ sudo nano /etc/exports
    [ethan@storage ~]$

    [ethan@storage ~]$ sudo systemctl list-unit-files | grep nfs
    proc-fs-nfsd.mount                         static          -
    var-lib-nfs-rpc_pipefs.mount               static          -
    nfs-blkmap.service                         disabled        disabled
    nfs-idmapd.service                         static          -
    nfs-mountd.service                         static          -
    nfs-server.service                         disabled        disabled
    nfs-utils.service                          static          -
    nfsdcld.service                            static          -
    nfs-client.target                          enabled         disabled
    [ethan@storage ~]$ cat /etc/exports
    /storage/site_web_1   10.7.1.10(rw,sync,no_subtree_check)
    /storage/site_web_2   10.7.1.10(rw,sync,no_subtree_check)

    [ethan@storage ~]$ sudo systemctl start nfs-utils
    [ethan@storage ~]$ sudo systemctl status nfs-utils
    ● nfs-utils.service - NFS server and client services
        Loaded: loaded (/usr/lib/systemd/system/nfs-utils.service; static)
        Active: active (exited) since Mon 2024-04-08 13:49:33 CET; 14s ago
        Process: 42850 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
    Main PID: 42850 (code=exited, status=0/SUCCESS)
            CPU: 3ms

    Avr 08 13:49:33 storage.tp4.linux systemd[1]: Starting NFS server and client services...
    Avr 08 13:49:33 storage.tp4.linux systemd[1]: Finished NFS server and client services.
```
    [ethan@storage ~]$ cat /etc/exports
    /storage/site_web_1   10.7.1.10(rw,sync,no_subtree_check)
    /storage/site_web_2   10.7.1.10(rw,sync,no_subtree_check)
```
*🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux*

## Partie 3 : Serveur web