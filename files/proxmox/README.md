# SETUP

```sh
    MVladislav
```

---

- [SETUP](#setup)
  - [Proxmox setup](#proxmox-setup)
    - [create user/group](#create-usergroup)
    - [create credentials for terraform](#create-credentials-for-terraform)
  - [templating](#templating)
    - [ubuntu 22.04 [jammy] template](#ubuntu-2204-jammy-template)
    - [ubuntu 21.10 [impish] template](#ubuntu-2110-impish-template)
  - [References](#references)

---

## Proxmox setup

### create user/group

create **group**:: go into `Datacenter > Permissions > Groups`,
and create a group for **terrform** (name it terrform)

create **permission**:: go into `Datacenter > Groups`,
and create a new permission, with **following values**:

- Path: `/`
- Group: `terrform`
- Role: `PVEVMAdmin`
- Propagate: `x`

**and**

- Path: `/storage/local-zfs`
- Group: `terrform`
- Role: `PVEDatastoreUser`
- Propagate: `x`

create **user**:: go into `Datacenter > Permissions > Users`,
and create a new user, with **following values**:

- User name: `terrform`
- Realm: `Proxmox VE authentication server` _(pve)_
- Password: `***`
- Group: `terrform`

create **token**:: go into `Datacenter > Permissions > API Tokens`,
and create a token which the user can use, we current created, with **follwing values**:

> when you create the token, save it, you can not show it later again.

- User: `terrform@pve`
- Token ID: `terrform`
- Privilege Seperation: ` ` _(empty)_

### create credentials for terraform

create file named `credentials.auto.tfvars` and add following lines:

```tf
proxmox_api_url          = "https://<URL>:8006/api2/json"
proxmox_api_token_id     = "<ID>"
proxmox_api_token_secret = "<SECRET>"

proxmox_vm_ci_user = "<USERNAME>"
proxmox_vm_ci_pw   = "<PASSWORD>"
proxmox_vm_ssh_key = "<SSH_PUBLIC_KEY>"

proxmox_vm_name           = "ubuntu-impish"
proxmox_vm_desc           = "Ubuntu Server 21.10 (Impish)"
proxmox_vm_id             = "666"
proxmox_vm_target_node    = "proxmox"
proxmox_vm_template_clone = "template-ubuntu-impish-cloud-init"

proxmox_vm_bridge  = "vmbr0"
proxmox_vm_macaddr = "86:AF:FE:AF:FE:01"
```

## templating

to use terraform to create VMs with cloud-init, we need first a template,
which we can than use for clone.

ssh into your Proxmox instance and run following command to create a template:

### ubuntu 22.04 [jammy] template

> **current cloud init problems, use impish instead**

```sh
# download the image
$wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img -O /var/lib/vz/template/iso/jammy-server-cloudimg.img

# create a new VM
$qm create 9999 --name "template-ubuntu-jammy-cloud-init" --memory 2048 --net0 virtio,bridge=vmbr0 --cpu cputype=host,flags="+aes;+pdpe1gb" --cores 2 --numa 1

# import the downloaded disk to local-zfs storage
$qm importdisk 9999 /var/lib/vz/template/iso/jammy-server-cloudimg.img local-zfs
# finally attach the new disk to the VM as scsi drive
$qm set 9999 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9999-disk-0,ssd=1,discard=on

# add cloud-init cd-rom drive
$qm set 9999 --ide2 local-zfs:cloudinit
$qm set 9999 --boot c --bootdisk scsi0
$qm set 9999 --serial0 socket --vga serial0
$qm set 9999 --agent 1

# convert to template
$qm template 9999
```

### ubuntu 21.10 [impish] template

```sh
# download the image
$wget https://cloud-images.ubuntu.com/impish/current/impish-server-cloudimg-amd64.img -O /var/lib/vz/template/iso/impish-server-cloudimg.img

# create a new VM
$qm create 9998 --name "template-ubuntu-impish-cloud-init" --memory 2048 --net0 virtio,bridge=vmbr0 --cpu cputype=host,flags="+aes;+pdpe1gb" --cores 2 --numa 1

# import the downloaded disk to local-zfs storage
$qm importdisk 9998 /var/lib/vz/template/iso/impish-server-cloudimg.img local-zfs
# finally attach the new disk to the VM as scsi drive
$qm set 9998 --scsihw virtio-scsi-pci --scsi0 local-zfs:vm-9998-disk-0,ssd=1,discard=on

# add cloud-init cd-rom drive
$qm set 9998 --ide2 local-zfs:cloudinit
$qm set 9998 --boot c --bootdisk scsi0
$qm set 9998 --serial0 socket --vga serial0
$qm set 9998 --agent 1

# convert to template
$qm template 9998
```

---

## References

- <https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu>
- <https://pve.proxmox.com/wiki/Cloud-Init_Support>
- <https://pve.proxmox.com/pve-docs/qm.1.html>
- <https://cloud-images.ubuntu.com/jammy/current/>

---

**☕ COFFEE is a HUG in a MUG ☕**
