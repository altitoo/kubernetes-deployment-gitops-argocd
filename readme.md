# Descargar Instalador de aplicaciones de Windows 

https://apps.microsoft.com/detail/9nblggh4nns1?rtc=1&hl=es-es&gl=ES#activetab=pivot:overviewtab


# Instalar kubectl CLI 

https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/

```bash
winget install -e --id Kubernetes.kubectl
kubectl version --client
```

> En caso de error agregar al PATH en variables de entorno el binario de kubectl


# Instalar minikube CLI 

https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2Fwindows+package+manager
```bash
winget install Kubernetes.minikube
```
> En caso de error agregar al PATH en variables de entorno el binario de minikube

