# MD Soft RAID monitoring template for Zabbix

Using _sysfs_ for monitoring of Linux Soft RAID aka MD

>Tested on Zabbix Version 3.0

>Automatically converted for Zabbix v2.0 and v2.4

See at [share.zabbix.com](https://share.zabbix.com/operating-systems/linux/template-md-raid)

## FEATURES

* LLD for auto detecting RAID
* Monitoring of total number of disks, number of degraded disks, sync_status
* Graph for degraded disks
* Triggers for degrading and raid recovering


## REQUIREMENTS

* SYSFS at agents's server, __/sys/block/md*__ available

## INSTALLATION

* Agent (host with RAID)
  * Copy __userparameter_md.conf__ to __/etc/zabbix/zabbix_agentd.d/userparameter_md.conf__
    * `curl -Ls https://git.io/fN9H5 | sudo tee /etc/zabbix/zabbix_agentd.d/userparameter_md.conf`
  * Restart zabbix_agent
    * UBUNTU/DEBIAN: `sudo service zabbix-agent restart`
* Server
  * Import template __template_md_x.x.xml__ file via web admin (**x.x** this is your version of Zabbix)
    * Save the XML template file to a convenient location (or [this](https://github.com/krom/zabbix_template_md/archive/master.zip) archive)
    * Open the Zabbix console
    * Navigate to __Configuration__ > __Templates__
    * Click the __Import__ button
    * Select the downloaded __template_md_x.x.xml__ file
    * Click __Import__

## ITEMS

* **md.discover** - LLD data (MD RAIDs and disks)
* **md.degraded[*]** - number of degraded disks for specific RAID
* **md.sync_action[*]** - current sync status for specific RAID
* **md.raid_disks[*]** - number of all disks for specific RAID

### How to add new Item

1. Add new **UserParameter** to **/etc/zabbix/zabbix_agentd.d/userparameter_md.conf**
  * For example `UserParameter=md.sync_speed[*],cat /sys/block/$1/md/sync_speed`
2. Create new Item by [instruction](https://www.zabbix.com/documentation/3.4/manual/config/items/item)

## AUTHOR

Roman Kudlay roman@kudlay.pro

## LICENSE

GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007

See [LICENSE](LICENSE)
