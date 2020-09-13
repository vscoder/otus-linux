## 2020-09-13

- Fix Makefile target `vagrant_up`. Replace `source` with `.`

## 2020-09-12

- Add `requirements.yml` with ansible required galaxy roles
- Update `provision.yml`: configure grafana
- Install grafana via galaxy role `cloudalchemy.grafana`
- Add Makefile targets
  - `all` - Prepare environment and up vagrant instance
  - `ansible_requirements` - Install ansible requirements
  - `vagrant_up` - Up vagrant environment
  - `vagrant_destroy` - Destroy vagrant environment
- Add grafana dashboard `dashboards/custom.json`
- Update documentation

## 2020-09-11

- Provide `provision.yml` to provision vagrant environment

## 2020-09-10

- Finish `roles/ansible-role-node_exporter`
- Add task `Provide prometheus.service state` to `roles/ansible-role-prometheus`
- Run selinux-related tasks before configuration and start service (applied to both prometheus and node_exporter roles)

## 2020-09-08

- Add `roles/ansible-role-node_exporter`. Not tested

## 2020-09-06

- Provide prometheus default config

## 2020-09-04

- Update `roles/ansible-role-prometheus`. It almost works))

## 2020-08-30

- Start HomeWork
- Create base project structure
- Add `roles/ansible-role-selinux` to ensure selinux enabled
- Create `roles/ansible-role-prometheus` role, not finished
