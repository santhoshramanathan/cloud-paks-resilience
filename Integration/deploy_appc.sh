NAME=$1
PROJECT=ace
SCC=ibm-anyuid-hostpath-scc
IMAGE_SECRET=docker-registry

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

function deployHelm {
  echo Deploying $NAME
  helm install https://github.com/IBM/charts/blob/master/repo/entitled/ibm-ace-dashboard-icp4i-prod-2.2.0.tgz?raw=true \
    --name $NAME --tls
    #-f /tmp/values.yaml
}

function createImagePullSecret {
  oc delete secret $IMAGE_SECRET
  oc create secret docker-registry $IMAGE_SECRET \
    --docker-server=cp.icr.io --docker-username=cp \
    --docker-password=$ENTITLEMENT_KEY
}



oc project $PROJECT
echo Deploying App Connect $NAME
#associateSCC
#createRoleBinding
#createTlsSecret

#ROUTE=$(obtainRoute)
#echo Route: $ROUTE

createImagePullSecret
#buildValues
#deployHelm
