#!/usr/bin/env python
"""
Script to ingest existing NetBox data
"""
# (c) 2019, Larry Smith Jr. <mrlesmithjr@gmail.com>
#
# This file is a module for ingest existing NetBox data

# pylint: disable=line-too-long

#
# Module usage:
# python utils/ingest.py --token yourusersapitoken --url http(s)//:iporhostnameurl:port # noqa E501
# Example:
# python utils/ingest.py --token 4f552cc2e8c3b76d9613a591e3adb58984a19a6f --url http://127.0.0.1:8080 # noqa E501
#


import argparse
import json
import requests
import yaml


def get_args():
    """
    Get CLI command arguments
    """
    parser = argparse.ArgumentParser()
    parser.add_argument("-t", "--token", help="API token", required=True)
    parser.add_argument(
        "-u", "--url", help="API host url", default="http://127.0.0.1:8080"
    )
    parser.add_argument(
        "-f",
        "--format",
        help="Format to display",
        choices=["json", "yaml"],
        default="json",
    )
    args = parser.parse_args()

    return args


def main():
    """
    Main module execution
    """
    args = get_args()
    api_token = args.token
    url = args.url
    headers = {
        "Authorization": f"Token {api_token}",
        "Content-Type": "application/json",
    }

    data = dict()
    data["netbox_regions"] = get_regions(url, headers)
    data["netbox_tags"] = get_tags(url, headers)
    data["netbox_tenant_groups"] = get_tenant_groups(url, headers)
    data["netbox_tenants"] = get_tenants(url, headers)
    data["netbox_sites"] = get_sites(url, headers)
    data["netbox_vrfs"] = get_vrfs(url, headers)
    data["netbox_ipam_roles"] = get_ipam_roles(url, headers)
    data["netbox_vlan_groups"] = get_vlan_groups(url, headers)
    data["netbox_vlans"] = get_vlans(url, headers)
    data["netbox_rirs"] = get_rirs(url, headers)
    data["netbox_aggregates"] = get_aggregates(url, headers)
    data["netbox_prefixes"] = get_prefixes(url, headers)
    data["netbox_devices"] = get_devices(url, headers)

    if args.format == "json":
        print(json.dumps(data))
    else:
        print(yaml.dump(data))


def get_regions(url, headers):
    """
    Get dictionary existing regions
    """
    api_url = f"{url}/api/dcim/regions/"
    response = requests.request("GET", api_url, headers=headers)
    all_regions = response.json()["results"]

    regions = []
    for region in all_regions:
        region_info = dict()
        region_info["name"] = region["name"]
        region_info["state"] = "present"
        if region["parent"] is not None:
            region_info["parent"] = region["parent"]["name"]
        else:
            region_info["parent"] = None
        regions.append(region_info)

    return regions


def get_tags(url, headers):
    """
    Get dictionary existing tags
    """
    api_url = f"{url}/api/extras/tags/"
    response = requests.request("GET", api_url, headers=headers)
    all_tags = response.json()["results"]

    tags = []
    for tag in all_tags:
        tag_info = dict()
        tag_info["color"] = tag["color"]
        tag_info["comments"] = tag["comments"]
        tag_info["name"] = tag["name"]
        tag_info["state"] = "present"
        tags.append(tag_info)

    return tags


def get_tenant_groups(url, headers):
    """
    Get dictionary of existing tenant groups
    """
    api_url = f"{url}/api/tenancy/tenant-groups/"
    response = requests.request("GET", api_url, headers=headers)
    all_tenant_groups = response.json()["results"]
    tenant_groups = []
    for tenant_group in all_tenant_groups:
        tenant_group_info = dict()
        tenant_group_info["name"] = tenant_group["name"]
        tenant_group_info["state"] = "present"
        tenant_groups.append(tenant_group_info)

    return tenant_groups


def get_tenants(url, headers):
    """
    Get dictionary of existing tenants
    """
    api_url = f"{url}/api/tenancy/tenants/"
    response = requests.request("GET", api_url, headers=headers)
    all_tenants = response.json()["results"]
    tenants = []
    for tenant in all_tenants:
        tenant_info = dict()
        tenant_info["comments"] = tenant["comments"]
        tenant_info["custom_fields"] = tenant["custom_fields"]
        tenant_info["description"] = tenant["description"]
        if tenant["group"] is not None:
            tenant_info["group"] = tenant["group"]["name"]
        tenant_info["name"] = tenant["name"]
        tenant_info["state"] = "present"
        tenant_info["tags"] = tenant["tags"]
        tenants.append(tenant_info)

    return tenants


def get_sites(url, headers):
    """
    Get dictionary of existing sites
    """
    api_url = f"{url}/api/dcim/sites/"
    response = requests.request("GET", api_url, headers=headers)
    all_sites = response.json()["results"]
    sites = []
    for site in all_sites:
        site_info = dict()
        site_info["asn"] = site["asn"]
        site_info["comments"] = site["comments"]
        site_info["contact_email"] = site["contact_email"]
        site_info["contact_name"] = site["contact_name"]
        site_info["contact_phone"] = site["contact_phone"]
        site_info["custom_fields"] = site["custom_fields"]
        site_info["description"] = site["description"]
        site_info["facility"] = site["facility"]
        site_info["latitude"] = site["latitude"]
        site_info["longitude"] = site["longitude"]
        site_info["name"] = site["name"]
        site_info["physical_address"] = site["physical_address"]
        if site["region"] is not None:
            site_info["region"] = site["region"]["name"]
        else:
            site_info["region"] = None
        site_info["shipping_address"] = site["shipping_address"]
        site_info["state"] = "present"
        site_info["status"] = site["status"]["label"]
        site_info["tags"] = site["tags"]
        if site["tenant"] is not None:
            site_info["tenant"] = site["tenant"]["name"]
        else:
            site_info["tenant"] = None
        site_info["time_zone"] = site["time_zone"]

        sites.append(site_info)

    return sites


def get_vrfs(url, headers):
    """
    Get dictionary of existing VRFs
    """
    vrfs = []
    api_url = f"{url}/api/ipam/vrfs/"
    response = requests.request("GET", api_url, headers=headers)
    all_vrfs = response.json()["results"]
    for vrf in all_vrfs:
        vrf_info = dict()
        vrf_info["custom_fields"] = vrf["custom_fields"]
        vrf_info["description"] = vrf["description"]
        vrf_info["enforce_unique"] = bool(vrf["enforce_unique"])
        vrf_info["name"] = vrf["name"]
        vrf_info["rd"] = vrf["rd"]
        vrf_info["state"] = "present"
        vrf_info["tags"] = vrf["tags"]
        if vrf["tenant"] is not None:
            vrf_info["tenant"] = vrf["tenant"]["name"]
        else:
            vrf_info["tenant"] = None
        vrfs.append(vrf_info)

    return vrfs


def get_vlan_groups(url, headers):
    """
    Get dictionary of existing vlan groups
    """
    vlan_groups = []
    api_url = f"{url}/api/ipam/vlan-groups/"
    response = requests.request("GET", api_url, headers=headers)
    all_vlan_groups = response.json()["results"]
    for vlan_group in all_vlan_groups:
        vlan_group_info = dict()
        vlan_group_info["name"] = vlan_group["name"]
        vlan_group_info["state"] = "present"
        if vlan_group["site"] is not None:
            vlan_group_info["site"] = vlan_group["site"]["name"]
        else:
            vlan_group_info["site"] = None
        vlan_groups.append(vlan_group_info)

    return vlan_groups


def get_vlans(url, headers):
    """
    Get dictionary of existing VRFs
    """
    vlans = []
    api_url = f"{url}/api/ipam/vlans/"
    response = requests.request("GET", api_url, headers=headers)
    all_vlans = response.json()["results"]
    for vlan in all_vlans:
        vlan_info = dict()
        vlan_info["custom_fields"] = vlan["custom_fields"]
        vlan_info["description"] = vlan["description"]
        vlan_info["group"] = vlan["group"]
        vlan_info["name"] = vlan["name"]
        vlan_info["role"] = vlan["role"]
        if vlan["site"] is not None:
            vlan_info["site"] = vlan["site"]["name"]
        else:
            vlan_info["site"] = None
        vlan_info["state"] = "present"
        vlan_info["status"] = vlan["status"]["label"]
        vlan_info["tags"] = vlan["tags"]
        if vlan["tenant"] is not None:
            vlan_info["tenant"] = vlan["tenant"]["name"]
        else:
            vlan_info["tenant"] = None
        vlan_info["vid"] = vlan["vid"]
        vlans.append(vlan_info)

    return vlans


def get_rirs(url, headers):
    """
    Get dictionary of existing rirs
    """
    api_url = f"{url}/api/ipam/rirs/"
    response = requests.request("GET", api_url, headers=headers)
    all_rirs = response.json()["results"]
    rirs = []
    for rir in all_rirs:
        rir_info = dict()
        rir_info["is_private"] = bool(rir["is_private"])
        rir_info["name"] = rir["name"]
        rir_info["state"] = "present"
        rirs.append(rir_info)

    return rirs


def get_aggregates(url, headers):
    """
    Get dictionary of existing aggregates
    """
    api_url = f"{url}/api/ipam/aggregates/"
    response = requests.request("GET", api_url, headers=headers)
    all_aggs = response.json()["results"]
    aggs = []
    for agg in all_aggs:
        agg_info = dict()
        agg_info["custom_fields"] = agg["custom_fields"]
        agg_info["description"] = agg["description"]
        agg_info["prefix"] = agg["prefix"]
        if agg["rir"] is not None:
            agg_info["rir"] = agg["rir"]["name"]
        else:
            agg_info["rir"] = None
        agg_info["state"] = "present"
        agg_info["tags"] = agg["tags"]
        aggs.append(agg_info)

    return aggs


def get_ipam_roles(url, headers):
    """
    Get dictionary of existing IPAM roles
    """
    api_url = f"{url}/api/ipam/roles/"
    response = requests.request("GET", api_url, headers=headers)
    all_roles = response.json()["results"]
    roles = []
    for role in all_roles:
        role_info = dict()
        role_info["name"] = role["name"]
        role_info["state"] = "present"
        role_info["weight"] = role["weight"]
        roles.append(role_info)

    return roles


def get_prefixes(url, headers):
    """
    Get dictionary of existing prefixes
    """
    api_url = f"{url}/api/ipam/prefixes/"
    response = requests.request("GET", api_url, headers=headers)
    all_prefixes = response.json()["results"]
    prefixes = []
    for prefix in all_prefixes:
        prefix_info = dict()
        prefix_info["custom_fields"] = prefix["custom_fields"]
        prefix_info["description"] = prefix["description"]
        prefix_info["is_pool"] = bool(prefix["is_pool"])
        prefix_info["prefix"] = prefix["prefix"]
        prefix_info["role"] = prefix["role"]
        if prefix["site"] is not None:
            prefix_info["site"] = prefix["site"]["name"]
        else:
            prefix_info["site"] = None
        prefix_info["state"] = "present"
        prefix_info["status"] = prefix["status"]["label"]
        prefix_info["tags"] = prefix["tags"]
        if prefix["tenant"] is not None:
            prefix_info["tenant"] = prefix["tenant"]["name"]
        else:
            prefix_info["tenant"] = None
        prefix_info["vlan"] = prefix["vlan"]
        if prefix["vrf"] is not None:
            prefix_info["vrf"] = prefix["vrf"]["name"]
        else:
            prefix["vrf"] = None
        prefixes.append(prefix_info)

    return prefixes


def get_devices(url, headers):
    """
    Get dictionary of existing devices
    """
    devices = []
    api_url = f"{url}/api/dcim/devices/"
    response = requests.request("GET", api_url, headers=headers)
    all_devices = response.json()["results"]
    for device in all_devices:
        device_info = dict()
        device_info["asset_tag"] = device["asset_tag"]
        device_info["cluster"] = device["cluster"]
        device_info["comments"] = device["comments"]
        device_info["custom_fields"] = device["custom_fields"]
        device_info["device_role"] = device["device_role"]
        device_info["device_type"] = device["device_type"]
        device_info["local_context_data"] = device["local_context_data"]
        device_info["name"] = device["name"]
        device_info["primary_ip4"] = device["primary_ip4"]
        device_info["primary_ip6"] = device["primary_ip6"]
        device_info["serial"] = device["serial"]
        if device["site"] is not None:
            device_info["site"] = device["site"]["name"]
        else:
            device_info["site"] = None
        device_info["state"] = "present"
        device_info["status"] = device["status"]["label"]
        device_info["tags"] = device["tags"]
        if device["tenant"] is not None:
            device_info["tenant"] = device["tenant"]["name"]
        else:
            device_info["tenant"] = None
        devices.append(device_info)

    return devices


if __name__ == "__main__":
    main()
