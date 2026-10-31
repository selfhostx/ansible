mattermost
==========

design principles:
- mattermost has seperate data-directory to seperate code from data (symlinks are used)
  version upgrade possible (just increase the version-number, decrease might not work due db upgrades)
- nginx with custom mattermost config as reverse proxy in front of mattermost
- highly re-useable with template-override
- db creation is out-if-scope (see example playbook)


Requirements
------------

none


Role Variables
--------------

see [defaults/main.yml](defaults/main.yml)

| Variable | Default | Description |
|---|---|---|
| `mattermost_edition` | `enterprise` | `team` or `enterprise`, selects tarball and `mattermost_download_path` |
| `mattermost_download_checksum` | `.sha256` of the release | empty disables the check |
| `mattermost_allow_version_jump` | `false` | allow change of major.minor and downgrades |
| `mattermost_allow_edition_change` | `false` | allow change between team and enterprise |
| `mattermost_verify_after_start` | `true` | check version and edition after start |
| `mattermost_backup_before_update` | `false` | stop service and dump database before a version change |
| `mattermost_backup_dir` | `/opt/mattermost/backups` | dump target, dumps are not pruned |
| `mattermost_backup_command` | pg_dump with `mattermost_db_*` | stdout goes to the dump file, required for MySQL |

Edition
-------

Since v11 the enterprise binary without license runs as Entry and shows only the last 10000 messages.
Team Edition has no such limit. Set `mattermost_edition: team` for unlicensed installations.

Updates
-------

A version change runs: download, checksum, optional dump, link switch, restart, check of `Version` and
`BuildEnterpriseReady` at `/api/v4/config/client?format=old`. On failure the link goes back to the old
version. Old versions stay in `version-available`.

* Patch upgrades run without a switch. Other changes need `mattermost_allow_version_jump: true`.
* Migrations cannot be undone by the link. After a migration the dump is the way back, enable
  `mattermost_backup_before_update` for anything beyond a patch upgrade.
* Only the SHA-256 file from the release server is checked, not the GPG signature (`.sig`).
* MySQL is not supported since v11.

Config
------

The template is based on the `config.json` of 11.7. `mattermost_managed_config: true` overwrites it on
every run, changes made in the System Console are lost (a backup file is kept). Mattermost ignores unknown
keys and adds missing ones, on older or newer versions too.

Differences to the upstream defaults: `ListenAddress` is `mattermost_datalistenaddress` (loopback),
`TrustedProxyIPHeader` is set for nginx, `EnableOAuthServiceProvider` is off, passwords are stricter.

With `false` the role does not change `config.json`, except owner and mode by the recursive permission task
on the data directory. Use it when the configuration is maintained in the System Console.


Example Playbook
----------------

see [mattermost-example-playbook.yml](mattermost-example-playbook.yml).


License
-------

GPLv3



Author Information
------------------

Sven Holter
Stefan Schwarz
