NAME=$1
PROJECT=mq1
SCC=ibm-anyuid-hostpath-scc
IMAGE_SECRET=prod-secret
TLS_SECRET=ibm-mq-tls-secret

function associateSCC {
  oc adm policy add-scc-to-group $SCC system:serviceaccounts:$PROJECT
}

function createImagePullSecret {
  oc delete secret $IMAGE_SECRET
  oc create secret docker-registry $IMAGE_SECRET \
    --docker-server=cp.icr.io --docker-username=ekey \
    --docker-password=$ENTITLEMENT_KEY
}

function createTlsSecret {
  echo Creating TLS Secret...
  oc delete secret $TLS_SECRET
  oc create secret generic $TLS_SECRET \
    --from-file=tls.crt=$HOME/.helm/cert.pem \
    --from-file=ca.crt=$HOME/.helm/ca.pem \
    --from-file=tls.key=$HOME/.helm/key.pem
}



function deployHelm {
  echo Deploying $NAME
  helm install https://github.com/IBM/charts/blob/master/repo/entitled/ibm-mqadvanced-server-integration-prod-4.1.0.tgz?raw=true \
    --name $NAME --tls --set image.pullSecret=$IMAGE_SECRET \
    --set license="accept"
#    --set persistence.storageClassName=ibmc-file-bronze --set ssoEnabled=false
}



oc project $PROJECT
echo Deploying MQ $NAME
associateSCC

createTlsSecret

#ENTITLEMENT_KEY=$(sudo sh download_pak_entitlement.sh show-key Integration) \
#echo Key: $ENTITLEMENT_KEY

#createImagePullSecret

deployHelm
