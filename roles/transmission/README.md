transmission
============

Installs and configures `transmission-daemon` (bittorrent client with web interface / RPC) from the distribution packages on the Debian family.

Supported: Debian 12 (bookworm), Debian 13 (trixie), Ubuntu 22.04, Ubuntu 24.04.

design principles:
- distro package, the systemd unit of the package and its user `debian-transmission` are used
- transmission overwrites `settings.json` on shutdown (and hashes the RPC password), therefore the role renders the desired state to `/etc/transmission-daemon/settings.ansible.json` and only when this file changes: stops the daemon, copies it to `settings.json`, starts the daemon. This keeps the role idempotent.
- consequence: settings changed in the web interface (e.g. speed limits) survive until the ansible-managed settings change, then the ansible values win


Commands
--------

```
ansible-playbook transmission-example.yml
```

tags: `transmission_install`, `transmission_config`, `transmission_service`


Requirements
------------

collection `ansible.posix` (sysctl), already listed as dependency of this collection


Role Variables
--------------

required (when the RPC authentication is enabled, which is the default):
```
transmission_rpc_password: "{{ vault_transmission_rpc_password }}"
```

often used:
```
transmission_download_dir: /srv/torrents/complete
transmission_incomplete_dir_enabled: true
transmission_incomplete_dir: /srv/torrents/incomplete
transmission_rpc_whitelist:          # IPs allowed to reach the web interface
  - "127.0.0.1"
  - "192.168.*.*"
transmission_rpc_host_whitelist:     # hostnames when accessing via FQDN/reverse proxy
  - "torrent.example.com"
transmission_settings_extra:         # any other key of settings.json, overrides everything
  cache-size-mb: 16
```

see defaults/main.yml for more variables.

Notes:
- `transmission_umask` is a decimal number (2 = 002, 18 = 022)
- the peer port (default 51413 TCP+UDP) must be opened/forwarded in your firewall yourself
- to put the web interface behind nginx, proxy `http://127.0.0.1:9091/transmission/` and add the FQDN to `transmission_rpc_host_whitelist`


Example Playbook
----------------

see [transmission-example.yml](transmission-example.yml)


License
-------

BSD-3-Clause
