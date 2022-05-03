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

  # host                   = yamldecode(TODO).clusters.0.cluster.server
  # client_certificate     = base64decode(yamldecode(TODO).users.0.user.client-certificate-data)
  # client_key             = base64decode(yamldecode(TODO).users.0.user.client-key-data)
  # cluster_ca_certificate = base64decode(yamldecode(TODO).clusters.0.cluster.certificate-authority-data)
}

provider "kubectl" {
  config_path    = var.kube_config_path
  config_context = var.kube_config_context

  # host                   = yamldecode(TODO).clusters.0.cluster.server
  # client_certificate     = base64decode(yamldecode(TODO).users.0.user.client-certificate-data)
  # client_key             = base64decode(yamldecode(TODO).users.0.user.client-key-data)
  # cluster_ca_certificate = base64decode(yamldecode(TODO).clusters.0.cluster.certificate-authority-data)
  # load_config_file       = false
}

provider "helm" {
  kubernetes {
    config_path    = var.kube_config_path
    config_context = var.kube_config_context

    # host                   = yamldecode(TODO).clusters.0.cluster.server
    # client_certificate     = base64decode(yamldecode(TODO).users.0.user.client-certificate-data)
    # client_key             = base64decode(yamldecode(TODO).users.0.user.client-key-data)
    # cluster_ca_certificate = base64decode(yamldecode(TODO).clusters.0.cluster.certificate-authority-data)
  }
}

# ------------------------------------------------------------------------------

variable "kube_config_path" {
  type = string
}

variable "kube_config_context" {
  type = string
}

# ------------------------------------------------------------------------------
