# Create a namespace for ArgoCD

resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.6.8"

  values = [
    <<-EOT
    server:
      ingress:
        enabled: true
        hosts:
          - argocd.example.com
        paths:
          - /
        pathType: Prefix
        ingressClassName: nginx
    configs:
      params:
        server.insecure: true
    EOT
  ]

  set {
    name  = "crds.install"
    value = true
  }
}

data "kubernetes_secret" "argocd_initial_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [helm_release.argocd]
}

output "argocd_initial_password" {
  value     = data.kubernetes_secret.argocd_initial_password.data.password
  sensitive = true
}