# HomeWork 10: ansible

## Tasks

Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify для старта nginx после установки
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible

Prepare vagrant test environment with one or more hosts.Install nginx using ansible with next requirements:
- use `yum` or `apt` module
- use **jinja2 template** for configs, use variables in template
- nginx must be **enabled in systemd** after installation
- use `notify` to start nginx after installation (mb error here? mb u mean: use `notify` to restart ngonx after config was changed?)
- nginx site must listen on **alternative port** defined by **ansible variable**

## Implementation

- Ansible role [ansible-role-nginx](./roles/ansible-role-nginx/)
- Ansible role [documentation](./roles/ansible-role-nginx/README.md)
- Run molecule tests [description](./ANSIBLE.md)

## Vagrant environment

Create virtual environment and install ansible with requirements
```shell
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Run environment
```shell
vagrant up
```

Check result
```
curl 127.0.0.1:8081
```
Output
```
hw11-ansible-stage  ^_^
```

Check result
```
curl 127.0.0.1:8082
```
Output
```
hw11-ansible-prod  ^_^
```
