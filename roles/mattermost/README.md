mattermost
==========

design principles:
- mattermost has seperate data-directory to seperate code from data (symlinks are used)
  version upgrade possible (just increase the version-number, decrease might not work due db upgrades)
- nginx with custom mattermost config as reverse proxy in front of mattermost
- highly re-useable with template-override
- db creation is out-if-scope (see example playbook)

TODO: 
- Backup before installing new version?


Requirements
------------

none


Role Variables
--------------

see [defaults/main.yml](defaults/main.yml)


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
