function obtainRoute {
  oc get route icp-console -n kube-system \
    -o jsonpath='{@.status.ingress[0].host}'
}



MASTER_URL=https://$(obtainRoute)

. ~/icp.sh


echo Configuring Helm CLI for ICP on $MASTER_URL
cloudctl login -a $MASTER_URL -u admin -p $ICP_PASSWORD -n kube-system \
  --skip-ssl-validation
