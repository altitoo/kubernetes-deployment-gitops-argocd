# Deploy and Monitor Web Applications in Kubernetes with ArgoCD, Prometheus, Grafana, and HPA

In this tutorial, you will learn how to deploy a web application using ArgoCD, monitor it using Prometheus and Grafana, and finally, set up an HPA (Horizontal Pod Autoscaler) to automatically scale the application when demand increases.

## Prerequisites

- Minikube installed.
- Helm CLI: Make sure to install Helm on your system:

```bash
winget install Helm.Helm
```

- ArgoCD previously installed and configured (refer to the previous video for more details).

## Step 1: Enable `metrics-server` to get pod metrics and `ingress`

The `metrics-server` is required for HPA to function properly.

```bash
minikube addons enable metrics-server
minikube addons enable ingress
kubectl get pods -n kube-system
```

## Step 2: Install ArgoCD

Install ArgoCD in your cluster:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

To retrieve the initial password for ArgoCD:

```bash
$base64Encoded = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Encoded))
```

## Step 3: Access the ArgoCD Dashboard

To access the ArgoCD dashboard, set up port-forwarding from your local machine to the ArgoCD server:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Access ArgoCD at `https://localhost:8080` with the username `admin` and the password retrieved above.

## Step 4: Add Prometheus and Grafana to the Helm Repo

Prometheus will be used to capture metrics from the Kubernetes cluster, and Grafana will be used for visualizing these metrics.

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

## Step 5: Install Prometheus and Grafana in the Monitoring Namespace

Create a namespace called `monitoring` and install the Prometheus and Grafana stack.

```bash
kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
```

Grafana will be exposed on port 3000. Use port-forwarding to access its web interface.

```bash
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
```

To retrieve the initial admin password for Grafana:

```bash
$base64Encoded = kubectl get secret prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64Encoded))
```

You can now access Grafana at `http://localhost:3000` with the username `admin`.

## Step 7: Set Up Ingress to Expose Your Web Application

Ensure that Ingress is enabled in Minikube:

Update your `/etc/hosts` file or Windows hosts file to map Minikube IP to environment-specific domains:

```bash
$minikubeIP = minikube ip
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n$($minikubeIP) dev.demo-webapp.local" -Force
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n$($minikubeIP) pre.demo-webapp.local" -Force
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n$($minikubeIP) demo-webapp.com" -Force
```

By following these steps, you’ll have a web application deployed, monitored with Prometheus and Grafana, and set up with autoscaling via an HPA. You can visualize how pods scale up as traffic increases in Grafana.

## Step 8: Execute load testing against our web

```bash
winget install -e --id k6.k6
```
