#!/bin/bash

##Cleanup wole bucket
for f in $(s3cmd ls s3://kconfig/ | awk '{print $4}'); do
  s3cmd rm $f
done

##Save
for c in $(doctl kubernetes clusters list --format Name | grep -v Name ); do
    if [[ "$c" != "Name" ]]; then
        echo "$c"
        doctl kubernetes cluster kubeconfig show $c > $c.kubeconfig.yaml
    fi
done;

##Upload
s3cmd put *.kubeconfig.yaml s3://kconfig/

## Clean local files
rm -f *.kubeconfig.yaml

##
echo "NE PAS OUBLIER DE RENDRE PUBLIC LES KUBECONFIG"

