# vector.dev

Описание стенда с [vector.dev](https://vector.dev)

## Развертывание

Для запуска остановить systemd service и запустить из консоли от пользователя root
```
vagrant ssh hw16-web
sudo -s
systemd stop vector.service
vector -c /etc/vector/vector.yaml
```

Далее можно зайти в кибану и посмотреть логи nginx который проксирует трафик к кибане ^_^ http://127.0.0.1:1080

## Проблемы

- Не читает journald когда запущен через systemd service от имени пользователя vector
