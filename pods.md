# Pods

## Basic Pod Operations

- `kubectl get pods` or `kubectl get po` - List all pods in the current namespace.
- `kubectl get pods --all-namespaces` - List all pods across all namespaces.
- `kubectl describe pod [POD_NAME]` or `kubectl describe po [POD_NAME]` - Show detailed information about a specific pod.
- `kubectl create -f [POD_CONFIG.YAML]` - Create a pod using a configuration file.
- `kubectl apply -f [POD_CONFIG.YAML]` - Apply a configuration to a pod.
- `kubectl edit pod [POD_NAME]` - Edit a pod's configuration in place.
- `kubectl replace -f [POD_CONFIG.YAML]` - Replace a pod's configuration from a file.

## Pod Lifecycle Management

- `kubectl delete pod [POD_NAME]` or `kubectl delete po [POD_NAME]` - Delete a specific pod.
- `kubectl delete pod --all` - Delete all pods in the current namespace.
- `kubectl delete pods --field-selector status.phase=Succeeded` - Delete pods with status 'Succeeded'.
- `kubectl delete pods --field-selector status.phase=Failed` - Delete pods with status 'Failed'.

## Pod Logs and Events

- `kubectl logs [POD_NAME]` - Fetch logs from a pod.
- `kubectl logs [POD_NAME] -c [CONTAINER_NAME]` - Fetch logs from a specific container in a pod.
- `kubectl logs -f [POD_NAME]` - Stream logs from a pod.
- `kubectl logs --previous [POD_NAME]` - Fetch logs from the previous instance of a pod if it crashed.
- `kubectl get events --field-selector involvedObject.name=[POD_NAME]` - Get events related to a specific pod.

## Pod Execution and Debugging

- `kubectl exec [POD_NAME] -- [COMMAND]` - Execute a command in a specific pod.
- `kubectl exec -it [POD_NAME] -- /bin/bash` - Start a bash session in a pod.
- `kubectl port-forward [POD_NAME] [LOCAL_PORT]:[POD_PORT]` - Forward one or more local ports to a pod.
- `kubectl cp [POD_NAME]:[SOURCE_PATH] [DEST_PATH]` - Copy files from a pod to the local machine.
- `kubectl cp [LOCAL_PATH] [POD_NAME]:[DEST_PATH]` - Copy files from the local machine to a pod.

## Pod Monitoring and Troubleshooting

- `kubectl top pod [POD_NAME]` - Show resource (CPU/memory) usage of a specific pod.
- `kubectl top pod` - Show resource usage of all pods.
- `kubectl get pod [POD_NAME] -o yaml` - Output a pod's configuration in YAML format.
- `kubectl get pod [POD_NAME] -o json` - Output a pod's configuration in JSON format.

## Advanced Pod Operations

- `kubectl patch pod [POD_NAME] -p '{"spec":{"containers":[{"name":"[CONTAINER_NAME]","image":"[NEW_IMAGE]"}]}}'` - Update the image of a container in a pod.
- `kubectl scale pod [POD_NAME] --replicas=[NUMBER]` - Scale the number of replicas for a pod.
- `kubectl label pod [POD_NAME] [LABEL_KEY]=[LABEL_VALUE]` - Add or update a label for a pod.
- `kubectl annotate pod [POD_NAME] [ANNOTATION_KEY]=[ANNOTATION_VALUE]` - Add or update an annotation for a pod.

## Pod Node Operations

- `kubectl cordon [NODE_NAME]` - Mark a node as unschedulable.
- `kubectl drain [NODE_NAME]` - Drain a node, moving all pods to other nodes.
- `kubectl uncordon [NODE_NAME]` - Mark a node as schedulable again.

## Managing Pod Affinity and Anti-Affinity

- `kubectl label node [NODE_NAME] [LABEL_KEY]=[LABEL_VALUE]` - Label a node for pod scheduling.
- `kubectl taint node [NODE_NAME] [KEY]=[VALUE]:[EFFECT]` - Taint a node to control pod placement.

## Pod Configuration Management

- `kubectl rollout status pod [POD_NAME]` - Watch a pod's rollout status.
- `kubectl rollout restart pod [POD_NAME]` - Restart a pod.

This list includes basic, advanced, and some specialized commands for managing and troubleshooting pods in Kubernetes.

## Pod definition

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-multi-container-pod # Name of the Pod
  namespace: default # Namespace where the Pod will be created
  labels:
    app: myapp # Labels to identify the Pod
    tier: backend # Additional label for categorizing the Pod
  annotations:
    description: "This is a sample pod with multiple containers, volume mounts, and advanced configurations." # Annotations provide metadata that can be used by external tools

spec:
  restartPolicy: Always # Restart policy for the Pod (Always, OnFailure, Never)
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      # The scheduler will only place the pod on nodes that meet the specified criteria
        nodeSelectorTerms:
        # This rule specifies that the pod must be scheduled on nodes labeled with kubernetes.io/e2e-az-name and the value must be either e2e-az1 or e2e-az2.
        - matchExpressions:
          - key: kubernetes.io/e2e-az-name
            operator: In
            values:
            - e2e-az1 # Node must be in either e2e-az1
            - e2e-az2 # or e2e-az2
      # This rule is a preference, not a requirement. The scheduler will try to place the pod on nodes that meet the criteria, but it will still schedule the pod even if no such nodes are available
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 1 # Weight for preferred node selection
        preference:
          matchExpressions:
          - key: another-node-label-key
            operator: In
            values:
            - another-node-label-value
    # podAntiAffinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: security
            operator: In
            values:
            - S1 # Pods with the label key `security` and value `S1`
        topologyKey: "kubernetes.io/hostname" # Must be co-located (on the same node)

  containers:
  - name: ubuntu-container # Name of the container
    image: ubuntu # Container image
    command: ["/bin/sh"] # Command to run in the container
    args: ["-c", "echo Hello Kubernetes! && sleep 3600"] # Arguments for the command
    ports:
    - containerPort: 8080 # Port exposed by the container
    env:
    - name: ENV_VAR_1
      value: "value1" # Static environment variable
    - name: ENV_VAR_2
      valueFrom:
        secretKeyRef:
          name: mysecret # Reference to a Kubernetes secret
          key: password # Key within the secret
    resources:
      limits:
        memory: "128Mi" # Memory limit
        cpu: "500m" # CPU limit
      requests:
        memory: "64Mi" # Memory request
        cpu: "250m" # CPU request
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config # Mounts the volume at /etc/config
    livenessProbe:
      httpGet:
        path: /healthz # Path to check for liveness
        port: 8080
      initialDelaySeconds: 3 # Delay before starting probes
      periodSeconds: 3 # Probe interval
    readinessProbe:
      httpGet:
        path: /readiness # Path to check for readiness
        port: 8080
      initialDelaySeconds: 3
      periodSeconds: 3

  - name: nginx-container # Second container in the Pod
    image: nginx # Container image
    ports:
    - containerPort: 80 # Port exposed by the container
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html # Mounts the volume at /usr/share/nginx/html
    envFrom:
    - configMapRef:
        name: my-config-map # References a ConfigMap for environment variables

  initContainers:
  - name: init-myservice
    image: busybox
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;'] # Command to run in the init container

  volumes:
  - name: config-volume
    configMap:
      name: my-config-map # ConfigMap to be used as a volume
  - name: html
    emptyDir: {} # EmptyDir volume that is created empty when the Pod is assigned to a node

  nodeSelector:
    disktype: ssd # Node selector for scheduling

  tolerations:
  - key: "key1"
    operator: "Equal"
    value: "value1"
    effect: "NoSchedule" # Toleration for NoSchedule taints
  - key: "key2"
    operator: "Exists"
    effect: "NoExecute"
    tolerationSeconds: 3600 # Toleration with a time limit

  hostNetwork: false # Whether to use the host's network namespace
  dnsPolicy: Default # DNS policy for the Pod
  securityContext:
    runAsUser: 1000 # Run containers as this user
    fsGroup: 2000 # File system group for the Pod
  serviceAccountName: my-service-account # Service account to be used

  imagePullSecrets:
  - name: myregistrykey # Secret for pulling images from a private registry

  priorityClassName: high-priority # Priority class for the Pod

  schedulerName: default-scheduler # Scheduler to be used
```
