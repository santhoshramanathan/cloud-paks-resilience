NAME=$1
PROJECT=ace
SCC=ibm-anyuid-hostpath-scc
IMAGE_SECRET=prod-secret

function associateSCC {
  oc adm policy add-scc-to-group $SCC system:serviceaccounts:$PROJECT
}


function createRoleBinding {
  oc -n $PROJECT create rolebinding apic-security-policy \
  --clusterrole=ibm-anyuid-hostpath-scc \
  --group=system:serviceaccounts:$PROJECT
}

# Not needed
function createTlsSecret {
  echo Creating TLS Secret...
  oc delete secret helm-tls-secret
  oc create secret generic helm-tls-secret \
    --from-file=cert.pem=$HOME/.helm/cert.pem \
    --from-file=ca.pem=$HOME/.helm/ca.pem \
    --from-file=key.pem=$HOME/.helm/key.pem
}

# Not needed
function obtainRoute {
  oc get route icp-proxy -n kube-system \
    -o jsonpath='{@.status.ingress[0].host}'
}

# Not needed
function buildValues {
  sed s/\$ROUTE/$ROUTE/g < values.yaml.template > /tmp/values.yaml
}

# Deprecated
function createImagePullSecret {
  oc delete secret $IMAGE_SECRET
  oc create secret docker-registry $IMAGE_SECRET \
    --docker-server=cp.icr.io --docker-username=ekey \
    --docker-password=$ENTITLEMENT_KEY
}

function obtainDockerSecret {
  oc get secret -o custom-columns=NAME:{.metadata.name} | grep deployer-dockercfg
}

function obtainRoute {
  oc get route icp-proxy -n kube-system \
    -o jsonpath='{@.status.ingress[0].host}'
}

function deployHelm {
  echo Deploying $NAME
  helm install https://github.com/IBM/charts/blob/master/repo/entitled/ibm-ace-dashboard-icp4i-prod-2.2.0.tgz?raw=true \
    --name $NAME --tls --set image.pullSecret=$IMAGE_SECRET \
    --set persistence.storageClassName=ibmc-file-bronze --set ssoEnabled=false \
    --set tls.hostname=$ROUTE
    #-f /tmp/values.yaml
}



oc project $PROJECT
echo Deploying App Connect $NAME
#associateSCC
#createRoleBinding

ENTITLEMENT_KEY=$(pak-entitlement.sh show-key Integration)
echo Key: $ENTITLEMENT_KEY

createImagePullSecret

ROUTE=$(obtainRoute)
echo Route: $ROUTE

deployHelm
