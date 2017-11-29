## Filebeat kube ready image

To overwrite ```filebeat.yml``` which is a part of the ```maskeda/filebeat``` docker image with Kuberntes ConfigMap (filebeat-config.yaml), create the resource first:

```
kubectl apply -f filebeat-config.yaml --namespace=default
```

Then create filebeat DaemonSet which will mount above config:

```
kubectl apply -f filebeat-ds.yaml --namespace=default
```

