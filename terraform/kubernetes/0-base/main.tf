terraform {

  # https://github.com/hashicorp/terraform/releases
  required_version = ">= 1.2.8"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/kubernetes
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.13.1"
    }

    # https://registry.terraform.io/providers/gavinbunney/kubectl
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    # https://registry.terraform.io/providers/hashicorp/helm
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }

  }

}

# ------------------------------------------------------------------------------

provider "kubernetes" {
  config_path    = var.kube_config_path
  config_context = var.kube_config_context
}

provider "kubectl" {
  config_path    = var.kube_config_path
  config_context = var.kube_config_context
}

provider "helm" {
  kubernetes {
    config_path    = var.kube_config_path
    config_context = var.kube_config_context
  }
}

# ------------------------------------------------------------------------------

variable "kube_config_path" {
  type = string
}

variable "kube_config_context" {
  type = string
}

variable "kube_cert_cluster_issuer" {
  type = string
}

variable "kube_cert_ingress_class" {
  type = string
}

# ------------------------------------------------------------------------------

variable "kube_traefik_entrypoints" {
  type = string
}

variable "kube_traefik_tls" {
  type = string
}

variable "kube_traefik_middlewares" {
  type = string
}

variable "kube_public_hostname" {
  type = string
}

# ------------------------------------------------------------------------------
