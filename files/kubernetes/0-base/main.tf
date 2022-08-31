terraform {

  required_version = ">= 0.13.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
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
