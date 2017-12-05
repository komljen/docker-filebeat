# filebeat 6.x kubernetes ready docker image
Version: v0.0.2a

## Modifying filebeat.yml
In order to overwrite the values for ```filebeat.yml``` which is a part of the ```maskeda/filebeat``` docker image with the Kuberntes ConfigMap (filebeat-config.yml), create the resource first:
```
kubectl apply -f filebeat-config.yml --namespace=default
```

Then create filebeat DaemonSet which will mount above config:
```
kubectl apply -f filebeat-ds.yml --namespace=default
```

## Sample filebeat-ds.yml
Please replace ```HOSTNAME:PORT``` with the desired hostname/port number and ```INDEX_VALUE``` with the preferred index prefix. The format of the INDEX_VALUE string can also be modified, please check the filebeat documentation for more info.  Please let the project know if any addtional options need to be added to the filebeat-ds.yml.
```
---
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  name: filebeat
  labels:
    app: filebeat
spec:
  template:
    metadata:
      labels:
        app: filebeat
      name: filebeat
    spec:
      containers:
        - name: filebeat
          image: maskeda/docker-filebeat
          resources:
            limits:
              cpu: 50m
              memory: 50Mi
          env:
            - name: LOGSTASH_HOSTS
              value: HOSTNAME:PORT
            - name: LOG_LEVEL
              value: debug
            - name: INDEX_PREFIX
              value: "INDEX_VALUE-%{[@metadata]}-%{+YYYY.MM.dd}"
          volumeMounts:
            - name: varlog
              mountPath: /var/log/containers
            - name: varlogpods
              mountPath: /var/log/pods
              readOnly: true
            - name: varlibdockercontainers
              mountPath: /var/lib/docker/containers
              readOnly: true
      terminationGracePeriodSeconds: 30
      volumes:
        - name: varlog
          hostPath:
            path: /var/log/containers
        - name: varlogpods
          hostPath:
            path: /var/log/pods
        - name: varlibdockercontainers
          hostPath:
            path: /var/lib/docker/containers
```
