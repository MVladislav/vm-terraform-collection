resource "proxmox_vm_qemu" "ubuntu_vm_clone" {
  count       = var.vm_count
  name        = "${var.proxmox_vm_name}-0${count.index + 1}"
  desc        = "${var.proxmox_vm_desc} 0${count.index + 1}"
  vmid        = var.proxmox_vm_id + count.index
  target_node = var.proxmox_vm_target_node

  clone      = var.proxmox_vm_template_clone
  full_clone = true

  agent = 1
  # boot     = "cdn"
  bootdisk = "scsi0"
  onboot   = false
  oncreate = true

  # not activate cpu,memory - this will break the vm
  hotplug = "network,disk,usb"

  cpu     = var.proxmox_vm_cpu
  cores   = var.proxmox_vm_cores
  sockets = 1
  numa    = true

  memory  = var.proxmox_vm_memory_gb * 1024
  balloon = 0

  scsihw = "virtio-scsi-pci"
  disk {
    storage  = var.proxmox_vm_storage_name
    type     = "scsi"
    size     = "${var.proxmox_vm_size_gb}G"
    ssd      = 1
    backup   = 1
    discard  = "on"
    iothread = 1
  }

  network {
    bridge    = var.proxmox_vm_bridge
    model     = "virtio"
    firewall  = false
    link_down = false
    macaddr   = "${var.proxmox_vm_macaddr}${count.index + 1}"
  }

  os_type    = "cloud-init"
  ipconfig0  = "ip=dhcp"
  ciuser     = var.proxmox_vm_ci_user
  cipassword = var.proxmox_vm_ci_pw
  sshkeys    = <<EOF
  ${var.proxmox_vm_ssh_key}
  EOF

  lifecycle {
    ignore_changes = [
      network,
    ]
  }
}
