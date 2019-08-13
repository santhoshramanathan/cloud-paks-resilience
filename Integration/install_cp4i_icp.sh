PROJECT=cp4i
#INSTALL_DIR=/root/Integration/install/installer_files/cluster/icipcontent
#APIC=IBM-API-Connect-Enterprise-for-IBM-Cloud-Integration-Platform-1.0.0.tgz
#APIC_CHART=ibm-apiconnect-cip-prod-1.0.0.tgz
CLUSTER_DOMAIN=patrocinio.icp
INSTALL_FILE=/images/Integration/ibm-cloud-integration-platform-x86_64-2019.2.1.tar.gz
IMAGE_DIR=/images/Integration
IMAGE=IBM_CLOUD_INTEGRATION_PLATFORM_20.zip
IMAGE_SECRET=myregistrykey

function unzipImage {
  echo Unzipping image...
  cd $IMAGE_DIR
  unzip $IMAGE
}

function extractInstall {
  echo Extracting install...
  tar xvf $INSTALL_FILE
}



function createNamespace {
  echo Creating namespace...
  kubectl create ns $PROJECT
}

function updatePSP {
  echo Updating PSP...
  kubectl -n $PROJECT create rolebinding pod-security-policy-rolebinding \
    --clusterrole=pod-security-policy-clusterrole --group=system:serviceaccounts:$PROJECT
}

function addImagePullSecret {
  kubectl config set-context cloudpaks-context --namespace=$PROJECT

  kubectl delete secret $IMAGE_SECRET
  kubectl create secret docker-registry $IMAGE_SECRET --docker-server=$CLUSTER_DOMAIN:8500 \
    --docker-username=admin --docker-password=$ICP_PASSWORD --docker-email=patro@patro.org
}

function login {
  cloudctl login -a https://$CLUSTER_DOMAIN:8443 --skip-ssl-validation -u admin -p $ICP_PASSWORD -n $PROJECT
}

function dockerLogin {
  # Login
  docker login -u admin -p $ICP_PASSWORD $CLUSTER_DOMAIN:8500
}

function installFiles {
  cloudctl catalog load-archive --archive $INSTALL_FILE --registry $CLUSTER_DOMAIN:8500/namespace
}


#unzipImage
#extractInstall
#createNamespace
#updatePSP
#addImagePullSecret
#login
#dockerLogin
installFiles
