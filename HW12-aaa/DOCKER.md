# Task 2*: docker

Allow a specific user to work with docker and to restart docker service

## Information

- ACL https://www.redhat.com/sysadmin/linux-access-control-lists
- ansible `acl` module https://docs.ansible.com/ansible/latest/modules/acl_module.html
- PolicyKit https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/desktop_migration_and_administration_guide/policykit

## Implementation

Created [ansible-role-dockermgr](./roles/ansible-role-dockermgr/) which:
1. Install docker (if variable `dockermgr_install` is true).
2. Allow r/w access for users listed in the list `dockermgr_managers:` to `/var/run/docker.sock` after docker service starts using ACL.
