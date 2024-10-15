#!/usr/bin/bash
start=$(date +%s)
kubectl delete -f ../EKS/echoserver_full.yml
kubectl delete -f ../EKS/env-echoserver.yml
#kubectl delete -f grafana.yml
# spare 60 seconds for the above commands to remove the assets
#sleep 60
# https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
kubectl patch ingress argocd-ingress -n argocd -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch ingress grafana -n monitoring -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch ingress kube-ops-ingress -n monitoring -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl patch ingress prometheus -n monitoring -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl delete nodes --all
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheusagents.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd scrapeconfigs.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
kubectl delete --all nodeclaim
kubectl delete --all nodepool
kubectl delete --all ec2nodeclass

cluster_arn=$(kubectl config get-clusters | grep "arn:aws:eks:")
kubectl config  delete-cluster "${cluster_arn}"
terraform destroy --auto-approve
end=$(date +%s)
echo Execution time was "$((end - start))" seconds.