ansible-role-nginx
=========

Install nginx and create virtualhost

Requirements
------------

none

Role Variables
--------------

See [defaults/main.yml](./defaults/main.yml)

Dependencies
------------

None

Example Playbook
----------------

```
- name: Install and configure nginx
  hosts: all
  roles:
    - ansible-role-nginx
```

License
-------

BSD

Author Information
------------------

Koloskov Aleksey
