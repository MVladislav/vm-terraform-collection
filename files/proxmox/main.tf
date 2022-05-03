terraform {

  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

# ------------------------------------------------------------------------------

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

# ------------------------------------------------------------------------------

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  pm_tls_insecure = true
}

# ------------------------------------------------------------------------------

variable "proxmox_vm_ci_user" {
  type = string
}

variable "proxmox_vm_ci_pw" {
  type      = string
  sensitive = true
}

variable "proxmox_vm_ssh_key" {
  type      = string
  sensitive = true
}

# ------------------------------------------------------------------------------

variable "proxmox_vm_name" {
  type = string
}

variable "proxmox_vm_desc" {
  type = string
}

variable "proxmox_vm_id" {
  type = string
}

variable "proxmox_vm_target_node" {
  type = string
}

variable "proxmox_vm_template_clone" {
  type = string
}

variable "proxmox_vm_bridge" {
  type = string
}

variable "proxmox_vm_macaddr" {
  type = string
}
