# Baserole features

- package-management:
  - apt preferences (incl. proxy)
  - default packages
  - upgrade
  - add repositories
- DNS:
  - resolv.conf/glibc or systemd-resolved
  - FQDN (+reverse) 2DO (check if hostname --fqdn is not just hostname)
- SSHD configuration
- usermanagement (incl. authorized keys and sudo)
  - root
  - own users
  - log used pubkeys
  - send mail on login
- configs
  - bashrc
  - nano
  - vim
- groupmanagement
- sysctl settings
- systemd-journald settings
- machine-id regen (cloned systems)
- NTP systemd-timesyncd


If you cloned a system, make sure ssh-keys and machine-id are regenerated (run this host with extra-vars: -e "baserole_machine_id_regenerate=True baserole_openssh_gen_keys=True baserole_openssh_force_gen_keys=True"

# 2DO

- networkconfig (template)
- remove netplan? -> playbook
- ntp -> chrony?
- logrotate (existing role seems good: https://github.com/robertdebock/ansible-role-logrotate with https://github.com/robertdebock/ansible-role-logrotate/pull/8 )


# Requirements

minimum ansible version: 2.10

# Dependencies

None.

# Variables


## global

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_debug_mode_enable | Print additional debug output | boolean (true, false) | no | False |
| baserole_ipv4_enable | Enable IPv4 | boolean (true, false) | no | True |
| baserole_ipv6_enable | Enable IPv6 | boolean (true, false) | no | True |

## sysctl

sysctl is configured via sysctl module: https://docs.ansible.com/ansible/latest/collections/ansible/posix/sysctl_module.html

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_sysctl_config | Enable sysctl-config (otherwise skip) | | no | True |
| baserole_sysctl_key_value | Sysctl-parameters | dictionary with key/values (see example below) | no, but if not defined module will do nothing | not defined |
| baserole_sysctl_path | set a path for the config. Example: "/etc/sysctl.d/99-my-sysctl-settings" | text | no | /etc/sysctl.conf |
| baserole_sysctl_ignoreerrors | ignore errors about unknown keys | bool (true, false) | no | no |

Example: Enable v4 + v6 routing

```
baserole_sysctl_key_value:
  - name: IPv4 Forwarding
    key: net.ipv4.conf.all.forwarding
    value: 1
    state: present
  - name: IPv6 Forwarding
    key: net.ipv6.conf.all.forwarding
    value: 1
```

## bootloader (grub)

grub (boot-loader) configuration.

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_grub_config_enable | Enable grub-config (otherwise skip) | boolean (true, false) |no | False|
| baserole_grub_commandline | define grub-parameters (Example: switch network-interface to old eth0 scheme (kvm has ens3) "net.ifnames=0 biosdevname=0". important: Centos needs full line, so you`ll need to include all options (not just your added options like on debian-family) | text | no, but if not defined module will do nothing | not defined |
| baserole_grub_default_file | path for grub-config | text | yes | "/etc/default/grub" |

Tags:
- fqdn (just make reverse-checks)
- hostsfile (just manage /etc/hosts)
- network (both)

## Hostname configuration

If enabled: set v4+v6-records in /etc/hosts (uses dns-query of inventory_hostname, fallback is primary ip) ... and possibly other extra entries.

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_manage_hosts_file | Enable managing of /etc/hosts (otherwise skip) | boolean (true, false) |no | False|
| baserole_manage_hosts_template | Override template | text | no | hosts.j2 |
| baserole_manage_hostname | Enable managing of hostname (otherwise skip) | boolean (true, false) |no | True|
| baserole_manage_hosts_extra_entries | extend the hosts-File with custom entries | text (multiline, see example below) |no | not defined|
| baserole_check_reverserecord | Enable checking of reverse-record (otherwise skip) | boolean (true, false) |no | True|

example of extending the hosts-File with custom entries:
```
baserole_manage_hosts_extra_entries: |+
  1.2.3.4 internal_hostname1.domain.tld internal_hostname1
  5.6.7.8 internal_hostname2.domain.tld internal_hostname2
```


## DNS

DNS (Name-resolution) configuration.


|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_dns_config_enable | Enable dns-config (otherwise skip) | boolean (true, false) |no | True |
| baserole_dns_nameservers | defines used nameserver (list), see examples below. notice: most glibc-clients cannot use more than 3 nameservers. | no (but recommended to change) | 8.8.4.4, 9.9.9.9, 2001:4860:4860::8888 (google dns and quad9) | 
| baserole_dns_nameservers_fallback | defined fallback dns (systemd_resolved only!) | list of secondary dns servers | no | 1.1.1.1 |
| baserole_dns_searchdomains | searchdomain (try to find a host under these domains) Example: "domain1.tld domain2.tld" | searchdomain (text) | no | not defined | 
| baserole_dns_template_resolv_conf | overwrite template | text | no | resolv.conf.j2 |
| baserole_dns_resolv_conf_link_remove | remove the symlink to /etc/resolv.conf instead of following and writing into it (only enabled when baserole_dns_resolver_daemon is glibc) | boolean (true, false) | false |
| baserole_dns_resolver_daemon | which dns-resolver-daemon to use? | glibc, systemd-resolved | yes | glibc |
| baserole_dns_template_systemd_resolved_package_name | name of the systemd-resolved packages | text | systemd-resolved |
| baserole_dns_systemd_resolved_config_template | Name of the template | text | yes | systemd-resolved.conf.j2 |
| baserole_dns_systemd_resolved_config_target | path of config file | text | /etc/systemd/resolved.conf |
| baserole_dns_systemd_resolved_config_owner | Config file-owner | text | yes |systemd-resolve |
| baserole_dns_systemd_resolved_config_group | Config file-group | text | yes | systemd-resolve |
| baserole_dns_systemd_resolved_servicename | Name of the systemd service | text |yes | systemd-resolved.service |

v4 only:
```
baserole_dns_nameservers:
- 8.8.4.4
- 1.1.1.1
- 9.9.9.9
```
v6 only:
```
baserole_dns_nameservers:
- 2001:4860:4860::8888
- 2606:4700:4700::1111
- 2a01:4f8:0:a102::add:9999
```

## NTP (systemd-timesyncd)

see https://www.freedesktop.org/software/systemd/man/timesyncd.conf.html for information about config-directives

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_ntp_config_enable | Enable systemd-timesyncd config (otherwise skip) | boolean (true, false) | no | true |
| baserole_ntp_daemon | Which NTP daemon should be used? (currently only systemd-timesyncd implemented, see geerlingguy.ntp for classic ntpd)  | text | yes | systemd-timesyncd |
| baserole_ntp_systemd_timesyncd_package_name | Name of the package | text | yes | systemd-timesyncd |
| baserole_ntp_systemd_timesyncd_config_target | Path of the config-file | text | yes | /etc/systemd/timesyncd.conf |
| baserole_ntp_systemd_timesyncd_config_owner | Owner of the config-file | text | yes | root |
| baserole_ntp_systemd_timesyncd_config_group | Group of the config-file | text | yes | root |
| baserole_ntp_systemd_timesyncd_servicename | Name of the systemd-unit | | | systemd-timesyncd.service |
| baserole_ntp_systemd_timesyncd_template | Override template | text | no | systemd-timesyncd.conf.j2 |
| baserole_ntp_systemd_timesyncd_ntp_primary | Primarily used NTP-servers | text | yes | pool.ntp.org |
| baserole_ntp_systemd_timesyncd_ntp_fallback | Fallback NTP-servers| text | yes | 0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org |
| baserole_ntp_systemd_timesyncd_rootdistancemaxsec | Maximum acceptable root distance (time required for a packet to travel to the server) | integer | no | 5 |
| baserole_ntp_systemd_timesyncd_pollintervalminsec | The minimum poll interval for NTP messages | integer | no | 32 |
| baserole_ntp_systemd_timesyncd_pollintervalmaxsec | The maximum poll interval for NTP messages  | integer | no | 2048 |

NTP-server (primary is pool.ntp.org):
```
baserole_ntp_systemd_timesyncd_ntp_primary: "pool.ntp.org"
baserole_ntp_systemd_timesyncd_ntp_fallback: "0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org"
```


## Proxy (system-level)

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_ntp_config_enable | Enable Proxy config (otherwise skip) | boolean (true, false) | no | true |
| baserole_proxy_http_server | Define proxy for HTTP | string, example: http://user:pass@1.2.3.4:8080/ | no | empty (skip) |
| baserole_proxy_https_server | Define proxy for HTTPS | string, example: http://user:pass@1.2.3.4:8080/ | no | empty (skip) |
| baserole_proxy_ftp_server | Define proxy for FTP | string, example: http://user:pass@1.2.3.4:8080/ | no | empty (skip) |
| baserole_no_proxy | Define a list of server that will not retrived via proxy. warning: format is not standardized, see https://about.gitlab.com/blog/2021/01/27/we-need-to-talk-no-proxy/ for more information | string | no | empty (skip) |
| baserole_proxy_config | Set path for config-file | path to config-file | yes | /etc/environment |


## APT preferences (Debian only)

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_package_proxy_enable | Enable proxy config for apt | boolean (true, false) | yes | False |
| baserole_package_proxy_template | Override template | text | no | apt-proxy-server.yml | 
| baserole_package_proxy_filename | Filename of config-file for proxy settings (destination is baserole_package_vars_include_folder) | text | no | "02proxy-settings" |
| baserole_package_proxy_address (Example: "http://proxy.example.com:8080") | text | no | not defined |
| baserole_package_proxy_direct | Do not use proxy (from baserole_package_proxy_address) for internal package-sources (see example below) | string or list | no | empty |
| baserole_package_no_recommends_and_suggestions_enabled | Install only necessary packages (no recommends and suggestions) | boolean (true, false) | yes | True | 
| baserole_package_no_recommends_and_suggestions_filename | Filename of config-file for this settings (destination is baserole_package_vars_include_folder ) | text | yes | "00-no-recommends-and-suggestions" |

Examples for baserole_package_proxy_direct:
```
baserole_package_proxy_address: "mirror.domain.tld"
```
or a list:
```
baserole_package_proxy_address:
 - mirror.domain.tld
 - another.mirror.domain.tld
```

## Package Sources (currently Debian only)

Add custom package repositories.

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_package_source_enable | Enable custom package repositories |boolean (true, false) | yes | True |
| baserole_packagesources | | 

general scheme:
```
baserole_packagesources:
- name: my_1st_repo
  repotype: deb|rpm (required)
  filename: "reponame.list"
  deb_line: "deb http://url.domain.tld/deb/ distribution main
  gpg_url: "https://url.domain.tld/gpg.key"
  pgp_id: "HEX-ID of GPG-Key" -> required-for-absent
  validate_certs: yes|no (default: yes)
  state: absent|present (default: present)
- name: my_2nd_repo
  (...)
```

Example:
```
baserole_packagesources:
- name: sury-php
  repotype: deb
  filename: "sury-php.list"
  deb_line: "deb https://packages.sury.org/php/ {{ ansible_distribution_release }} main"
  gpg_url: "https://packages.sury.org/php/apt.gpg"
  pgp_id: "15058500A0235D97F5D10063B188E2B695BD4743"
  state: present
```

## Package defaults install

Installs a list of default packages, of course this is highly subjective so change this.

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_package_install_default_enable | Enable install of default packages (in general) | boolean (true, false) | yes | True |
| baserole_package_cache_valid_time | Do net refresh when packagelist is not older than time (works only on Debian-family) | time in seconds | yes | 86400 |
| baserole_package_defaults_debian | List of default packages (Debian) for virtual systems | text (list) | yes | bzip2, curl, dnsutils, ethtool, gpg, gpg-agent, htop, iftop, iotop, iputils-ping, less, lsof, lsscsi, mc, net-tools, pciutils, psmisc, rsync, sudo, sysstat, traceroute, unzip |
| baserole_package_defaults_redhat | List of default packages (Redhat) for virtual systems | text (list) | yes | bind-utils, bzip2, curl, epel-release, ethtool, gpg, iotop, iputils, less, lsof, net-tools, pciutils, rsync, sudo, sysstat, tcpdump, traceroute, unzip |
| baserole_package_extra_baremetal_enable | Enable install of default packages on baremetal | boolean (true, false) | yes | True |
| baserole_package_baremetal_debian | List of default packages (Debian) for physical systems | list |yes | ethtool, memtest86+, smartmontools |
| baserole_package_baremetal_redhat | List of default packages (Redhat) for physical systems | list | yes | ethtool, memtest86+, smartmontools |

Variables baserole_package_defaults_debian, baserole_package_defaults_redhat, baserole_package_baremetal_debian and baserole_package_baremetal_redhat needs to be a list, Example:

```
baserole_package_defaults_debian:
  - bzip2
  - curl
  - dnsutils
```

### package upgrades

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_package_upgrade_enable | Enable updating packages | boolean (true, false) | yes | True |


### Virtualization tools

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_package_guest_agent_enable | Enable Guest tools for implemented virtualization solutions | boolean (true, false) | yes | True |
| baserole_package_guest_agent_qemu_package | | text | | qemu-guest-agent| 
| aserole_package_guest_agent_qemu_service | | text | | qemu-guest-agent | 
| baserole_package_guest_agent_vmware_package | | text | | open-vm-tools | 
| baserole_package_guest_agent_vmware_service | | text | | open-vm-tools | 
| baserole_package_unwanted_packages_remove_enabled | Enable removing unwanted packages | boolean (true, false) | yes | False | 
| baserole_package_unwanted_packages_debian | Remove these packages (Debian) | list | yes | [] (empty) |
| baserole_package_unwanted_packages_redhat | Remove these packages (Redhat) | list | yes | [] (empty) |

## SSHD

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_sshd_config_enable | Enable SSHD configuration | boolean (true, false) | yes | True |
| baserole_openssh_use_template | Use template for /etc/ssh/sshd.conf (or includes via baserole_openssh_sshd_opts) | boolean (true, false) | yes | True |
| baserole_openssh_template_sshd | Optional override of template for main SSHD config | text | yes | sshd_template.j2 |
| baserole_openssh_template_default | Optional override of template for sourced options | text | yes | "sshd_default_template.j2" |
| baserole_openssh_sshd_opts | List of sshd-options to be included in /etc/default/ssh | text | yes | "-o TCPKeepAlive=no -o ClientAliveInterval=180 -o DebianBanner=no" |
| baserole_openssh_include_pattern | Specify Include-Pattern | text | yes | "/etc/ssh/sshd_config.d/*.conf" |
| baserole_openssh_port | TCP-Portnumber of SSH | integer (valid ports are 1-65535) | yes | 22 |
| baserole_openssh_gen_keys | Enable ssh_key generation in general | boolean (true, false) | yes | False (leave generated keys, usually when sshd-server is installed) |
| baserole_openssh_force_gen_keys | Force regeneration of host_keys, useful for cloned systems (needs "baserole_openssh_gen_keys: True" too!) | boolean (true, false) | False |
| baserole_openssh_host_key | List of hostkeys (see example below) | list | yes | /etc/ssh/ssh_host_rsa_key, /etc/ssh/ssh_host_ecdsa_key, /etc/ssh/ssh_host_ed25519_key |
| baserole_openssh_key_types | List of keytypes (see example below) | list | yes | rsa, ecdsa, ed25519 |
| baserole_openssh_skip_include | Skip include directive when True | boolean (true, false) | yes | False |
| baserole_openssh_permitrootlogin | Defines how user "root" is able to login | text: yes, no, prohibit-password, forced-commands-only | not set (usually defaults to "without-password") |
| baserole_openssh_tcpkeepalive | TCP-keepalive | text ("yes", "no") | yes | yes (recommended: "baserole_openssh_tcpkeepalive: no" and "baserole_openssh_clientaliveinterval: 180" ClientAliveInterval is more stable and secure than "TCPKeepAlive yes" |
| baserole_openssh_permituserenvironment| PermitUserEnvironment (usually not needed,  | boolean (true, false) | yes | False|
| baserole_openssh_sshrc_enable | Enable sshrc config | boolean (true, false) | yes | False |
| baserole_openssh_sshrc_template | Override template | boolean (true, false) | yes | "sshrc.j2" |
| baserole_openssh_pubkey_used_logging | Enables logging which pubkey was used to login, see "sshrc.j2" for more information | boolean (true, false) | yes | False |
| baserole_openssh_send_mail_on_login | Enable notifications of Userlogins via mail (needs working mailrelay-setup) | boolean (true, false) | yes | False |
| baserole_openssh_send_mail_to | Recipient for notifications of Userlogins | text (mail-address) | yes | root |

Examples:
```
baserole_openssh_host_key:
- /etc/ssh/ssh_host_rsa_key
- /etc/ssh/ssh_host_ecdsa_key
- /etc/ssh/ssh_host_ed25519_key

baserole_openssh_key_types:
- rsa
- ecdsa
- ed25519
```

## USER root

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_root_authorizedkeys | Define local file-path with pubkeys for user root (uploaded to /root/.ssh/authorized_keys) | text, example: /home/user/ansible-repo/pubkeys/pubkeys-root | no | not defined |
| baserole_root_password_hash | Define password-hash (will go to /etc/shadow) | text, Example: "$hashed_password" | no | not defined |
| baserole_root_ssh_key_file_name | Filename (relative to /root/) to store the SSH-key of root | text | no | ".ssh/id_ed25519" |
| baserole_root_ssh_key_file_content | Content of the SSH-privatekey | text (multiline, see Example) | no | not defined | 

```
baserole_root_ssh_key_file_content: |+
  -----BEGIN OPENSSH PRIVATE KEY-----
  (content)
  -----END OPENSSH PRIVATE KEY-----
```

## USER management

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_usercreate_config_enable | Enable Usermanagement configuration | boolean (true, false) | no | True |
| baserole_users_remove_userdata_when_state_absent | Remove user-data (home-dir etc.) when state is set to "absent" | boolean (true, false) | yes | False |
| baserole_userlist_local | Defines local Users to be managed on target system | dictionary (see Examples below) | no | not defined |


see https://docs.ansible.com/ansible/latest/collections/ansible/builtin/user_module.html

|Attributes of baserole_userlist_local|Description|possible values|required|default| 
|---|---|---|---|---|
| name | username | text | yes | empty |
| group | group(s) | text | no | empty |
| group_primary  | primary group(s) | text | no | empty |
| group_secondary | secondary/supplemental group(s) membership(s) | text, comma seperated list | no | empty |
| group_append | true: append group(s), false: set group(s) exactly as given | boolean (true, false) | no | empty |
| conditional_hostgroup | Create this user only when this ansible-group (membership) is present (in inventory or dynamically assigned) | | | empty |
| home | home-directory | text (path) | any valid path | no | /home/$name |
| uid | Set specific user id | int (number 1-999 für sysaccounts or 1000-60000, depending on distribution) | no | |
| state | Set state | text | "present" or "absent" | no | present |
| comment | Comment for this user | text | | no |
| password | Set user-password to this crypted value | text, password-hash (create a disabled account: '!' or '*' (Linux) or '*************' (OpenBSD) | no | |
| update_password | Update passwords if they differ | text | always, on_create (only on first creation) | on_create |
| system | Create a System-user (UID below 1000) | boolean (yes, no) | no | no |
| shell | Set Shell | text | path to shell "/bin/bash" | no | |
| create_home | Whether or not to create the home directory | text | no | yes |
| move_home | Whether or not to move an existing home directory | boolean (yes, no) | no | no |
| skeleton | Set a home skeleton directory, requires create_home | | | |
| expires | Expire Daten | epoch time, negative time-values to remove (since ansible 2.6) | no | |
| remove | Try to remove homedir when state=absent, the behavior is the same as `userdel --remove` | no (default) | yes
| force | The behavior is the same as `userdel --force` | boolean (yes, no) | no | no |
| non_unique | this option allows to change the user ID to a non-unique value | boolean (yes, no) | no | no |
| generate_ssh_key | Generate SSH-key for this user | boolean (yes, no) | no | no |
| ssh_authorizedkeys_file | path to file to upload as a authorizedkeys (as a whole file). If you just want to add/remove pubkeys (and keep the rest of file untouched: see var "baserole_authorizedkeys" instead) | text | no | no |
| ssh_key_bits | Specify number of bits in SSH key to create | integer | no | default set by ssh-keygen, 4096 for rsa recommended |
| ssh_key_comment | Comment-block for ssh-pubkey (i.e. email-address, computername etc.) | text | no | no |
| ssh_key_file_content | Content of keyfile | jinja-multine-string (contains the private key, see "baserole_root_ssh_key_file_content" as example), if provided ssh_key_file_name must be defined too! | no | no |
| ssh_key_file_name | Specify the filename for SSH private key, useful hint: generate pubkey from private key with (rsa): `ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub` ) | text | no |  defaults to ".ssh/id_rsa" but ".ssh/id_ed25519" or any other value is possible |
| ssh_key_passphrase | Passphrace protecting the private key | string | no | |
| ssh_key_type | specify type of SSH-Key (to generate it) | text (rsa, ed25519) | no | rsa |
| sudofilename | Filename for sudoers-file | text | no | defaults to username |
| sudo_pass | Sudo WITH password | boolean (true, false) | no | |
| sudo_nopass | Sudo WITHOUT password | boolean (true, false) | no | |
| sudo_commands | text, example "optional/sudo/command/allowed/for/sudo" | no | |
| default_editor | Set default editor here | text | no | empty |

Example two local users, alice has sudo without password, bob not):
```
baserole_userlist_local:
  - username: alice
    password: $6$hash_of_alice_password
    sudo_nopass: True
    # only add user when host has this group:
    conditional_hostgroup: hosts_with_alice
  - username: bob
    password: $6$bob_hash
    shell: /bin/sh
    group: bob, additionalgroup
    sudo_group: True
  - username: normaluser
    password: $6$normaluser_hash
    shell: /bin/bash
```

### Add/Remove pubkeys in file authorized_keys:

instead of uploading a whole file (via ssh_authorizedkeys_file in baserole_userlist_local) there is also the possibility to add/remove specific pubkeys. (using both option might not make sense since the file might be changed on every run if both methods overwrite each others changes).

```
baserole_authorizedkeys:
  - username: root
    # list of pubkeys to be present for root
    state: present
    # remove all other keys? (optional)
    exclusive: false
    # options for SSH? (optional)
    key_options: 'no-port-forwarding,from="1.2.3.4"'
    pubkeys:
      - needed_pubkey1
      - needed_pubkey2
  - username: root
    # list of pubkeys to be removed for root
    state: absent
    pubkeys:
       - unwanted_pubkey1
  - username: my_user
    # list of pubkeys to be present for my_user
    pubkeys:
       - pub1
```

a pubkey definition could be from:
- string like "ssh-rsa AAAAB3NzaC1y... my_comment"
- url: "{{ lookup('url', 'https://github.com/charlie.keys', split_lines=false) }}"
- file: "{{ lookup('file', '/home/charlie/.ssh/id_rsa.pub') }}"
- from ENV: "{{ lookup('env','MY_PUBKEY') }}"
- file and ENV combined: "lookup('file', lookup('env','HOME') + '/.ssh/id_rsa.pub') }}"

more Information for the module ansible.posix.authorized_key: https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html


### Options for users

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_default_editor | Set default Editor | text | yes | vim |
| baserole_users_optional_tasks_enable | Enable Inclusion of optional tasks | boolean (true, false) | no | False |
| baserole_users_optional_tasks_template | Filename of template for optional tasks | text | yes (when baserole_users_optional_tasks_enable is True) | optional-tasks-for-users.yml |
| baserole_bashrc_configure | Enable bash config | boolean (true, false) | no | True |
| baserole_bashrc_template | Filename of template for bash | text | yes | bashrc.j2 |
| baserole_vimrc_configure | Enable vim config | boolean (true, false) | no | True |
| baserole_vimrc_template | Filename of template for vim | text | yes | vimrc.j2 |
| baserole_nanorc_configure | Enable nano config | boolean (true, false) | no | True |
| baserole_nanorc_template | Filename of template for nano | text | yes | nanorc.j2 |
| baserole_htoprc_configure | Enable htop config | boolean (true, false) | no | True |
| baserole_htoprc_template | Filename of template for htop | text | yes | htoprc.j2 |


## GROUP management

more information see: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/group_module.html

|Valid attributes in baserole_grouplist_local dictionary|Description|possible values|required|default|
|---|---|---|---|---|
| groupname | Name of Group | text | yes | |
| gid | Group ID | int (number 1-999 für sysgroups or 1000-60000, depending on distribution) | no | |
| state | Should group exist or not | absent, present | no | present |
| non_unique | this option allows to change the group ID to a non-unique value | boolean (yes, no) | no | no |
| system | If yes, indicates that the group created is a system group (GID below 1000) | boolean (yes, no) | no | no |
| sudofilename | Filename for sudoers-file | text | no | defaults to groupname |
| sudo_pass | Grant group sudo WITHOUT password (when True) | boolean (true, false) | no | False |
| sudo_nopass | Grant group sudo WITH password (when True | boolean (true, false) | no | False |

Example for group "admins" (sudo without password):
```
baserole_grouplist_local:
- groupname: admins
  sudo_nopass: True
```


## machine-id

Generate a random machine-id (useful for cloned systems).

! attention: changing the machine-id can have unwanted consequences, examples:
- https://wiki.debian.org/MachineId
- https://unix.stackexchange.com/questions/191313/why-is-my-systemd-journal-not-persistent-across-reboots

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_machine_id_regenerate | Enable machine-id feature | boolean (true, false) | False |
| baserole_machine_id_filename: | Path of machine-id file | text | yes | /etc/machine-id |


## systemd-journald

see journald.conf(5) for details or https://www.freedesktop.org/software/systemd/man/journald.conf.html
If variables are not set, config-file will show commented out variable with default.

Note: set values for journald itself with "quotes", otherwise ansible will convert values into true and false (which journald does not like, it expects yes or no)!

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_journald_config_enable | Enable systemd-journald feature | boolean (true, false) | yes | True
| baserole_journald_template | yes | journald.conf.j2 |
| baserole_journald_storage | Controls where to store journal data | text, one of "volatile", "persistent", "auto" and "none" | no | auto |
| baserole_journald_compress | If enabled; data objects that shall be stored in the journal and are larger than the default threshold of 512 bytes are compressed before they are written to the file system | text (yes, no) | no | enabled |
| baserole_journald_seal | If enabled and a sealing key is available (as created by journalctl(1)'s --setup-keys command), Forward Secure Sealing (FSS) for all persistent journal files is enabled | text ("yes", "no") | no | yes | 
| baserole_journald_splitMode | Controls whether to split up journal files per user | text, "uid" or "none" | no | uid |
| baserole_journald_syncintervalsec | The timeout before synchronizing journal files to disk | text (time-defintion with units: "s", "min", "h", "ms", "us") | no | 5m | 
| baserole_journald_ratelimitintervalsec | Configures the rate limiting that is applied to all messages generated on the system | text (time-defintion) | no | 30s |
| baserole_journald_ratelimitburst | Configures the rate limiting that is applied to all messages generated on the system | text | no | 10000 |
| baserole_journald_systemmaxuse | Control how much disk space the journal may use up at most (Specify values in bytes or use K, M, G, T, P, E as units; example: "2G") | text | no | empty |
| baserole_journald_systemkeepfree | Control how much disk space systemd-journald shall leave free for other uses | text | no | empty |
| baserole_journald_systemmaxfilesize | Control how large individual journal files may grow at most | text | no | empty (one eighth of the values configured with SystemMaxUse) |
| baserole_journald_systemmaxfiles | Control how many individual journal files to keep at most | int | no | 100 |
| baserole_journald_runtimemaxuse | Control how much disk space the journal may use up at most | text | values in bytes or use K, M, G, T, P, E as units for the specified sizes (equal to 1024, 1024², … bytes) | no | |
| baserole_journald_runtimekeepfree | Control how much disk space systemd-journald shall leave free for other uses |
| baserole_journald_runtimemaxfileSize | Control how large individual journal files may grow at most | text | no | one eighth of the values configured with RuntimeMaxUse |
| baserole_journald_runtimemaxfiles | Control how many individual journal files to keep at most | int | no | 100 |
| baserole_journald_maxretentionsec | The maximum time to store journal entries | time in seconds (0 to disable), may be suffixed with the units "year", "month", "week", "day", "h" or " m" | no | |
| baserole_journald_maxfilesec | The maximum time to store entries in a single journal file before rotating to the next one | text (time-defintion) | no | 1month |
| baserole_journald_forwardtosyslog | Control whether log messages received by the journal daemon shall be forwarded to a traditional syslog daemon | text ("yes", "no") | no | "yes" (or "no" depending on distribution) |
| baserole_journald_forwardtokmsg | Control whether log messages received by the journal daemon shall be forwarded to the kernel log buffer (kmsg) | text ("yes", "no") | no | no |
| baserole_journald_forwardtoconsole | Control whether log messages received by the journal daemon shall be sent to system console | text ("yes", "no") | no | no |
| baserole_journald_forwardtowall | Control whether log messages received by the journal daemon shall be sent as wall messages to all logged-in users | text ("yes", "no") | no | yes |
| baserole_journald_ttypath | Change the console TTY  | text | no | /dev/console |
| baserole_journald_maxlevelstore | Controls the maximum log level of messages that are stored in the journal or forwarded | text | no | debug |
| baserole_journald_maxlevelsyslog | Controls the maximum log level of messages that are stored in the journal or forwarded | text | | no | debug |
| baserole_journald_maxlevelkmsg  | Controls the maximum log level of messages that are stored in the journal or forwarded | text | no | notice |
| baserole_journald_maxlevelconsole | Controls the maximum log level of messages that are stored in the journal or forwarded | text | no | info |
| baserole_journald_maxlevelwall | Controls the maximum log level of messages that are stored in the journal or forwarded | text | no | emerg |
| baserole_journald_linemax | The maximum line length to permit when converting stream logs into record logs | text | no | 48K |
| baserole_journald_readkmsg | If enabled systemd-journal processes /dev/kmsg messages generated by the kernel| text ("yes", "no") | no | yes |
| baserole_journald_audit | If enabled systemd-journal will turn on kernel auditing on start-up | text ("yes", "no") | no |no |

Note: some distributions (like Debian 12) have removed traditional (r)syslog in favor of systemd-journald, if you want to reverse that behaviour: use baserole_journald_forwardtosyslog: "yes" and add your favorite syslog-daemon (like rsyslog) to the list of default packages (see section "Package defaults install").
Additionally you might want to limit the usage with "baserole_journald_systemmaxuse".

## CA trusted (for SSL/TLS)

Add custom CAs into trust-store.

|Variable|Description|possible values|required|default|
|---|---|---|---|---|
| baserole_ca_config_enable | desc | boolean (false, true) | no | false |
| baserole_ca_files | List of CA-files (PEM-format) to copy into the target and update trust | yes (if "baserole_ca_config_enable: true") | not set |

Example: CA1.crt and CA2.crt from folder ./certs/internal-ca (relative to playbook):

baserole_ca_files
- ./certs/internal-ca/CA1.crt
- ./certs/internal-ca/CA2.crt



License
============

GPL-3.0-or-later


Author Information
==================

selfhostx
