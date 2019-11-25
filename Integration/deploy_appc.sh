NAME=$1
PROJECT=ace
SCC=ibm-anyuid-hostpath-scc
IMAGE_SECRET=prod-secret

function associateSCC {
  oc adm policy add-scc-to-group $SCC system:serviceaccounts:$PROJECT
}


# Redundant?
function createRoleBinding {
  oc create rolebinding appc-security-policy \
  --clusterrole=ibm-anyuid-hostpath-scc \
  --group=system:serviceaccounts:$PROJECT
}

function obtainRoute {
  oc get route icp-proxy -n kube-system \
    -o jsonpath='{@.status.ingress[0].host}'
}

function createImagePullSecret {
  oc delete secret $IMAGE_SECRET
  oc create secret docker-registry $IMAGE_SECRET \
    --docker-server=cp.icr.io --docker-username=ekey \
    --docker-password=$ENTITLEMENT_KEY
}

function obtainDockerSecret {
  oc get secret -o custom-columns=NAME:{.metadata.name} | grep deployer-dockercfg
}

function deployHelm {
  echo Deploying $NAME
  helm install https://github.com/IBM/charts/blob/master/repo/entitled/ibm-ace-dashboard-icp4i-prod-2.2.0.tgz?raw=true \
    --name $NAME --tls --set image.pullSecret=$IMAGE_SECRET \
    --set persistence.storageClassName=ibmc-file-bronze --set ssoEnabled=false \
    --set tls.hostname=$ROUTE
}



oc project $PROJECT
echo Deploying App Connect $NAME
associateSCC
#createRoleBinding

ENTITLEMENT_KEY=$(pak-entitlement.sh show-key Integration)
echo Key: $ENTITLEMENT_KEY

createImagePullSecret

ROUTE=$(obtainRoute)
echo Route: $ROUTE

deployHelm
