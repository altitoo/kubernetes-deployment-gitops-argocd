locals {
  minikube_addons = {
    metrics_server = "enable"
    ingress        = "enable"
    ingress_dns    = "enable"
  }
}

resource "terraform_data" "minikube_addons" {
  provisioner "local-exec" {
    command = <<-EOT
      $ErrorActionPreference = "Stop"
      $addons = @("metrics-server", "ingress", "ingress-dns")
      foreach ($addon in $addons) {
        Write-Host "Enabling $addon addon..."
        minikube addons enable $addon
        if ($LASTEXITCODE -ne 0) {
          throw "Failed to enable $addon addon"
        }
      }
    EOT
    interpreter = ["powershell", "-Command"]
  }

  triggers_replace = [
    sha256(jsonencode(local.minikube_addons))
  ]
}

