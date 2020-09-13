# HomeWork 16: logging

## Tasks

Настраиваем центральный сервер для сбора логов

в вагранте поднимаем 2 машины web и log
- на web поднимаем nginx
- на log настраиваем центральный лог сервер на любой системе на выбор
  - journald
  - rsyslog
  - elk
- настраиваем аудит следящий за изменением конфигов нжинкса

Особенности
- все критичные логи с web должны собираться и локально и удаленно
- все логи с nginx должны уходить на удаленный сервер (локально только критичные)
- логи аудита должны также уходить на удаленную систему

Задание со (*)
- (*) развернуть еще машину elk и таким образом настроить 2 центральных лог системы elk И какую либо еще
  - в elk должны уходить только логи нжинкса
  - во вторую систему все остальное

---

Provide central server for collecting logs

Build vagrant environment with 2 instances:
- `web` with nginx
- `log` with one of log collectors
  - `journald`
  - `rsyslog`
  - `elk`
- on `web` configure audit of nginx's configs

Notes:
- all _critical_ logs from `web` must be collected on local and remote machine
- all nginx's logs be collected only on remote machine, except _critical_ which must have local copy also
- audit logs must be collected on remote host

Task with asterisk (*)
- (*) Up second log server with ELK
  - send nginx's logs only to ELK
  - send all other logs to second log-server

## How to run

