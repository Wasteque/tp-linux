# tp-2


## Partie 1 : Files and users

**I. Fichiers**
*1. Find me*

*🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur*
```
[root@localhost ~] cd home/
[root@localhost ~] ls
root
```

*🌞 Trouver le chemin du fichier de logs SSH*
```
[root@localhost ~] cd var/log/ 
```

*🌞 Trouver le chemin du fichier de configuration du serveur SSH*
```
[root@localhost ~] cd etc/ssh/
```

**II. Users**
*1. Nouveau user*

*🌞 Créer un nouvel utilisateur*

```
[root@localhost ~] sudo useradd -d /home/papier_alu marmotte
```

*2. Infos enregistrées par le système*

*🌞 Prouver que cet utilisateur a été créé*
```
[marmotte@localhost ~]$ cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu:/bin/bash
```

*🌞 Déterminer le hash du password de l'utilisateur marmotte*
```
[root@localhost ~]$ sudo cat /etc/shadow | grep marmotte
marmotte:$6$XTjzoJswhE9x4mvP$k1EEni1deXNIzjjOpfCQFcWt85t6/.BPTQ9hbXocyzVIWv5OG0wp7xosSmWbPLcDgw/LnHc6b.oW.zF/E72yq0:19745:0:99999:7:::
```

*3. Connexion sur le nouvel utilisateur*

*🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur*
```
[root@localhost ~]$ exit
logout
```

*🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte*
```
Last login: Tue Jan 23 10:17:14 CET 2024 on pts/0
[marmotte@localhost ~]$
[marmotte@localhost ~]$ ls /home/root/
ls: cannot open directory '/home/root/': Permission denied
```

## Partie 2 : Programmes et paquets

**I. Programmes et processus** *1. Run then kill*

*1. Run then kill*

*🌞 Lancer un processus sleep*
```
[root@localhost ~] sleep 1000
 root     1910  0.0  0.0   5584  1016 pts/0    S+   11:44    
 0:00 sleep 1000
```
 *🌞 Terminez le processus sleep depuis le deuxième terminal*
 ```
 [root@localhost ~] kill 1910
 Terminated
 [root@localhost ~]$
```
*2. Tâche de fond*

*🌞 Lancer un nouveau processus sleep, mais en tâche de fond*
```
[root@localhost ~]$ sleep 1000 &
[1] 1924
```
*🌞 Visualisez la commande en tâche de fond*
```
[root@localhost ~]$ jobs
[1]+  Running                 sleep 1000 &
```

*3. Find paths*

*🌞 Trouver le chemin où est stocké le programme sleep*
```
[root@localhost ~]$ ls -al /usr/bin | grep sleep
-rwxr-xr-x.  1 root root   36312 Apr 24  2023 sleep
```


*🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc*

```
[root@localhost ~]$ sudo find / -name .bashrc
[sudo] password for root:
/etc/skel/.bashrc
/root/.bashrc
/home/root/.bashrc
/home/papier_alu/.bashrc
```

*🌞 Vérifier que*
```
[root@localhost ~]$ which sleep
/usr/bin/sleep
[root@localhost ~]$ which ssh
/usr/bin/ssh
[root@localhost ~]$ which ping
/usr/bin/ping
[root@localhost ~]$
```

**II. Paquets**

*🌞 Installer le paquet*
```
[root@localhost ~] sudo dnf install git 
```
*🌞 Utiliser une commande pour lancer Git*
```
[root@localhost ~] cd /usr/bin/git
```
*🌞 Installer le paquet nginx*

```
[root@localhost ~] sudo dnf install nginx
```
*🌞 Déterminer*
```
[root@localhost ~] cd /var/log/nginx
[root@localhost ~] cd /usr/sbin/nginx
```
*🌞 Mais aussi déterminer l'adresse http ou https des serveurs où vous téléchargez des paquets*

```
[root@localhost ~]$ nslookup nginx.com
Server:         8.8.8.8
Address:        8.8.8.8#53

Non-authoritative answer:
Name:   nginx.com
Address: 185.56.152.165

[root@localhost ~]$ nslookup github.com
Server:         8.8.8.8
Address:        8.8.8.8#53

Non-authoritative answer:
Name:   github.com
Address: 140.82.121.3
```

## Partie 3 : Poupée russe 

*🌞 Récupérer le fichier meow*
```
[root@localhost ~] sudo dnf install unzip
[root@localhost ~] sudo dnf install wget

[root@localhost ~] sudo wget https://gitlab.com/it4lik/b1-linux-2023//raw/master/tp/2/meow?inline=false

[root@localhost ~]$ sudo wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
--2024-01-28 20:51:17--  https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
Resolving gitlab.com (gitlab.com)... 172.65.251.78, 2606:4700:90:0:f22e:fbec:5bed:a9b9
Connecting to gitlab.com (gitlab.com)|172.65.251.78|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 18016947 (17M) [application/octet-stream]
Saving to: ‘meow?inline=false’

meow?inline=false             100%[=================================================>]  17.18M  23.0MB/s    in 0.7s

2024-01-28 28 20:51:18 (23.0 MB/s) - ‘meow?inline=false’ saved [18016947/18016947]

[root@localhost ~] mv 'meow?inline=false' meow

```
*🌞 Trouver le dossier dawa/*
```
- commande : file meow

[root@localhost ~]$ file meow
meow: Zip archive data, at least v2.0 to extract
[root@localhost ~]$ mv meow meow.zip
meow.zip
[root@localhost ~]$ sudo unzip meow.zip
[sudo] password for root:
Archive:  meow.zip
  inflating: meow
```

*🌞 Dans le dossier dawa/, déterminer le chemin vers*

```
[root@localhost ~]$ find -size 15M
./folder31/19/file39

[root@localhost ~]$ grep "777777" -r
folder43/38/file41:77777777777

[root@localhost ~]$ find -name cookie
./folder14/25/cookie

[root@localhost ~]$ find -name ".*"
./folder32/14/.hidden_file`
```