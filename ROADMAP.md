Roadmap
=======

**Backup**
  - bacula https://github.com/stefanux/ansible-role-bacula
  - bareos (veselahouba.bareos)
  - Borg+Borgmatic (if maintainer is found)
  - restic (if maintainer is found)
  - mysql/mariadb (-> geerlingguy.mysql )
    - fulldump (SQL commands):
      - mysqlbackup https://github.com/stefanux/ansible-mysqlbackup
    - other methods:
      - FIXME
  - proxmox backup server (2DO ?)
  - pfsense config (2DO https://github.com/pfsensible/core ?)
  - opensense config (2DO https://github.com/naturalis/ansible-opnsense ?)
  - etckeeper (2DO)

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
  - proxmox (including cloud-init) -> Code committen
    - VM management: https://github.com/mikaelflora/ansible-role-proxmox-vm
    - lxc?
  - libvirt/KVM (including cloud-init) -> Code committen
  - ovirt?
  - Container
    - k38
    - k8s
    - docker (swarm)
      - installation https://github.com/stefanux/ansible-role-docker -> substitute with upstream: https://github.com/geerlingguy/ansible-role-docker Vergleich: https://github.com/stefanux/ansible-role-docker/compare/master...geerlingguy:master
      - registry
        - ...?
      - optional management tools:
        - portainer
        - traefik

**Instant messenger**
  - mattermost (Code working, see sample playbook)
  - matrix-synapse / element-web (2DO)
  - rocket.chat (2DO?)

**Filesharing**
  - samba
    - standalone (2DO: shadowcopy + fruit von bashclub ergänzen + ZFS) geerlingguy.samba / https://github.com/stefanux/ansible-role-samba.git
    - AD-member "zmb-member" https://github.com/bashclub/zamba-lxc-toolbox
  - nextcloud (-> https://github.com/JGoutin/ansible_home/tree/master/roles/nextcloud ?)
  - S3
    - minio
    - ceph RGW
  - SSH sftpgo
  - SeaweedFS (?)
  - OpenMediaVault / TrueNAS Core?

**Webserver**
  - nginx (nginx_common)
    - reverse-proxy (2DO?)
  - caddy (2DO)
  - apache ( -> geerlingguy.apache )
    - apache only (simple static sites)
    - redirector
    - LAMP  (-> geerlingguy.php geerlingguy.php-versions )
      - mod_php
      - php-fpm (2DO)
  - All-in-one-packages
    - froxlor  (Code ready)
    - ispconfig (maintainer needed)

**TLS-cert + CA-management**
  - letsencrypt
    - certbot -> https://github.com/selfhostx/ansible-role-certbot
    - helper-scripte -> deploy_hook
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
    - mailcow (Code ready, publish)
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
  - (stunnel -> needed?)

**DNS**
  - **self-hosted:**
    - recursive
      - dnsdist (-> powerdns.dnsdist ) + powerDNS-recursor (-> powerdns.pdns_recursor) (clustering: keepalived, csync2-sync von Zertifikaten wenn letsencrypt, nginx-reverse-proxy für Statusseite)
      - bind (2DO -> maintainer needed)
      - unbound (2DO -> maintainer needed)
    - autoritative
      - PowerDNS Authoritative (-> in progress)
      - bind -> 2DO: maintainer needed
    - DoT (DNS over TLS)
      - powerdns
      - bind? -> 2DO: maintainer needed
    - DoH / dnscrypt (maintainer needed)
    - adfiltering
      - powerdns with filtering (lua-based) -> release Code
      - pihole ?
      - adguard home?
  - **DNS (external service)**:
    - hetzner oder hosttech via https://github.com/ansible-collections/community.dns
    - inwx.de (because they offer official ansible-support, dnssec, anycast and API)
      - example
      - zone-management on inwx (request creation of a API-account via support-ticket)
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
  - icinga(2) (maintainer needed)
  - zabbix ( community.zabbix )
    - including checks/templates:
      - bacula
      - bareos (2DO)
      - iostat
      - glusterfs
      - mysql
      - postfix
      - pfsense (2DO)
        - wireguard/openvpn/ipsec
      - tcpstats
      - opnsense (2DO)
        - wireguard/openvpn/ipsec
      - strongswan (ipsec)
      - wireguard ( githubixx.ansible_role_wireguard )
      - ZFS https://github.com/stefanux/zabbix_zfs-on-linux
      - ... (2DO extend List)
  - Uptime Kuma (for SoHo or extra monitoring - include simple statuspage)
  - statuspages: cachet, cstate, ... -> need maintainers

**User directory**
  - LDAP?
    - Samba
    - 389dir
    - UCS univention
    - SSSD integration on system
  - keycloak?
  - ...?

**Firewall**
  - opnsense
  - pfsense
  - hostfirewall
    - iptables/nftables geerlingguy.firewall (maybe iptables-persistent ?)
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
  - grafana loki
  - graylog

**Python**
  - PIP -> geerlingguy.pip

**Apps**
  - Videoconference
    - opentalk (still beta)
    - bbb ( https://github.com/juanluisbaptiste/ansible-bigbluebutton )
    - jitsi via docker (but usage discouraged due to limitations, over-complex architecture and bad documentation)
  - Wiki
    - dokuwiki https://github.com/stefanux/ansible-role-dokuwiki
    - wiki.js? (2Do: maintainer needed; -> https://github.com/supertarto/ansible-wikijs ?)
    - bookstack (2Do: maintainer needed)
    - mediawiki (2Do: maintainer needed)
  - Netbox (IPAM/IT Asset Management)
  - Piwik (2DO)
  - passwordmanager
    - vaultwarden (done)
    - hashicorp vault (2DO maintainer needed)?
    - privacyIDEA (2DO maintainer needed)
  - roundcube webmail
  - Ticketsystems
    - Zammad
  - kimai2 (timetracking)
  - joplin (note taking application; 2DO maintainer needed)

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
