# K8S

Create pod with image:

* kubectl run nginx --image=nginx

Get node of which pods are deployed:

* kubectl get po -o wide

Create a replicaset:

```yaml
apiVersion: apps/v1 # important
kind: ReplicaSet # important
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      tier: frontend # important
  template:
    metadata:
      labels:
        tier: frontend # important
    spec:
      containers:
      - name: nginx
        image: nginx
```

Scale replicas

* kubectl scale rs/rs-name --replicas=4

Create deployment:

```yaml
apiVersion: apps/v1 # important
kind: Deployment # important
metadata:
  name: deployment-1
spec:
  replicas: 2
  selector:
    matchLabels:
      name: busybox-pod
  template:
    metadata:
      labels:
        name: busybox-pod
    spec:
      containers:
      - name: busybox-container
        image: busybox
        command:
        - sh
        - "-c"
        - "echo Hello Kubernetes! && sleep 3600" # important
```

Which namespace has the blue pod in it?

* kubectl get pods --all-namespaces | grep blue
