k --kubeconfig= /opt/course/1/kubeconfig config get-contexts

k --kubeconfig= /opt/course/1/kubeconfig config get-contexts -oname > /tmp/contexts.txt

k --kubeconfig= /opt/course/1/kubeconfig config current-context > /tmp/current-context.txt

echo "x" | base64 -d > /tmp/decoded.txt

# 1.
# helm repo list
# helm search repo
# helm -n minio install minio-operator minio/operator
# helm -n minio install {name} {chart}

# 2.
# kubectl -n project-c13 describe pod | less -p Requests
# kubectl -n project-c13 describe pod | grep -A 3 -E 'Requests|^Name:'

# 3.
# TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
# curl -k https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"

# 4.
# tolerations:                                  # add
#       - effect: NoSchedule                          # add
#         key: node-role.kubernetes.io/control-plane

# 5.
# nslookup kubernetes.default.svc.custom-domain

# 6.
# crictl ps
# crictl inspect <container_id> | grep runtimeType
