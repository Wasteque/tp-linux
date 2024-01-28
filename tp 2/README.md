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

🌞 Vérifier que
- commande : which
[quentin@localhost ~]$ which sleep
/usr/bin/sleep
[quentin@localhost ~]$ which ssh
/usr/bin/ssh
[quentin@localhost ~]$ which ping
/usr/bin/ping
[quentin@localhost ~]$