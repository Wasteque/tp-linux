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

    [ethan@node1 ssh]$ echo $RANDOM
    43579
    [ethan@node1 ssh]$ sudo nano sshd_config
    #       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

    # This is the sshd server system-wide configuration file.  See
    # sshd_config(5) for more information.

    # This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

    # The strategy used for options in the default sshd_config shipped with
    # OpenSSH is to specify options with their default value where
    # possible, but leave them commented.  Uncommented options override the
    # default value.

    # To modify the system-wide sshd configuration, create a  *.conf  file under
    #  /etc/ssh/sshd_config.d/  which will be automatically included below
    Include /etc/ssh/sshd_config.d/*.conf

    # If you want to change the port on a SELinux system, you have to tell
    # SELinux about this change.
    # semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
    #
    Port 25847
    #AddressFamily any
    #ListenAddress 0.0.0.0
    #ListenAddress ::
```
    [ethan@node1 ssh]$ sudo firewall-cmd --remove-port=22/tcp --permanent
    Warning: NOT_ENABLED: 22:tcp
    success
    [ethan@node1 ssh]$ sudo firewall-cmd --add-port=25847/tcp --permanent
    Warning: ALREADY_ENABLED: 25847:tcp
    success
    [ethan@node1 ssh]$ sudo firewall-cmd --reload
    success
    [ethan@node1 ssh]$ sudo cat sshd_config | grep Port
    Port 25847
    #GatewayPorts no
```
*🌞 Redémarrer le service*

    [ethan@node1 ~]$ sudo systemctl restart firewalld

*🌞 Effectuer une connexion SSH sur le nouveau port*

    PS C:\Users\ethan> ssh -p 25847 ethan@10.2.1.11
    ethan@10.2.1.11's password:
    Last login: Mon Jan 29 12:00:41 2024
    [ethan@node1 ~]$
## II. Service HTTP

*🌞 Installer le serveur NGINX*

    [ethan@node1 ~]$ sudo dnf install nginx
    Rocky Linux 9 - BaseOS                                                404  B/s | 4.1 kB     00:10
    Rocky Linux 9 - BaseOS                                                142 kB/s | 2.2 MB     00:15
    Rocky Linux 9 - AppStream                                             447  B/s | 4.5 kB     00:10
    Rocky Linux 9 - AppStream                                             475 kB/s | 7.4 MB     00:15
    Rocky Linux 9 - Extras                                                290  B/s | 2.9 kB     00:10
    Package nginx-1:1.20.1-14.el9_2.1.x86_64 is already installed.
    Dependencies resolved.
    Nothing to do.
    Complete!

*🌞 Démarrer le service NGINX*

    [ethan@node1 ~]$ sudo systemctl start nginx
    [sudo] password for ethan:
    [ethan@node1 ~]$ systemctl status nginx
    ● nginx.service - The nginx HTTP and reverse proxy server
    Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
    Active: active (running) since Tue 2024-04-08 09:07:19 CET; 13s ago
    Process: 905 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 906 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 907 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
    Main PID: 908 (nginx)
    Tasks: 2 (limit: 5896)
    Memory: 3.3M
    CPU: 17ms
    CGroup: /system.slice/nginx.service
    ├─908 "nginx: master process /usr/sbin/nginx"
    └─909 "nginx: worker process"

    Avr 08 09:07:19 node1.tp3.b1 systemd[1]: Starting The nginx HTTP and reverse proxy server...

*🌞 Déterminer sur quel port tourne NGINX*


    [ethan@node1 ~]$ sudo dnf update
    [ethan@node1 ~]$ sudo dnf install net-tools
    [ethan@node1 ~]$ netstat --version

    [ethan@node1 ~]$ sudo netstat -plnt | grep nginx
    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      908/nginx: master p
    tcp6       0      0 :::80                   :::*                    LISTEN      908/nginx: master p



    [ethan@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
    success
    [ethan@node1 ~]$ sudo firewall-cmd --reload
    success

*🌞 Déterminer les processus liés au service NGINX*

    [ethan@node1 ~]$ ps aux | grep nginx
    root         908  0.0  0.0  10084   300 ?        Ss   09:07   0:00 nginx: master process /usr/sbin/nginx
    nginx        909  0.0  0.2  13852  2396 ?        S    09:07   0:00 nginx: worker process
    ethan    42794  0.0  0.2   6408  2176 pts/0    S+   09:35   0:00 grep --color=auto nginx

*🌞 Déterminer le nom de l'utilisateur qui lance NGINX*


    [ethan@node1 ~]$ cat /etc/passwd | grep nginx
    nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin


*🌞 Test !*
```
  [ethan@node1 ~]$ sudo curl http://10.2.1.11:80 | head -n 7
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                  Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
  <html>
    <head>
      <meta charset='utf-8'>
      <meta name='viewport' content='width=device-width, initial-scale=1'>
      <title>HTTP Server Test Page powered by: Rocky Linux</title>
      <style type="text/css">
  100  7620  100  7620    0     0   744k      0 --:--:-- --:--:-- --:--:--  826k
  curl: (23) Failed writing body
```
*Analyser la conf de NGINX 🌞 Déterminer le path du fichier de configuration de NGINX*

    [ethan@node1 ~]$ ls -al /etc/nginx/nginx.conf
    -rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf

*🌞 Trouver dans le fichier de conf*

    [ethan@node1 ~]$ cat /etc/nginx/nginx.conf | grep server -A 10
        server {
            listen       80;
            listen       [::]:80;
            server_name  _;
            root         /usr/share/nginx/html;

            # Load configuration files for the default server block.
            include /etc/nginx/default.d/*.conf;

            error_page 404 /404.html;
            location = /404.html {
            }

            error_page 500 502 503 504 /50x.html;
            location = /50x.html {
            }
        }
    --
    # Settings for a TLS enabled server.
    #
    #    server {
    #        listen       443 ssl http2;
    #        listen       [::]:443 ssl http2;
    #        server_name  _;
    #        root         /usr/share/nginx/html;
    #
    #        ssl_certificate "/etc/pki/nginx/server.crt";
    #        ssl_certificate_key "/etc/pki/nginx/private/server.key";
    #        ssl_session_cache shared:SSL:1m;
    #        ssl_session_timeout  10m;
    #        ssl_ciphers PROFILE=SYSTEM;
    #        ssl_prefer_server_ciphers on;
    #
    #        # Load configuration files for the default server block.
    #        include /etc/nginx/default.d/*.conf;
    #
    #        error_page 404 /404.html;
    #            location = /40x.html {
    #        }
    #
    #        error_page 500 502 503 504 /50x.html;
    #            location = /50x.html {
    #        }
    #    }

```
[ethan@node1 ~]$ cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```
*Déployer un nouveau site web 🌞 Créer un site web*

```
[ethan@node1 ~]$ sudo mkdir -p /var/www/tp3_linux
```
```
[ethan@node1 ~]$ cd /var/www/tp3_linux
```
```
[ethan@node1 tp3_linux]$ sudo nano index.html
```
```
[ethan@node1 tp3_linux]$ sudo cat index.html
<h1>MEOW mon premier serveur web</h1>
```
*🌞 Gérer les permissions*

    [ethan@node1 ~]$ sudo chown -R nginx:nginx /var/www/tp3_linux
    [sudo] password for ethan:

*🌞 Adapter la conf NGINX*
    [ethan@node1 ~]$ sudo systemctl restart nginx
    [ethan@node1 ~]$ sudo nano /etc/nginx/nginx.conf

    [ethan@node1 nginx]$ ls
    [ethan@node1 nginx]$ cd conf.d
    [ethan@node1 conf.d]$ ls
    [ethan@node1 conf.d]$ sudo nano tp3.conf
    [ethan@node1 conf.d]$ echo $RANDOM
    45713
    [ethan@node1 conf.d]$ sudo nano tp3.conf
    [ethan@node1 conf.d]$ sudo systemctl restart nginx
    [ethan@node1 conf.d]$ sudo firewall-cmd --add-port=21850/tcp --permanent
    success
    [ethan@node1 conf.d]$ sudo firewall-cmd --reload
    success
*🌞 Visitez votre super site web*

    [vincent@node1 conf.d]$ curl http://10.2.1.11:21850
    <h1>MEOW mon premier serveur web</h1>

## III. Your own services