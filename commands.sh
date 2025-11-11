k rollout history --revision=2
k rollout restart
k rollout status
k rollout undo --to-revision=4

k create secret generic secret1 --from-literal user=test --from-literal pass=pwd
k create configmap cm1 --from-file=index.html=/opt/course/15/web-moon.html

k get po -show-labels
k get po -l type=runner
k label po -l "type in (worker,runner)" protected=true
k annotate po -l protected=true protected="do not delete this pod"

k run pod1 --image=httpd:2.4.41-alpine --dry-run=client --labels project=plt-6cc-api,team=devops -o yaml > 2.yaml
k -n pluto expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80
