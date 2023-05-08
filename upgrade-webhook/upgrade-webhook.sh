#!/bin/bash

if [ -n "$DEBUG" ]
then
    set -x
fi

usage() {
    echo "./upgrade-webhook.sh [--insecure-skip-tls-verify]"
    echo "Requires kubectl and helm to be installed and available on \$PATH"
    echo "--insecure-skip-tls-verify can be set to configure the script to ignore tls verification"
    echo "RANCHER_TOKEN must be set with an admin token generated with no scope"
    echo "RANCHER_URL must be set with the url of rancher (no trailing /) - should be the server URLi"
    echo "WEBHOOK_IMAGE must be set before proceeding to upgrade the image"
}

if [[ -z "$RANCHER_TOKEN" || -z "$RANCHER_URL" ]]
then
	echo "Env vars not properly set"
	usage
	exit -1
fi

tlsVerify="$1"

kubeconfig="
apiVersion: v1
kind: Config
clusters:
- name: \"local\"
  cluster:
    server: \"$RANCHER_URL\"

users:
- name: \"local\"
  user:
    token: \"$RANCHER_TOKEN\"


contexts:
- name: \"local\"
  context:
    user: \"local\"
    cluster: \"local\"

current-context: \"local\"
"

echo "$kubeconfig" >> .temp_kubeconfig.yaml
# helm will complain if these are group/world readable
chmod g-r .temp_kubeconfig.yaml
chmod o-r .temp_kubeconfig.yaml
export KUBECONFIG="$(pwd)/.temp_kubeconfig.yaml"

if [[ "$tlsVerify" != "" ]]
then
	kubectl config set clusters.local.insecure-skip-tls-verify true 
fi

clusters=$(kubectl get clusters.management.cattle.io -o jsonpath="{.items[*].metadata.name}")
for cluster in $clusters
do
	echo "Upgrading webhook for $cluster"
	kubectl config set clusters.local.server "$RANCHER_URL/k8s/clusters/$cluster"
        kubectl set image deployment/rancher-webhook rancher-webhook=$WEBHOOK_IMAGE -n cattle-system 	
done

rm .temp_kubeconfig.yaml
