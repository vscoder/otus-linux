# HomeWork 8: bash

## Task

Пишем скрипт
написать скрипт для крона
который раз в час присылает на заданную почту
- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- все ошибки c момента последнего запуска
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска
в письме должно быть прописан обрабатываемый временной диапазон
должна быть реализована защита от мультизапуска

Write bash script for cron which send email once a hour. Emails must contain:
- Top X ip addresses with requests count from the last run;
- Top Y requested addresses count from the last run;
- All errors from the last run;
- The list of return codes (with count) from the last run;

There must be a period in email. There must be possible to run only one instance at a time.

## Implementation. Variant 1

[parser100.sh](./files/parser100.sh)

The script parses nginx's access.log for 100 lines at a time and send statistics on email.

Usage:
```shell
./parser100.sh -h
Usage: ./script.sh options
        -r|--recipient <destination email> - email address to send statistics to. Default root
        -l|--logfile <path/to/access.log> - path to nginx access.log to analyse. Default ./access.log
        -L|--lockfile <path/to/lockfile.lock> - path to lockfile. Default /tmp/script.lock
        -T|--top <num> - report top <num> results. Default 10
        -h|--help - Print this help and exit
```

### How to run

Run vagrant instance
```shell
vagrant up
vagrant ssh
```

Go to script's directory and run with or w/o argumants (in this example the script shows top 5 instead of top 10 ips/uris/etc... and sends email to local user `vagrant`)
```shell
cd /vagrant/files
./parser100.sh -T 5 -r vagrant
```

And check user's mailbox
```shell
mail
```

## Implementation. Variant 2

[parser-last.sh](./files/parser-last.sh)

Second variant. The script reads lines which were added from last run (or from beginning of file).

Important: by default it saves state to `/var/spool/nginx_log_analyzer` directory. So this path must exists and must be writeable for user who launches the script.

```shell
Usage: ./parser-last.sh options
        -r|--recipient <destination email> - email address to send statistics to. Default: 'root'
        -l|--logfile <path/to/access.log> - path to nginx access.log to analyse. Default: './access.log'
        -L|--lockfile <path/to/lockfile.lock> - path to lockfile. Default: '/tmp/script.lock'
        -S|--state-dir <path/to/state/directory> - path to directory to save state. Default: '/var/spool/nginx_log_analyzer'
        -T|--top <num> - report top <num> results. Default: 10
        -h|--help - Print this help and exit
```

### How to run

Run vagrant instance
```shell
vagrant up
vagrant ssh
```

Go to script's directory and run with or w/o argumants (in this example the script shows top 5 instead of top 10 ips/uris/etc... and sends email to local user `vagrant`)
```shell
cd /vagrant/files
./parser-last.sh -T 5 -r vagrant
```

And check user's mailbox
```shell
mail
```

It's possible to set from which line start parsing. For this you need to set `FROM_LINE=` variable value in state file (default `/var/spool/nginx_log_analyzer/state.env`)

### How to deploy

Script are deploying automatically with vagrant provisioning mechanism. 

[Provision script](./scripts/2-install.sh):
- creates systemd oneshot [service](./files/nla.service) which runs [logs analyzer](./files/parser-last.sh)
- creates systemd [timer](./giles/../files/nla.timer) to run service once a hour
- creates [config](./files/nla) to pass arguments to script
- copy log [example](./files/access.log)
