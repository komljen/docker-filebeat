# filebeat 6.x kubernetes ready docker image
Version: v0.0.1

## Modifying filebeat.yml
In order to overwrite ```filebeat.yml``` which is a part of the ```maskeda/filebeat``` docker image with the Kuberntes ConfigMap (filebeat-config.yaml), create the resource first:
```kubectl apply -f filebeat-config.yaml --namespace=default```

Then create filebeat DaemonSet which will mount above config:
```kubectl apply -f filebeat-ds.yaml --namespace=default```

## Sample filebeat-ds.yml
Please replace ```HOSTNAME:PORT``` with your hostname and port number and ```INDEX_VALUE``` with your index prefix.
```---
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
              value: info
            - name: INDEX_PREFIX
              value: "%{[@metadata][INDEX_VALUE]}-%{+YYY.MM.dd}"
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
            path: /var/lib/docker/containers```
