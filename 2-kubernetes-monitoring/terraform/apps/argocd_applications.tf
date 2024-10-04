resource "kubernetes_manifest" "argocd_dev_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "demo-webapp-dev"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/altitoo/kubernetes-deployment-gitops-argocd.git"
        targetRevision = "HEAD"
        path           = "2-kubernetes-monitoring/web/overlays/dev"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "demo-webapp-dev"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "argocd_pre_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "demo-webapp-pre"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/altitoo/kubernetes-deployment-gitops-argocd.git"
        targetRevision = "HEAD"
        path           = "2-kubernetes-monitoring/web/overlays/pre"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "demo-webapp-pre"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

resource "kubernetes_manifest" "argocd_pro_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "demo-webapp-pro"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/altitoo/kubernetes-deployment-gitops-argocd.git"
        targetRevision = "HEAD"
        path           = "2-kubernetes-monitoring/web/overlays/pro"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "demo-webapp-pro"
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
      }
    }
  }
}

# Create namespaces for each environment
resource "kubernetes_namespace" "demo_webapp_dev" {
  metadata {
    name = "demo-webapp-dev"
  }
}

resource "kubernetes_namespace" "demo_webapp_pre" {
  metadata {
    name = "demo-webapp-pre"
  }
}

resource "kubernetes_namespace" "demo_webapp_pro" {
  metadata {
    name = "demo-webapp-pro"
  }
}
