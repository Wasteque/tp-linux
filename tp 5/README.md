# TP5 : We do a little scripting

## Partie 1 : Script carte d'identité
**1. Analyse du service**

*🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie*

```
[root@localhost ~]# bash idcard.sh
Machine name :
0S Rocky Linux
Rocky Linux 9.2 (Blue Onyx)
cpe:/o:rocky:rocky:9::baseos and kernel version is 5.14.0-284.30.1.el9_2.x86_64
IP : 192.168.39.255
10.0.3.255
RAM : 3.3G memory available on 3.6G total memory
Disk : 26G space left
Top 5 processes by RAM usage :
- root         697  0.0  1.1 127680 42220 ?        Ssl  10:30   0:00 /usr/bin/python3 -s /usr/sbin/firewalld --nofork --nopid
- polkitd      806  0.0  0.6 2512472 23844 ?       Ssl  10:30   0:00 /usr/lib/polkit-1/polkitd --no-debug
- root         717  0.0  0.5 257096 21424 ?        Ssl  10:30   0:00 /usr/sbin/NetworkManager --no-daemon
- root           1  0.0  0.4 106240 17360 ?        Ss   10:30   0:00 /usr/lib/systemd/systemd --switched-root --system --deserialize 31
- root        1349  0.0  0.3  22344 13564 ?        Ss   10:31   0:00 /usr/lib/systemd/systemd --user
Listening ports :
      - 323 udp : chronyd
      -   : chronyd
      - 22 tcp : sshd
      -   : sshd
  - /root/.local/bin
  - /root/bin
  - /usr/local/sbin
  - /usr/local/bin
  - /usr/sbin
  - /usr/bin
Here is your random cat (jpg file) : https://cdn2.thecatapi.com/images/b11.jpg


```
