terraform {
  backend "kubernetes" {
    secret_suffix = "external-dns"
    config_path   = "~/.kube/config"
    namespace     = "state"
  }
  required_version = ">= 0.13"
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "vault" {}
