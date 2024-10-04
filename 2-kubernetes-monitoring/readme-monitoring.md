# Deploy and Monitor Web Applications in Kubernetes with ArgoCD, Prometheus, Grafana, and HPA

This tutorial guides you through deploying a web application using ArgoCD, monitoring it with Prometheus and Grafana, and setting up Horizontal Pod Autoscaler (HPA) for automatic scaling.

## Prerequisites

- Minikube installed and running
- Helm CLI installed
- kubectl installed and configured to use your Minikube cluster
- Terraform installed

## Step 1: Start Minikube

```bash
minikube start --cpus=5 --memory=8192 --nodes=3
```

## Step 2: Update Hosts File

Add the following entries to your hosts file:

```
127.0.0.1 argocd.example.com
127.0.0.1 grafana.example.com
127.0.0.1 prometheus.example.com
127.0.0.1 dev.demo-webapp.local
127.0.0.1 pre.demo-webapp.local
127.0.0.1 demo-webapp.com
```

On Windows, use this PowerShell command:

```powershell
Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n127.0.0.1 argocd.example.com`n127.0.0.1 grafana.example.com`n127.0.0.1 prometheus.example.com`n127.0.0.1 dev.demo-webapp.local`n127.0.0.1 pre.demo-webapp.local`n127.0.0.1 demo-webapp.com" -Force
```

## Step 3: Start Minikube Tunnel

In a separate terminal, run:

```bash
minikube tunnel
```

Keep this running for the duration of your work with the cluster.

## Step 4: Deploy ArgoCD and Monitoring Stack

Navigate to the Terraform directory and apply the configuration:

```bash
cd 2-kubernetes-monitoring/terraform/cluster-setup
terraform init
terraform apply
```

This will deploy ArgoCD, Prometheus, and Grafana with the correct Ingress configurations. It will also enable the necessary Minikube addons.

## Step 5: Access ArgoCD, Grafana, and Prometheus

You can now access:
- ArgoCD at https://argocd.example.com
- Grafana at http://grafana.example.com
- Prometheus at http://prometheus.example.com

Retrieve the initial passwords:

```bash
terraform output argocd_initial_password
terraform output grafana_admin_password
```

## Step 6: Deploy Applications Using ArgoCD

Navigate to the apps Terraform directory:

```bash
cd ../apps
terraform init
terraform apply
```

This will create ArgoCD applications for dev, pre, and pro environments.

## Step 7: Access Your Web Applications

You should now be able to access your web applications at:
- http://dev.demo-webapp.local
- http://pre.demo-webapp.local
- http://demo-webapp.com

## Step 8: Monitor Your Applications

Access Grafana at http://grafana.example.com and set up dashboards to monitor your applications and Kubernetes cluster.

## Step 9: Load Testing and Observing HPA

Install k6 for load testing:

```bash
winget install -e --id k6.k6
```

Before running the load tests, open three separate terminal windows to monitor the HPA and pods for each environment:

Terminal 1 (Dev environment):
```bash
kubectl get hpa -n demo-webapp-dev -w
```

Terminal 2 (Pre environment):
```bash
kubectl get hpa -n demo-webapp-pre -w
```

Terminal 3 (Pro environment):
```bash
kubectl get hpa -n demo-webapp-pro -w
```

Now, run the load tests in your main terminal:

```bash
k6 run 2-kubernetes-monitoring/web/load-test-dev.js
k6 run 2-kubernetes-monitoring/web/load-test-pre.js
k6 run 2-kubernetes-monitoring/web/load-test-pro.js
```

While the tests are running, observe the HPA status in the other terminal windows. You should see the "TARGETS" column change as the load increases, and the "REPLICAS" column should increase when the target threshold is exceeded.

You can also watch the number of pods increase:

```bash
kubectl get pods -n demo-webapp-dev -w
kubectl get pods -n demo-webapp-pre -w
kubectl get pods -n demo-webapp-pro -w
```

Monitor the scaling events in Grafana to see how your application responds to increased load. You should be able to correlate the HPA actions with the changes in pod count and application performance.

By following these steps, you'll be able to directly observe how the HPA responds to increased load by scaling your application across three environments. This will give you a clear picture of how autoscaling works in response to the load tests.
