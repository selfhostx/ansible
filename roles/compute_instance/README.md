
Description
===========


This role creates fully automated computer instances (VMs) 

supported virtualization plattforms:
- proxmox (no matter if on-premise or co-location, single-server or cluster)
- VmWare (planned)
- hetzner (planned)
using cloud-init (datasource: config-drive, other will follow, maybe nocloud https://cloudinit.readthedocs.io/en/latest/reference/datasources.html)
- support bootparameters for grub
- network config depending on choice of the distribution cloud-image (ifupdown/netplan/networkmanager)
- injecting pubkeys before network is even up
- executing commands
- update packages, reboot ... and so on

networking (IPv4 AND/OR IPv6)
- next free from given prefix (via query of IPAM solution) netbox (or infoblox in the future)
- or manual values (no IPAM)
- or disabled (when v4 or v6 is not needed)

creates DNS-entries, currently implemented:
- hetzner
- inwx


REQUIREMENTS
============

on controller:
- ansible-galaxy collection install community.general inwx.collection community.dns
- https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_proxmox_module.html

on target:
- pip3 install netaddr proxmoxer pynetbox

on virtualization host:
- VM-template on proxmox with name of var "compute_instance_cloudinit_image".

role is able to install requirements on target.


License
=======

GPL-3.0-or-later


Author Information
==================

Stefan Schwarz <st@stefanux.de>
