Roadmap
=======

**ansible frontends**
  - semaphore: [example playbook](playbook/semaphore.yml) https://github.com/stefanux/ansible-role-semaphore (forked from morbidick.semaphore) focussing on manual install
    thulium_drake.ansible_semaphore / https://github.com/Thulium-Drake/ansible-role-ansible_semaphore (features package install)
  - rundeck
  - awx [manual instructions](instructions/awx-manual-install.txt)
  - tower

**Backup**
  - **bacula** https://github.com/selfhostx/ansible/blob/main/roles/bacula
  - bareos (veselahouba.bareos)
  - *Borg+Borgmatic (if maintainer is found)*
  - *restic (if maintainer is found)*
  - mysql/mariadb (-> geerlingguy.mysql )
    - fulldump (SQL commands):
      - mysqlbackup https://github.com/stefanux/ansible-mysqlbackup
    - other methods:
      - FIXME
  - proxmox backup server (FIXME checkin Code)
  - pfsense config (2DO https://github.com/pfsensible/core ?)
  - opensense config (2DO https://github.com/naturalis/ansible-opnsense ?)
  - *etckeeper (if maintainer is found)*

**Git**
  - git (client) -> geerlingguy.git
  - gitea https://github.com/stefanux/ansible-role-gitea ( -> maintainer needed)
  - gitlab -> geerlingguy.gitlab


**Filesystems**
  - ZFS
    - vanilla install (2DO, planned)
    - Pool management (create, by-id-devices via vars)
    - special-usecases:
      - Proxmox https://github.com/bashclub/proxmox-zfs-postinstall
      - Samba shadow-copies "Zamba" https://github.com/bashclub/zamba-lxc-toolbox/
    - ZFS autosnapshot
      - snapshot house-keeping: zfs-keep-and-clean https://github.com/bashclub/zfs-housekeeping
      - monitoring like check-zfs-replication https://github.com/bashclub/check-zfs-replication
  - ceph (?)
  - glusterfs (?)

**Virtualization**
  - proxmox (including cloud-init) -> see folder: [playbooks/proxmox](playbooks/proxmox)
    - VM management: https://github.com/mikaelflora/ansible-role-proxmox-vm
    - *LXC*
    - balancing:
      - PVE Balance: https://github.com/PLUTEX/pve_balance
      - proxmox_migrate.py: https://github.com/HeinleinSupport/proxmox-tools/blob/master/proxmox_migrate.py
  - [libvirt](roles/libvirt)+KVM (including cloud-init)
  - *ovirt? (if maintainer is found)*
  - Container
    - *k3s (if maintainer is found)*
    - *k8s (if maintainer is found)*
    - docker (swarm)
      - installation https://github.com/stefanux/ansible-role-docker -> substitute with upstream: https://github.com/geerlingguy/ansible-role-docker compare: https://github.com/stefanux/ansible-role-docker/compare/master...geerlingguy:master
      - registry
        - ...?
      - optional management tools:
        - portainer
        - traefik

**Instant messenger**
  - [mattermost](roles/mattermost)
  - *matrix-synapse / element-web (if maintainer is found)*
  - *rocket.chat (if maintainer is found)*
  - *zulip (if maintainer is found)*

**Filesharing**
  - samba
    - standalone (2DO: merge shadowcopy + fruit from bashclub + ZFS) geerlingguy.samba / https://github.com/stefanux/ansible-role-samba.git
    - AD-member "zmb-member" https://github.com/bashclub/zamba-lxc-toolbox
  - nextcloud (-> https://github.com/JGoutin/ansible_home/tree/master/roles/nextcloud ?)
  - S3
    - minio
    - ceph RGW
  - SSH sftpgo
  - *SeaweedFS (if maintainer is found)*
  - *OpenMediaVault / TrueNAS Core? (if maintainer is found)*

**Webserver**
  - nginx [nginx_common](roles/nginx_common)
    - reverse-proxy ( geerlingguy.nginx ?)
  - caddy (2DO)
  - apache ( -> geerlingguy.apache )
    - apache only (simple static sites)
    - redirector
    - LAMP  (-> geerlingguy.php geerlingguy.php-versions )
      - mod_php
      - php-fpm (2DO)
  - All-in-one-packages
    - froxlor  (FIXME Code ready)
    - *ispconfig (maintainer needed)*

**TLS-cert + CA-management**
  - letsencrypt
    - certbot -> https://github.com/selfhostx/ansible-role-certbot
    - helper-scripte -> deploy_hook (FIXME code commit)
  - certificate distribution
    - own certs (individual, wildcards) -> Code available
    - vaulted files via sops https://github.com/mozilla/sops ? 2DO)
  - internal CAs:
    - creates certs for hosts) -> 2DO
    - distribute CAs (will be implemented in baserole)

**E-Mail**
  - mailserver
    - dovecot + postfix (2DO)
      - stand-alone
      - backends like LDAP
    - mailcow (FIXME, Code ready, publish)
    - imapsync ( https://www.bachmann-lan.de/imapsync-unter-debian-11-installieren/ )?
  - groupware
    - kopano (maintainer needed)
    - ...?
  - local mailrelay ("satellite")-setup for cron etc.
    - postfix https://github.com/stefanux/ansible-postfix-mailrelay -> can use any SMTP-accounts (2DO include examples for microsoft365, google, a few common providers)
  - archiving
    - (mail-)piler (maintainer needed)
  - spamfiltering
    - rspamd (need redis)
    - spamassassin/policy-weightd/postgrey
  - newsletter: mailman, listmonk, mautic (more a CRM), ...?

**VPN**
  - openvpn
  - wireguard
    - p2p ( githubixx.ansible_role_wireguard https://github.com/githubixx/ansible-role-wireguard ? )
    - server/client
  - ipsec strongswan (2DO, but low prio because usually this is done on firewalls and wireguard is simpler)
  - *(stunnel -> needed?)*

**DNS**
  - **self-hosted:**
    - recursive
      - dnsdist (-> powerdns.dnsdist ) + powerDNS-recursor (-> powerdns.pdns_recursor) (clustering: keepalived, csync2-sync of certificates when letsencrypt is used, nginx-reverse-proxy for statuspage), including DoT (DNS over TLS)
      - *bind (2DO -> maintainer needed)*
      - *unbound (2DO -> maintainer needed)*
    - autoritative
      - PowerDNS Authoritative (-> powerdns.pdns )
      - *bind -> 2DO: maintainer needed*
    - adfiltering
      - powerdns with filtering (lua-based) -> FIXME code commit
      - *pihole?*
      - *adguard home?*
  - **DNS (external service)**:
    - hetzner oder hosttech via https://github.com/ansible-collections/community.dns
    - inwx.de (because they offer official ansible-support, dnssec, anycast and API)
      - [inwx playbook examples](playbooks/dns/inwx)
      - zone-management on inwx (request creation of a API-account via support-ticket!)
    - netcup https://docs.ansible.com/ansible/latest/collections/community/general/netcup_dns_module.html
    - cloudflare https://docs.ansible.com/ansible/latest/collections/community/general/cloudflare_dns_module.html
    - AWS/Route53?
    - ...?

**Database**
  - mysql (limited distribution-support or use packages from oracle?; community.mysql )
  - mariadb
    - standalone
    - galera ( -> mrlesmithjr.mariadb_galera_cluster - tested, good, active maintenance )
  - PostgreSQL ( -> geerlingguy.postgresql )
  - management-tools:
    - phpmyadmin
    - phpPgAdmin

**Monitoring**
  - *icinga(2) (maintainer needed)*
  - zabbix ( community.zabbix https://github.com/ansible-collections/community.zabbix -> active development, good code)
    - checks/templates: [see our role with various zabbix checks](roles/zabbix_checks)
  - Uptime Kuma (for SoHo or extra monitoring - include simple statuspage) -> [roles/uptimekuma](roles/uptimekuma)
  - statuspages: Uptime Kuma, *[https://github.com/valeriansaliou/vigil](virgil), cachet, cstate, ... -> need maintainers*

**User directory**
  - keycloak
  - LDAP?
    - Samba
    - 389dir
    - UCS univention
    - SSSD integration on system
  - ...?

**Firewall**
  - opnsense
  - pfsense
  - hostfirewall
    - iptables/nftables -> geerlingguy.firewall (maybe iptables-persistent ?)
    - ufw

**Clustering**
  - keepalived -> evrardjp.keepalived
  - Filesync:
    - csync2
    - unison (?)

**Reverse-Proxy/Loadbalancer**:
  - self-hosted:
    - haproxy
    - nginx proxy manager GUI (needs docker)
    - nginx reverse proxy (vanilla)
    - apache mod_proxy (maintainer needed)
  - managed (via API):
    - hetzner LB
    - ...?

**package management**
  - build: fpm (effing package manager) -> Link playbook
  - host repository: 
    - deb: aptly? FIXME
    - rpm: FIXME

**Log-aggregation**
  - grafana loki (FIXME release code)
  - graylog

**Python**
  - PIP -> geerlingguy.pip

**Apps**
  - Videoconference
    - opentalk (still beta)
    - bbb ( https://github.com/juanluisbaptiste/ansible-bigbluebutton )
    - jitsi via docker (but usage discouraged due to limitations, over-complex architecture and bad documentation)
  - Wiki
    - [dokuwiki](roles/dokuwiki)
    - *wiki.js? (2Do: maintainer needed; -> https://github.com/supertarto/ansible-wikijs ?)*
    - *bookstack (2Do: maintainer needed)*
    - *mediawiki (2Do: maintainer needed)*
  - Netbox (IPAM/IT Asset Management)
  - Piwik (2DO)
  - passwordmanager
    - vaultwarden (FIXME code commit)
    - *hashicorp vault (2DO maintainer needed)?*
    - *privacyIDEA (2DO maintainer needed)*
  - roundcube webmail (2DO)
  - Ticketsystems
    - Zammad
  - kimai2 (timetracking)
  - *joplin (note taking application; 2DO maintainer needed)*

**candidates**
  - Guacamole (remote desktop gateway)
  - doodle-clones (dudle, framadate, ...)
  - etherpad
  - jellyfin / emby?
  - limesurvey
  - mastodon (twitter-alternative)
  - nodebb
  - peertube
  - teamspeak / mumble
  - kanban-boards (trello style): wekan? focalboard? planka?
  - whiteboard https://github.com/cracker0dks/whiteboard (could be replaced by videoconferencing-tool like bbb)
  - wordpress
  - distributed key/value stores
    - zookeeper
    - etcd
    - redis

**removed from list**
  - check_mk (freemium-model is ok in general, but currently no maintainer)
