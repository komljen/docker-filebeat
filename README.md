## Filebeat kube ready image

To overwrite filebeat.yml file with Kuberntes ConfigMap (filebeat-config.yaml), create resource first:

```
kubectl create -f filebeat-config.yaml --namespace=default
```

Then create filebeat DaemonSet which will mount above config:

```
kubectl create -f filebeat-ds.yaml --namespace=default
```

