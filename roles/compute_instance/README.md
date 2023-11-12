
Description
===========


This role create computer instances (VMs) on
- proxmox (no matter if on-premise or co-location, single-server or cluster
- VmWare (not done yet)
with cloud-init
- datasource: config-drive, other will follow, maybe nocloud https://cloudinit.readthedocs.io/en/latest/reference/datasources.html)
- support bootparameter, injecting pubkeys before network is even up and so on

networking (IPv4 AND/OR IPv6):
- next free from given prefix (via query of IPAM solution) netbox (or infoblox in the future)
- or manual values
- or disabled (when v4 or v6 is not needed)

creates DNS-entriesm, currently implemented:
- hetzner
- inwx


REQUIREMENTS
============

on controller:
# ansible-galaxy collection install community.general inwx.collection community.dns
#   https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_proxmox_module.html

on target:
# pip3 install netaddr proxmoxer pynetbox

# VM-template on proxmox with name of var "compute_instance_cloudinit_image".


State
=====

- Some vars will be renamed + breaking changes!
- Vars documentation improvement

License
=======

GPL-3.0-or-later


Author Information
==================

Stefan Schwarz <st@stefanux.de>
