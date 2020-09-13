# HomeWork 15: monitoring

## Tasks

Настройка мониторинга

Настроить дашборд с 4-мя графиками
1. память
2. процессор
3. диск
4. сеть

настроить на одной из систем
- zabbix (использовать screen (комплексный экран))
- prometheus - grafana

* (*) использование систем примеры которых не рассматривались на занятии
  - список возможных систем был приведен в презентации

в качестве результата прислать скриншот экрана - дашборд должен содержать в названии имя приславшего

---

Monitoring

Provide dashboard with 4 graphs:
1. Memory
2. CPU
3. Disk
4. Network

Use one of the:
- zabbix (using complex screen)
- prometheus + grafana
- (*) use some other monitoring system from the lecture

## How to run

Install requirements and up vagrant environment
```shell
make all
```
It does the next things:
- create `.venv` with ansible installed
- install ansible required galaxy roles
- up vagrant instance

Then it's need to open http://127.0.0.1:13000 in a browser. Then login as `admin` with password `secret`.

There is two dashboards: custom with 4 panels and imported from grafana dashboard repo.

Also _prometheus_ and _node_exporter_ are accesible via urls:
- http://127.0.0.1:19090 - prometheus
- http://127.0.0.1:19100 - node_exporter

## How to clean

To destroy vagrant environment run
```shell
make vagrant_destroy
```
or just run the same by hands
```shell
vagrant destroy
```

## Implementation

There was 3 ansible roles created (or copied from one of previous HW):
- [ansible-role-selinux](roles/ansible-role-selinux)
- [ansible-role-prometheus](roles/ansible-role-prometheus)
- [ansible-role-node_exporter](roles/ansible-role-node_exporter)

