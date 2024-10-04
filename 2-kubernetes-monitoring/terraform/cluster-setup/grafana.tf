#Add namespace monitoring
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# Add the Prometheus community Helm repository
resource "helm_release" "prometheus_community_repo" {
  name             = "prometheus-community"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = kubernetes_namespace.monitoring.metadata[0].name

  values = [
    <<-EOT
    grafana:
      enabled: true
      ingress:
        enabled: true
        ingressClassName: nginx
        hosts:
          - grafana.example.com
        paths:
          - /
      adminPassword: ${random_password.grafana_password.result}
    prometheus:
      enabled: true
      ingress:
        enabled: true
        ingressClassName: nginx
        hosts:
          - prometheus.example.com
        paths:
          - /
    EOT
  ]

  depends_on = [kubernetes_namespace.monitoring]
}

resource "random_password" "grafana_password" {
  length  = 16
  special = false
}

output "grafana_admin_password" {
  value     = random_password.grafana_password.result
  sensitive = true
}

output "grafana_url" {
  value = "http://grafana.example.com"
}

output "prometheus_url" {
  value = "http://prometheus.example.com"
}
