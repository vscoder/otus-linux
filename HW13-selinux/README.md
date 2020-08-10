# HomeWork 12: Authentication Authorization Accounting

## Tasks

The main target is ability to diagnose a problems and to fix SELinux policies, when it's necessary to app functioned properly.
1. Run nginx on alternative port using 3 different ways:
   - `setsebool` switch;
   - add an alternative port to existing `type`;
   - develop and install `selinux module`;
Expected result: description of every implementation in README (demos and screenshots are welcome).

2. Ensure that the application works when selinux is enabled
   - deploy attached [test environment](https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems);
   - find out why the DNS zone refresh functionality isn't working;
   - suggest a solution to the problem;
   - choose one of the solutions, justify the choice of a solution;
   - implement the solution and make a demo
Expected result:
- README with a description of the broken functionality analyse, an available solutions and a justifycation of choosed solution;
- A fixed `test environment` or a demo of the proper DNS zone refresh functionality whth a screenshots and a description.


Цель: Тренируем умение работать с SELinux: диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется.
1. Запустить nginx на нестандартном порту 3-мя разными способами:
- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.
К сдаче:
- README с описанием каждого решения (скриншоты и демонстрация приветствуются).

2. Обеспечить работоспособность приложения при включенном selinux.
- Развернуть приложенный стенд
https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems
- Выяснить причину неработоспособности механизма обновления зоны (см. README);
- Предложить решение (или решения) для данной проблемы;
- Выбрать одно из решений для реализации, предварительно обосновав выбор;
- Реализовать выбранное решение и продемонстрировать его работоспособность.
К сдаче:
- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.
Критерии оценки:
Обязательно для выполнения:
- 1 балл: для задания 1 описаны, реализованы и продемонстрированы все 3 способа решения;
- 1 балл: для задания 2 описана причина неработоспособности механизма обновления зоны;
- 1 балл: для задания 2 реализован и продемонстрирован один из способов решения;
Опционально для выполнения:
- 1 балл: для задания 2 предложено более одного способа решения;
- 1 балл: для задания 2 обоснованно(!) выбран один из способов решения.

## Documentation

### utils

Package `setools-console`:
- `sesearch`
- `seinfo`
- `findcon`
- `getsebool`
- `setsebool`
Package `policycoreutils-python`:
- `audit2allow`
- `audit2why`
Package `policycoreutils-newrole`:
- `newrole`
Package `selinux-policy-mls`:
- `selinux-policy-mls`

### contexts

Selinux contexts are at `/etc/selinux/targeted/contexts/files`

### sebool

- `sebool` flag https://wiki.centos.org/TipsAndTricks/SelinuxBooleans

Show all flags: `getsebool -a`
<details><summary>CentOS8 output</summary>
<p>

```log
authlogin_radius --> off
authlogin_yubikey --> off
awstats_purge_apache_log_files --> off
boinc_execmem --> on
cdrecord_read_content --> off
cluster_can_network_connect --> off
cluster_manage_all_files --> off
cluster_use_execmem --> off
cobbler_anon_write --> off
cobbler_can_network_connect --> off
cobbler_use_cifs --> off
cobbler_use_nfs --> off
collectd_tcp_network_connect --> off
colord_use_nfs --> off
condor_tcp_network_connect --> off
conman_can_network --> off
conman_use_nfs --> off
cron_can_relabel --> off
cron_system_cronjob_use_shares --> off
cron_userdomain_transition --> on
cups_execmem --> off
cvs_read_shadow --> off
daemons_dump_core --> off
daemons_enable_cluster_mode --> off
daemons_use_tcp_wrapper --> off
daemons_use_tty --> off
dbadm_exec_content --> on
dbadm_manage_user_files --> off
dbadm_read_user_files --> off
deny_execmem --> off
deny_ptrace --> off
dhcpc_exec_iptables --> off
dhcpd_use_ldap --> off
domain_can_mmap_files --> off
domain_can_write_kmsg --> off
domain_fd_use --> on
domain_kernel_load_modules --> off
entropyd_use_audio --> on
exim_can_connect_db --> off
exim_manage_user_files --> off
exim_read_user_files --> off
fcron_crond --> off
fenced_can_network_connect --> off
fenced_can_ssh --> off
fips_mode --> on
ftpd_anon_write --> off
ftpd_connect_all_unreserved --> off
ftpd_connect_db --> off
ftpd_full_access --> off
ftpd_use_cifs --> off
ftpd_use_fusefs --> off
ftpd_use_nfs --> off
ftpd_use_passive_mode --> off
git_cgi_enable_homedirs --> off
git_cgi_use_cifs --> off
git_cgi_use_nfs --> off
git_session_bind_all_unreserved_ports --> off
git_session_users --> off
git_system_enable_homedirs --> off
git_system_use_cifs --> off
git_system_use_nfs --> off
gitosis_can_sendmail --> off
glance_api_can_network --> off
glance_use_execmem --> off
glance_use_fusefs --> off
global_ssp --> off
gluster_anon_write --> off
gluster_export_all_ro --> off
gluster_export_all_rw --> on
gluster_use_execmem --> off
gpg_web_anon_write --> off
gssd_read_tmp --> on
guest_exec_content --> on
haproxy_connect_any --> off
httpd_anon_write --> off
httpd_builtin_scripting --> on
httpd_can_check_spam --> off
httpd_can_connect_ftp --> off
httpd_can_connect_ldap --> off
httpd_can_connect_mythtv --> off
httpd_can_connect_zabbix --> off
httpd_can_network_connect --> off
httpd_can_network_connect_cobbler --> off
httpd_can_network_connect_db --> off
httpd_can_network_memcache --> off
httpd_can_network_relay --> off
httpd_can_sendmail --> off
httpd_dbus_avahi --> off
httpd_dbus_sssd --> off
httpd_dontaudit_search_dirs --> off
httpd_enable_cgi --> on
httpd_enable_ftp_server --> off
httpd_enable_homedirs --> off
httpd_execmem --> off
httpd_graceful_shutdown --> off
httpd_manage_ipa --> off
httpd_mod_auth_ntlm_winbind --> off
httpd_mod_auth_pam --> off
httpd_read_user_content --> off
httpd_run_ipa --> off
httpd_run_preupgrade --> off
httpd_run_stickshift --> off
httpd_serve_cobbler_files --> off
httpd_setrlimit --> off
httpd_ssi_exec --> off
httpd_sys_script_anon_write --> off
httpd_tmp_exec --> off
httpd_tty_comm --> off
httpd_unified --> off
httpd_use_cifs --> off
httpd_use_fusefs --> off
httpd_use_gpg --> off
httpd_use_nfs --> off
httpd_use_openstack --> off
httpd_use_sasl --> off
httpd_verify_dns --> off
icecast_use_any_tcp_ports --> off
irc_use_any_tcp_ports --> off
irssi_use_full_network --> off
kdumpgui_run_bootloader --> off
keepalived_connect_any --> off
kerberos_enabled --> on
ksmtuned_use_cifs --> off
ksmtuned_use_nfs --> off
logadm_exec_content --> on
logging_syslogd_can_sendmail --> off
logging_syslogd_run_nagios_plugins --> off
logging_syslogd_use_tty --> on
login_console_enabled --> on
logrotate_read_inside_containers --> off
logrotate_use_nfs --> off
logwatch_can_network_connect_mail --> off
lsmd_plugin_connect_any --> off
mailman_use_fusefs --> off
mcelog_client --> off
mcelog_exec_scripts --> on
mcelog_foreground --> off
mcelog_server --> off
minidlna_read_generic_user_content --> off
mmap_low_allowed --> off
mock_enable_homedirs --> off
mount_anyfile --> on
mozilla_plugin_bind_unreserved_ports --> off
mozilla_plugin_can_network_connect --> on
mozilla_plugin_use_bluejeans --> off
mozilla_plugin_use_gps --> off
mozilla_plugin_use_spice --> off
mozilla_read_content --> off
mpd_enable_homedirs --> off
mpd_use_cifs --> off
mpd_use_nfs --> off
mplayer_execstack --> off
mysql_connect_any --> off
mysql_connect_http --> off
nagios_run_pnp4nagios --> off
nagios_run_sudo --> off
nagios_use_nfs --> off
named_tcp_bind_http_port --> off
named_write_master_zones --> on
neutron_can_network --> off
nfs_export_all_ro --> on
nfs_export_all_rw --> on
nfsd_anon_write --> off
nis_enabled --> off
nscd_use_shm --> on
openshift_use_nfs --> off
openvpn_can_network_connect --> on
openvpn_enable_homedirs --> on
openvpn_run_unconfined --> off
pcp_bind_all_unreserved_ports --> off
pcp_read_generic_logs --> off
pdns_can_network_connect_db --> off
piranha_lvs_can_network_connect --> off
polipo_connect_all_unreserved --> off
polipo_session_bind_all_unreserved_ports --> off
polipo_session_users --> off
polipo_use_cifs --> off
polipo_use_nfs --> off
polyinstantiation_enabled --> off
postfix_local_write_mail_spool --> on
postgresql_can_rsync --> off
postgresql_selinux_transmit_client_label --> off
postgresql_selinux_unconfined_dbadm --> on
postgresql_selinux_users_ddl --> on
pppd_can_insmod --> off
pppd_for_user --> off
privoxy_connect_any --> on
prosody_bind_http_port --> off
puppetagent_manage_all_files --> off
puppetmaster_use_db --> off
racoon_read_shadow --> off
radius_use_jit --> off
redis_enable_notify --> off
rpcd_use_fusefs --> off
rsync_anon_write --> off
rsync_client --> off
rsync_export_all_ro --> off
rsync_full_access --> off
samba_create_home_dirs --> off
samba_domain_controller --> off
samba_enable_home_dirs --> off
samba_export_all_ro --> off
samba_export_all_rw --> off
samba_load_libgfapi --> off
samba_portmapper --> off
samba_run_unconfined --> off
samba_share_fusefs --> off
samba_share_nfs --> off
sanlock_enable_home_dirs --> off
sanlock_use_fusefs --> off
sanlock_use_nfs --> off
sanlock_use_samba --> off
saslauthd_read_shadow --> off
secadm_exec_content --> on
secure_mode --> off
secure_mode_insmod --> off
secure_mode_policyload --> off
selinuxuser_direct_dri_enabled --> on
selinuxuser_execheap --> off
selinuxuser_execmod --> on
selinuxuser_execstack --> on
selinuxuser_mysql_connect_enabled --> off
selinuxuser_ping --> on
selinuxuser_postgresql_connect_enabled --> off
selinuxuser_rw_noexattrfile --> on
selinuxuser_share_music --> off
selinuxuser_tcp_server --> off
selinuxuser_udp_server --> off
selinuxuser_use_ssh_chroot --> off
sge_domain_can_network_connect --> off
sge_use_nfs --> off
smartmon_3ware --> off
smbd_anon_write --> off
spamassassin_can_network --> off
spamd_enable_home_dirs --> on
spamd_update_can_network --> off
squid_connect_any --> on
squid_use_tproxy --> off
ssh_chroot_rw_homedirs --> off
ssh_keysign --> off
ssh_sysadm_login --> off
ssh_use_tcpd --> off
sslh_can_bind_any_port --> off
sslh_can_connect_any_port --> off
staff_exec_content --> on
staff_use_svirt --> off
swift_can_network --> off
sysadm_exec_content --> on
telepathy_connect_all_ports --> off
telepathy_tcp_connect_generic_network_ports --> on
tftp_anon_write --> off
tftp_home_dir --> off
tmpreaper_use_cifs --> off
tmpreaper_use_nfs --> off
tmpreaper_use_samba --> off
tomcat_can_network_connect_db --> off
tomcat_read_rpm_db --> off
tomcat_use_execmem --> off
tor_bind_all_unreserved_ports --> off
tor_can_network_relay --> off
tor_can_onion_services --> off
unconfined_chrome_sandbox_transition --> on
unconfined_login --> on
unconfined_mozilla_plugin_transition --> on
unprivuser_use_svirt --> off
use_ecryptfs_home_dirs --> off
use_fusefs_home_dirs --> off
use_lpd_server --> off
use_nfs_home_dirs --> off
use_samba_home_dirs --> off
use_virtualbox --> off
user_exec_content --> on
varnishd_connect_any --> off
virt_read_qemu_ga_data --> off
virt_rw_qemu_ga_data --> off
virt_sandbox_share_apache_content --> off
virt_sandbox_use_all_caps --> on
virt_sandbox_use_audit --> on
virt_sandbox_use_fusefs --> off
virt_sandbox_use_mknod --> off
virt_sandbox_use_netlink --> off
virt_sandbox_use_sys_admin --> off
virt_transition_userdomain --> off
virt_use_comm --> off
virt_use_execmem --> off
virt_use_fusefs --> off
virt_use_glusterd --> off
virt_use_nfs --> off
virt_use_pcscd --> off
virt_use_rawip --> off
virt_use_samba --> off
virt_use_sanlock --> off
virt_use_usb --> on
virt_use_xserver --> off
webadm_manage_user_files --> off
webadm_read_user_files --> off
wine_mmap_zero_ignore --> off
xdm_bind_vnc_tcp_port --> off
xdm_exec_bootloader --> off
xdm_sysadm_login --> off
xdm_write_home --> off
xen_use_nfs --> off
xend_run_blktap --> on
xend_run_qemu --> on
xguest_connect_network --> on
xguest_exec_content --> on
xguest_mount_media --> on
xguest_use_bluetooth --> on
xserver_clients_write_xshm --> off
xserver_execmem --> off
xserver_object_manager --> off
zabbix_can_network --> off
zabbix_run_sudo --> off
zarafa_setrlimit --> off
zebra_write_config --> off
zoneminder_anon_write --> off
zoneminder_run_sudo --> off
```
</p>
</details>

Get process's selinux info
```shell
ps auxZ | grep nginx
```
```log
system_u:system_r:httpd_t:s0    root     22573  0.0  0.7  41416  3508 ?        Ss   21:42   0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
system_u:system_r:httpd_t:s0    nginx    22774  0.0  1.0  74464  5184 ?        S    21:42   0:00 nginx: worker process
```

Google says to use selinux boolean flag `httpd_can_network_connect`.

Get flag `httpd_can_network_connect` info
```shell
semanage boolean --list | grep httpd_can_network_connect\ 
```
```log
httpd_can_network_connect      (выкл.,выкл.)  Allow httpd to can network connect
```

What allows the selinux boolean `httpd_can_network_connect`?
```shell
sesearch -A -b httpd_can_network_connect
```
<details><summary>output</summary>
<p>

```log
Found 31 semantic av rules:
   allow httpd_sys_script_t httpd_sys_script_t : tcp_socket { ioctl read write create getattr setattr lock append bind connect listen accept getopt setopt shutdown } ; 
   allow httpd_sys_script_t port_type : udp_socket recv_msg ; 
   allow httpd_sys_script_t port_type : udp_socket send_msg ; 
   allow httpd_suexec_t httpd_suexec_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow httpd_suexec_t node_t : node { udp_recv recvfrom } ; 
   allow httpd_suexec_t node_t : node { udp_send sendto } ; 
   allow httpd_suexec_t node_t : node { tcp_recv tcp_send recvfrom sendto } ; 
   allow httpd_suexec_t netif_t : netif { udp_recv ingress } ; 
   allow httpd_suexec_t netif_t : netif { udp_send egress } ; 
   allow httpd_suexec_t netif_t : netif { tcp_recv tcp_send ingress egress } ; 
   allow httpd_sys_script_t httpd_sys_script_t : udp_socket { ioctl read write create getattr setattr lock append bind connect getopt setopt shutdown } ; 
   allow httpd_suexec_t port_type : udp_socket recv_msg ; 
   allow httpd_suexec_t port_type : udp_socket send_msg ; 
   allow httpd_sys_script_t client_packet_type : packet recv ; 
   allow httpd_sys_script_t client_packet_type : packet send ; 
   allow httpd_suexec_t port_type : tcp_socket name_connect ; 
   allow httpd_suexec_t port_type : tcp_socket { recv_msg send_msg } ; 
   allow httpd_suexec_t client_packet_type : packet recv ; 
   allow httpd_suexec_t client_packet_type : packet send ; 
   allow httpd_t port_type : tcp_socket name_connect ; 
   allow httpd_sys_script_t netif_t : netif { udp_recv ingress } ; 
   allow httpd_sys_script_t netif_t : netif { udp_send egress } ; 
   allow httpd_sys_script_t netif_t : netif { tcp_recv tcp_send ingress egress } ; 
   allow httpd_sys_script_t node_t : tcp_socket node_bind ; 
   allow httpd_suexec_t httpd_suexec_t : tcp_socket { ioctl read write create getattr setattr lock append bind connect listen accept getopt setopt shutdown } ; 
   allow httpd_sys_script_t node_t : udp_socket node_bind ; 
   allow httpd_sys_script_t node_t : node { udp_recv recvfrom } ; 
   allow httpd_sys_script_t node_t : node { udp_send sendto } ; 
   allow httpd_sys_script_t node_t : node { tcp_recv tcp_send recvfrom sendto } ; 
   allow httpd_sys_script_t port_type : tcp_socket name_connect ; 
   allow httpd_sys_script_t port_type : tcp_socket { recv_msg send_msg } ;
```
</p>
</details>

Enable seboolean `httpd_can_network_connect`
```shell
setsebool -P httpd_can_network_connect on
```

NOTE: It isn't work with `unreserved_port_t` selinux type (domain), ex.: `8088`.

NOTE: It isn't necessary for port `8080` because on port `8080` nginx already works without any manipulations with selinux.

Get port `8080` type:
```shell
semanage port --list | grep 8080
```
```log
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
```

List allowed rules for `http_cache_port_t`
```shell
sesearch -t http_cache_port_t -s httpd_t -Ad
```
```log
Found 2 semantic av rules:
   allow httpd_t http_cache_port_t : tcp_socket name_bind ; 
   allow httpd_t http_cache_port_t : tcp_socket name_connect ;
```

## Implementation

## TODO

- [ ] Set selinux mode `enforcement`
- [ ] Test nginx on port `8080`
- [ ] Describe and test 3 different ways
   - [ ] `setsebool` switch;
   - [ ] add an alternative port to existing `type`;
   - [ ] develop and install `selinux module`;
