# ansible-role-bacula

This Role installs any component of the backup system "bacula" AND configures everything (including agent configs like filesets for all systems) so you can use bacula gitops-style (aka do everything from ansible).


## quick bacula introduction

| Component | function | variable (ansible-tag) |
| ------------- |:-------------:| -----:|
| bacula-director (dir) | central management, coordination on other components | bacula_dir_role (bacula-dir) |
| bacula-storage daemon (sd) | controls the writing device(s) | bacula_sd_role (bacula-sd) |
| bacula-console | management console, connects to bacula-dir | bacula_console_role (bacula-console) |
| bacula-file daemon (fd) | agent on target system | bacula_fd_role (bacula-fd) |

see the notes on firewalling: https://www.bacula.org/9.6.x-manuals/en/problems/Dealing_with_Firewalls.html

## Requirements
- installed database-server (mysql or pgsql) on director

## Limitations

Currently only tested on mysql / mariadb and Ubuntu/Debian in LTS-Versions.

## Using Official Bacula Repository (Bacula 10+)

### Overview

**Access Key Requirement:** Starting with **Bacula 10** (released 2018), the official Bacula repository requires a free registration access key for downloading packages. This applies to all Bacula versions 10.0.0 and newer.

This role supports both:
- **Distribution packages** (default) - Older Bacula versions (typically 5.x - 9.x) from distro repos, no access key needed
- **Official Bacula repository** (Bacula 10+) - Newer versions requiring free registration access key

### When to Use Official Repository

Use `bacula_use_official_repo: true` when you need:
- Bacula version 10 or newer (13.0.4 is current as of 2024)
- Latest features, bug fixes, and security updates
- Versions newer than your distribution provides (Ubuntu/Debian typically lag behind)
- Consistent Bacula version across different OS distributions

**Supported Distributions:**

The official Bacula repository provides packages for recent distributions only. For distributions without native packages, this role automatically uses compatible packages from older releases:

| Distribution | Native Packages Available | Fallback Mapping |
|--------------|--------------------------|------------------|
| Debian bookworm (12) | ✅ Yes | - |
| Debian trixie (13) | ❌ No | Uses bookworm packages |
| Ubuntu jammy (22.04) | ✅ Yes | - |
| Ubuntu noble (24.04) | ❌ No | Uses jammy packages |

> **Note:** Fallback mappings use LTS-to-LTS compatibility (e.g., jammy packages work on noble). The role handles this automatically.

### Getting Started with Official Repository

**Step 1: Register for access key**
1. Visit https://www.bacula.org/bacula-binary-package-download/
2. Register for free (name + email)
3. Receive alphanumeric access key

**Step 2: Configure variables**

```yaml
# Enable official repository
bacula_use_official_repo: true

# REQUIRED: Your access key from bacula.org
bacula_repo_access_key: "your-access-key-here"

# REQUIRED: Bacula version to install
bacula_version: "13.0.4"
```

**Step 3: Run the role**

The role will automatically:
1. Validate required variables (fails if missing)
2. Check distribution compatibility
3. Download and install Bacula GPG signing key
4. Configure official repository
5. Install/upgrade Bacula packages

### Upgrading Existing Installations

**Yes, this works for upgrades!** The role handles:
- New installations (fresh Bacula setup)
- Upgrades from distribution packages to official repo
- Upgrades between official repo versions

When upgrading:
```yaml
# In your inventory or playbook
bacula_use_official_repo: true
bacula_repo_access_key: "your-key"
bacula_version: "13.0.4"  # Set desired version
```

The role will automatically:
1. **Unhold any pinned packages** - Removes apt/dpkg holds that prevent updates
2. **Remove old distribution packages** - Purges old Debian/Ubuntu bacula packages completely
3. **Configure repository priority** - Sets apt preferences to prefer Bacula repo over distro repos (priority 1100 vs 100)
4. **Add official repository** - Configures bacula.org repository with your access key
5. **Install correct packages** - Uses official package names (bacula-client, bacula-postgresql, etc.)
6. **Preserve configuration** - Keeps your existing configs during migration
7. **Restart services** - Only restarts when configuration changes

**Migration is idempotent** - A marker file (`/etc/bacula/.migrated_to_official_repo`) prevents cleanup from running multiple times.

**Important Notes:**
- **Repository Priority:** The role creates `/etc/apt/preferences.d/bacula-official` to ensure Bacula packages always come from the official repo, even if your system has mixed Debian/Ubuntu repositories
- **Held Packages:** If packages are held/pinned, the role automatically unholds them before migration
- **Downgrades:** Not supported by Bacula
- **Database Migrations:** Schema migrations happen automatically (make backups!)
- **Configuration:** Maintained by Bacula across versions

### Validation and Safety

The role includes built-in safety checks:

**Required variable validation:**
```
ERROR: Official Bacula repository requires:
- bacula_repo_access_key: Get your free access key from https://www.bacula.org/...
- bacula_version: Specify Bacula version (e.g., "13.0.4")
```

**Distribution compatibility check:**
```
ERROR: Distribution 'stretch' is not supported for official Bacula repository.
Supported distributions: bookworm, trixie, jammy, noble
```

If validation fails, the role **stops immediately** before making any changes.

### Example Configurations

**New installation with official repo:**
```yaml
---
- hosts: backup_servers
  become: true
  vars:
    bacula_use_official_repo: true
    bacula_repo_access_key: "abc123xyz789"
    bacula_version: "13.0.4"
    bacula_dir_role: true
    bacula_sd_role: true
    bacula_fd_role: true
  roles:
    - selfhostx.ansible.bacula
```

**Upgrade existing installation:**
```yaml
---
- hosts: bacula_director
  become: true
  vars:
    # Switch from distro packages to official repo
    bacula_use_official_repo: true
    bacula_repo_access_key: "{{ vault_bacula_repo_key }}"
    bacula_version: "13.0.4"
  roles:
    - selfhostx.ansible.bacula
```

**Continue using distribution packages:**
```yaml
---
- hosts: backup_servers
  become: true
  vars:
    # Default: use distribution packages
    bacula_use_official_repo: false
  roles:
    - selfhostx.ansible.bacula
```

### Technical Details

**GPG Key Management:**
- Debian/Ubuntu: Modern keyring method (`/usr/share/keyrings/`)
- RHEL/CentOS: `rpm --import` method
- Key URL: https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc
- Fingerprint: `5235 F5B6 68D8 1DB6 1704 A82D C0BE 2A5F E9DF 3643`

**Repository Configuration:**
- Debian/Ubuntu: `/etc/apt/sources.list.d/bacula-community.list`
- RHEL/CentOS: `/etc/yum.repos.d/bacula-community.repo`
- Old repository files are automatically removed

**Ansible Tags:**
```bash
# Setup repository only
ansible-playbook playbook.yml --tags bacula-repository

# Skip repository setup
ansible-playbook playbook.yml --skip-tags bacula-repository

# Setup specific components
ansible-playbook playbook.yml --tags bacula-dir   # Director only
ansible-playbook playbook.yml --tags bacula-sd    # Storage Daemon only
ansible-playbook playbook.yml --tags bacula-fd    # File Daemon only
ansible-playbook playbook.yml --tags bacula-console  # Console only
```

### Client Management

The role supports disabling or removing File Daemon clients from the Bacula Director without uninstalling the FD itself:

**Disable a client (temporary):**
```bash
# Marks client as disabled (Enabled = no) in Director config
# Keeps all configuration files - client can be re-enabled easily
ansible-playbook playbook.yml --limit client-host --tags disable-client \
  -e bacula_dir_fqdn=your-director.example.com
```

**Remove a client (permanent):**
```bash
# Completely removes client configuration from Director
# Optionally removes fileset if bacula_fd_remove_fileset=true
ansible-playbook playbook.yml --limit client-host --tags remove-client \
  -e bacula_dir_fqdn=your-director.example.com
```

**Options:**
- `bacula_fd_remove_fileset: false` (default) - Keep fileset config when removing client
- `bacula_fd_remove_fileset: true` - Also remove fileset (only if not shared with other clients)

> **Note:** Both tags use `never` internally, so they only run when explicitly invoked. They won't execute during normal playbook runs.

**Migration workflow example:**
```bash
# 1. Disable client on old Bacula Director
ansible-playbook playbook.yml --limit client.example.com \
  --tags disable-client \
  -e bacula_dir_fqdn=old-bacula.example.com

# 2. Configure client for new Bacula Director
# (update group_vars to point to new director first)
ansible-playbook playbook.yml --limit client.example.com --tags bacula-fd

# 3. After verifying new setup works, remove from old director
ansible-playbook playbook.yml --limit client.example.com \
  --tags remove-client \
  -e bacula_dir_fqdn=old-bacula.example.com
```

**Package Naming Differences:**

Official Bacula repository uses different package names than Debian/Ubuntu:

| Component | Debian Package | Official Bacula Package | Notes |
|-----------|---------------|------------------------|-------|
| Director (PostgreSQL) | bacula-director<br>bacula-director-pgsql<br>bacula-bscan | bacula-postgresql | Includes director + SD |
| Director (MySQL) | bacula-director<br>bacula-director-mysql<br>bacula-bscan | bacula-mysql | Includes director + SD |
| Storage Daemon | bacula-sd | Included in director package | - |
| File Daemon (Client) | bacula-fd | bacula-client | - |
| Console | bacula-console | bacula-console | - |
| Common Files | bacula-common | *(auto-installed)* | Dependency, not explicitly listed |

> **Important:** `bacula-common` is **not** explicitly installed by the role. It's automatically pulled in as a dependency by other packages. This ensures apt correctly resolves dependencies from the same repository.

The role automatically selects the correct package names based on `bacula_use_official_repo`.

When upgrading from distribution packages to official repository:
- Old Debian packages are automatically purged (including config remnants)
- Official Bacula packages are installed with correct names
- Configuration files are preserved during the transition
- Apt preferences ensure all packages come from bacula.org (not mixed sources)

## Quick start

### customize (at least) this vars:
(see example playbooks).

bacula_dir_fqdn: "bacula-dir.DOMAIN.TLD"
bacula_sd_fqdn: "bacula-sd.DOMAIN.TLD"

bacula_dir_restore_path: "/var/bacula-restores" (Default restore path)
bacula_sd_archive_device: "/var/bacula-volumes" (Default volume path)

-> DB engine (can be 'pgsql' or 'mysql')
bacula_dir_db_engine: mysql

### Define the director/SD via (host_vars / group_vars):

host_vars/bacula-dir.DOMAIN.TLD.yml

```yaml
---
bacula_console_role: True
bacula_dir_role: True
bacula_sd_role: True
bacula_fd_role: True
```

## Variables

### defaults

defaults are set here:
- defaults/main.yml
- vars/{{ ansible_os_family }}.yml

### vaulted passwords
my recommendation: set the following variables in your vault:

```yaml
bacula_console_password: ""
bacula_dir_dbpassword: ""
bacula_mon_password: ""
bacula_sd_password: ""
```

Attention: empty passwords are substituted with random values - on very run. Useful for testing - but not in production.
Exception are the FD-passwords, they will be preserved when bacula_fd_auto_psk is True (default).

### Email Notifications

Configure how the Director sends email notifications:

```yaml
# Email addresses for notifications
bacula_dir_email_admin: "root"
bacula_dir_email_operator: "root"

# Mail command type: "mail" (system mail) or "bsmtp" (Bacula's built-in SMTP)
bacula_mail_command_type: "mail"

# Sender address (only used with system mail command)
bacula_mail_from: "root"
```

**Options:**

- **`bacula_mail_command_type: "mail"`** (default) - Use system mail command
  - Uses `/usr/bin/mail` with configurable sender address
  - Best when using existing mail infrastructure (Postfix, etc.)
  - Sender set via `bacula_mail_from` (defaults to "root")

- **`bacula_mail_command_type: "bsmtp"`** - Use Bacula's built-in SMTP
  - Sends directly via SMTP
  - Path automatically adjusted for official repo vs distribution packages
  - `/usr/sbin/bsmtp` (Debian packages) or `/opt/bacula/bin/bsmtp` (official repo)

**Example with Postfix relay:**
```yaml
bacula_mail_command_type: "mail"
bacula_mail_from: "bacula@example.com"
bacula_dir_email_admin: "admin@example.com"
```

### customize storage device (tape, Filestorage etc.)
Example: Ringbuffer 
- oldest data is recycled/overwritten when the storage is full
- size is bacula_sd_pool_max_volumes x bacula_sd_pool_max_volume_byte
Example: 10G x 100 Volumes means maximum capacity is ~1TB backupspace, depending on the amount

see template from var "bacula_sd_device_template" (default is [storage_device_include_ringbuffer.j2](templates/storage_device_include_ringbuffer.j2)) and optional more options from var "bacula_sd_device_extra_options".

### Storage Definitions
bacula_sd_device_name: "RingBuffer"
bacula_sd_media_type: "File"

**where to store the volumes**:

bacula_sd_archive_device: "/srv/bacula"
bacula_dir_pool_name: "Files"
bacula_dir_pool_label_format: "Bacula-Vol-"
bacula_dir_pool_recycle: "yes"

bacula_dir_pool_file_retention: "60 days" # Default: 60 days

bacula_dir_pool_job_retention: "24 months" # Default: 6 months

**Prune expired Jobs/Files**:

bacula_dir_pool_autoprune: "yes"
bacula_dir_pool_volume_rention: "3650 days"
bacula_dir_pool_max_volume_bytes: "10G"
bacula_dir_pool_max_volumes: 100

### Host overrides

Example: host_vars/host1.DOMAIN.TLD.yml

**own fileset**:
```yaml
bacula_fd_fileset_name: "fileset-of-host1"
bacula_fd_fileset_includes: |+
File = "/files/only/on/host1"
File = "/etc"
File = "/root"
bacula_fd_fileset_excludes: |+
File = "/files/EXCLUDED/on/host1"
File = "/proc"
```

**define jobs that the client should run before** (recommended to put this into group_vars or hosts_vars !):

```yaml
bacula_fd_client_run_before_job: command
bacula_fd_client_run_after_job: command
```

Example:
```yaml
bacula_fd_client_run_before_job: "/path/to/my/backupskript create"
bacula_fd_client_run_after_job: "/path/to/my/backupskript cleanup"
```

additonal note: for jobs running on director/server-side the vars "bacula_fd_run_before_job", "bacula_fd_run_after_job" or "bacula_fd_run_after_failed_job" are existing.

**additional options in job-ressource**:
```yaml
bacula_fd_extra_job_options: |+
Option1 = Example1
Option2 = Example2
```

Example: add more (than the predefined "bacula_fd_client_run_before_job") "Client Run Before Job" via bacula_fd_extra_job_options:
```yaml
bacula_fd_extra_job_options: |+
    Client Run Before Job = "additional before job" 
    Client Run After Job = "additional after job"
```

same goes **for client and jobdef**-ressources:

bacula_fd_extra_client_options
bacula_fd_extra_jobdefs_options

**different FQDN for connection to fd**:
```yaml
bacula_fd_connect_address: "different.fqdn.to.connect.to"
```
set source IP (default: the kernel will choose the best address according to the routing table):
```
bacula_fd_source_address: "IP_or_FQDN"
```

specific schedule for a host:
- set a (valid!) name for var bacula_fd_schedule (i.e. in host_vars/$hostname.yml with content "bacula_fd_schedule: MoreFrequentSchedule").


### Extend global schedules:

- see "bacula-dir-fileset-default.conf.j2" for a example.
- create your own config snippet (jinja2 template) with additional Schedules (i.e.: $ansibleroot/templates/bacula_dir_schedules_extra.j2)
- define the variable "bacula_dir_schedule_extra_template" with the filename of your template ("bacula_dir_schedule_extra.j2"), so it is included by the standard template bacula-dir-schedules.j2 :
  example: add in "group_vars/bacula_dir.yml" this line: bacula_dir_schedule_extra_template: "bacula_dir_schedules_extra.j2

### Extend global filesets:

same as schedules but the var is "bacula_dir_fileset_extra"
