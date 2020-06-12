# Home work 7: SystemD

## Tasks

Выполнить следующие задания и подготовить развёртывание результата выполнения с использованием Vagrant и Vagrant shell provisioner (или Ansible, на Ваше усмотрение):
1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig);
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi);
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами;
4. ★ Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл.

Do the tasks and deploy results with Vagrant and Vagrand Shell Provosioner (or with Ansible).
1. Develop a service for log monitoring. It must search KEYWORD in log entrys every 30 seconds. KEYWORD must be configured in `/etc/sysconfig`.
2. Install `spawn-fcgi` from EPEL repository. Replace `spawn-fcgi`'s init-script with unit-file (service name must be the same: `spawn-fcgi`).
3. Update Apache's `httpd` unit-file. Add possibility to run few instances of `httpd` with different configs.
4. ★ Download Atlassian Jira demo and replace init-script with unit-file.

## Task 1: Log monitoring service

[Log monitoring service](LOGMON.md)

## Task 2: spawn-fcgi unit file

## Task 3: httpd multiple instances

## Task 4: ★ Atlassian Jira demo unit-file
