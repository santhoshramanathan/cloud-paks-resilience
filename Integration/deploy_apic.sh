NAME=$1
PROJECT=apic
SCC=ibm-anyuid-hostpath-scc
ACCOUNT=my-apic-v4-ibm-apiconnect-icp4i-prod
WORK_DIR=/root/work_cp4i

function deployHelm {
  echo Deploying $NAME
  helm install https://github.com/IBM/charts/raw/master/repo/entitled/ibm-apiconnect-icp4i-prod-1.0.3.tgz \
    --name $NAME --tls -f values.yaml
}

function createRoleBinding {
  oc -n $PROJECT create rolebinding apic-security-policy \
  --clusterrole=ibm-anyuid-hostpath-scc \
  --group=system:serviceaccounts:$PROJECT
}

function associateSCC {
  oc adm policy add-scc-to-user $SCC system:serviceaccount:$PROJECT:$ACCOUNT
}

function createTlsSecret {
  echo Creating TLS Secret...
  oc delete secret helm-tls-secret
  oc create secret generic helm-tls-secret \
    --from-file=cert.pem=$HOME/.helm/cert.pem \
    --from-file=ca.pem=$HOME/.helm/ca.pem \
    --from-file=key.pem=$HOME/.helm/key.pem
}

oc project $PROJECT
echo Deploying API Connect $NAME
#associateSCC
#createRoleBinding
createTlsSecret
deployHelm
