1) NodePort (curl z dowolnego miejsca, które routuje do NODE_IP)
# 1) znajdź NodePort
kubectl get svc <svc> -n <ns> -o wide
# albo tylko porty:
kubectl get svc <svc> -n <ns> -o jsonpath='{.spec.ports[*].nodePort}{"\n"}'

# 2) weź IP node’a (InternalIP lub ExternalIP)
kubectl get nodes -o wide

# 3) curl:
curl -v http://<NODE_IP>:<NODEPORT>/
# jeśli HTTPS:
curl -vk https://<NODE_IP>:<NODEPORT>/

2) ClusterIP (curl “z klastru”)
# 1) weź ClusterIP i port
kubectl get svc <svc> -n <ns> -o wide
# 2) curl z Poda testowego:
curl -v http://<CLUSTER_IP>:<PORT>/
# Alternatywnie przez DNS (często wygodniejsze):
curl -v http://<svc>.<ns>.svc.cluster.local:<PORT>/

3) Headless Service (clusterIP: None) – curl do PODów bezpośrednio
# Headless nie ma ClusterIP, więc zwykle:
# A) curl po DNS “na service” (zwraca wiele A-recordów – trafisz w jeden z Podów)
curl -v http://<svc>.<ns>.svc.cluster.local:<PORT>/

4) Ingress (curl przez host/path)
# 1) znajdź adres Ingress (LB IP/hostname) lub NodePort kontrolera (np. ingress-nginx)
kubectl get ingress -A
kubectl describe ingress <ing> -n <ns>

# 2) jeśli Ingress ma ADDRESS (LB):
curl -v -H "Host: <HOSTNAME_Z_INGRESS>" http://<INGRESS_ADDRESS>/<PATH>
# jeśli masz DNS ustawiony na ten ADDRESS:
curl -v http://<HOSTNAME_Z_INGRESS>/<PATH>

# 3) jeśli kontroler jest wystawiony NodePort (często w labach):
# znajdź NodePort kontrolera (np. svc/ingress-nginx-controller) i użyj NODE_IP:NODEPORT
curl -v -H "Host: <HOSTNAME_Z_INGRESS>" http://<NODE_IP>:<NODEPORT>/<PATH>

5) Gateway API (Gateway + HTTPRoute)
# 1) znajdź adres Gateway (zależnie od kontrolera może być w statusie)
kubectl get gateway -A
kubectl describe gateway <gw> -n <ns>
# czasem pomocne:
kubectl get svc -A | grep -i gateway

# 2) curl (z host header, jeśli hostnames są ustawione w listener/route)
curl -v -H "Host: <HOSTNAME>" http://<GATEWAY_ADDRESS_OR_IP>:<PORT>/<PATH>

# 3) jeśli Gateway jest za NodePort/LoadBalancer service:
# - LoadBalancer: użyj EXTERNAL-IP
# - NodePort: użyj NODE_IP:NODEPORT
curl -v -H "Host: <HOSTNAME>" http://<NODE_IP>:<NODEPORT>/<PATH>
