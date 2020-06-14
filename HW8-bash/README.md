# Home Work 8: bash

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

## Implementation

[parser100.sh](./files/parser100.sh)

The script parses nginx's access.log for 100 lines at a time and send statistics on email.

Usage:
```shell
./script.sh -h
Usage: ./script.sh options
        -r|--recipient <destination email> - email address to send statistics to. Default root
        -l|--logfile <path/to/access.log> - path to nginx access.log to analyse. Default ./access.log
        -L|--lockfile <path/to/lockfile.lock> - path to lockfile. Default /tmp/script.lock
        -T|--top <num> - report top <num> results. Default 10
        -h|--help - Print this help and exit
```

## How to run

Run vagrant instance
```shell
vagrant up
vagrant ssh
```

Go to script's directory and run with or w/o argumants (in this example the script shows top 5 instead of top 10 ips/uris/etc... and sends email to local user `vagrant`)
```shell
cd /vagrant/files
./script.sh -T 5 -r vagrant
```

And check user's mailbox
```shell
mail
```
