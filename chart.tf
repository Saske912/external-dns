resource "kubernetes_namespace" "external-dns" {
  metadata {
    name = "external-dns"
  }
}

data "vault_kv_secret_v2" "bind9" {
  mount = "kv"
  name  = "bind9"
}

locals {
  bind9 = data.vault_kv_secret_v2.bind9.data
}

resource "helm_release" "external-dns" {
  chart      = "external-dns"
  name       = "external-dns"
  namespace  = kubernetes_namespace.external-dns.metadata.0.name
  repository = "https://charts.bitnami.com/bitnami"
  version    = "8.0.2"
  values = [templatefile("${path.module}/externalDnsValues.yml", {
    host          = local.bind9.server
    zone          = local.bind9.zone
    tsigSecret    = local.bind9.key_secret
    key_algorithm = local.bind9.key_algorithm
    key_name      = local.bind9.key_name
  })]
}
