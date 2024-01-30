# TP3 : Services

## I. Service SSH
**1. Analyse du service**

*🌞 S'assurer que le service sshd est démarré*
```[ethan@localhost ~]$ systemctl status
● localhost.localdomain
    State: degraded
    Units: 285 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 1 units
    Since: Mon 2024-01-29 11:33:12 CET; 27min ago
  systemd: 252-13.el9_2
   CGroup: /
           ├─init.scope
           │ └─1 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
           ├─system.slice
           │ ├─NetworkManager.service
           │ │ └─1349 /usr/sbin/NetworkManager --no-daemon
           │ ├─auditd.service
           │ │ └─657 /sbin/auditd
           │ ├─chronyd.service
           │ │ └─688 /usr/sbin/chronyd -F 2
           │ ├─crond.service
           │ │ └─711 /usr/sbin/crond -n
           │ ├─dbus-broker.service
           │ │ ├─690 /usr/bin/dbus-broker-launch --scope system --audit
           │ │ └─696 dbus-broker --log 4 --controller 9 --machine-id 0ef46c808b7b43f48ba68b58b27f3231 --max-bytes 53687>
           │ ├─firewalld.service
           │ │ └─680 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
           │ ├─rsyslog.service
           │ │ └─681 /usr/sbin/rsyslogd -n
           │ ├─sshd.service
           │ │ └─704 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
           │ ├─systemd-hostnamed.service
           │ │ └─1619 /usr/lib/systemd/systemd-hostnamed
           │ ├─systemd-journald.service
           │ │ └─568 /usr/lib/systemd/systemd-journald
           │ ├─systemd-logind.service
           │ │ └─685 /usr/lib/systemd/systemd-logind
           │ └─systemd-udevd.service
           │   └─udev
           │     └─581 /usr/lib/systemd/systemd-udevd
           └─user.slice
             └─user-1000.slice
               ├─session-5.scope
               │ ├─1496 "login -- ethan"
               │ └─1557 -bash
               ├─session-8.scope
               │ ├─1610 "sshd: ethan [priv]"
               │ ├─1614 "sshd: ethan@pts/0"
               │ ├─1615 -bash
               │ ├─1634 systemctl status
               │ └─1635 less
               └─user@1000.service
```               
*🌞 Analyser les processus liés au service SSH*

```
[ethan@localhost ~]$ ps -ef | grep ssh
root         703       1  0 10:22 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1347     703  0 10:23 ?        00:00:00 sshd: ethan [priv]
ethan       1351    1347  0 10:23 ?        00:00:00 sshd: ethan@pts/0
ethan       1393    1352  0 10:48 pts/0    00:00:00 grep --color=auto ssh
[ethan@localhost ~]$
```

*🌞 Déterminer le port sur lequel écoute le service SSH*

```
[ethan@localhost ~]$ sudo ss -alnpt | grep ssh
[sudo] password for ethan:
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=703,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=703,fd=4))
```

*🌞 Consulter les logs du service SSH*

```
[ethan@localhost ~]$ journalctl -xe -u sshd
```

**2. Modification du service**

*🌞 Identifier le fichier de configuration du serveur SSH*

```
[ethan@localhost ssh]$ cd /etc/ssh/
[ethan@localhost ssh]$ ls
moduli      ssh_config.d  sshd_config.d       ssh_host_ecdsa_key.pub  ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub
ssh_config  sshd_config   ssh_host_ecdsa_key  ssh_host_ed25519_key    ssh_host_rsa_key
[ethan@localhost ssh]$ sudo cat sshd_config
```

*🌞 Modifier le fichier de conf*

