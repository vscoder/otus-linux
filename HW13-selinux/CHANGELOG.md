## 2020-08-07

- Update `molecule/default/molecule.yml` expose nginx ports
- Update `molecule/default/converge.yml` set values for
  - `nginx_selinux_mode`
  - `nginx_site_listen`
  - Add `post_tasks` with nginx availability checks

## 2020-08-06

- Update `./roles/ansible-role-nginx/tasks/selinux.yml`. Add selinux policy and mode configuration.
- Rename `./roles/ansible-role-nginx/molecule/deocker-testinfra` to `./roles/ansible-role-nginx/molecule/docker-testinfra`
- Add tests to `./roles/ansible-role-nginx/molecule/default/tests/test_default.py`

## 2020-08-04

- Start HW
- Create `README.md`, `Makefile`, `requirements.txt`, `Vagrantfile`
- Add [Makefile](./Makefile) targets
  - `create:`
  - `converge:`
  - `verify:`
  - `destroy:`
  - `test:`
  - `clean: destroy`

- Rename instance name in `Vagrantfile`
- Create `provision/` with samble provisioning bash script
- Copy `roles/ansible-role-nginx` from _HW11-ansible_
- Rename molecule scenario `default` to `docker-testinfra`
- Create molecule scenrio `default` with driver `vagrant` and verifier `testinfra`
  ```shell
  molecule init scenario --driver-name vagrant --role-name ansible-role-nginx --verifier-name testinfra vagrant-testinfra
  ```
- Update `HW13-selinux/roles/ansible-role-nginx/molecule/default/molecule.yml` set instances list to
  - vscoder/centos-7-5
  - centos/7
  - centos/8
