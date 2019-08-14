IMAGE_DIR=/images/Integration/3.1
IMAGE=ibm-cloud-pak-for-integration-x86_64-2019.3.1-for-OpenShift.tar
WORK_DIR=/root/work_cp4i

function unzipImage {
  echo Unzipping image...
  tar xvf $IMAGE
}

function copyConfig {
  cd installer_files/cluster
  cp $CUR_DIR/config.yaml .
}

CUR_DIR=`pwd`

cd $IMAGE_DIR
#unzipImage
copyConfig


 #### Deprecated stuff

PROJECT=cp4i

#SCC=ibm-privileged-scc
#SCC=anyuid
SCC=privileged

SERVICE_ACCOUNT=apic-ibm-apiconnect-icp4i-prod

INSTALL_DIR=/images/Integration/2019.3.1/installer_files/cluster/icp4icontent
APIC=IBM-API-Connect-Enterprise-for-IBM-Cloud-Pak-for-Integration-1.0.1.tgz
APIC_CHART=ibm-apiconnect-icp4i-prod-1.0.1.tgz
REGISTRY_NAME=docker-registry
REGISTRY_URL=docker-registry.default.svc:5000

function createProject {
  echo Creating project...
  oc new-project $PROJECT
}

function updateSCC {
  echo Updating Security Context...
  oc adm policy add-scc-to-user $SCC system:serviceaccount:$PROJECT:$SERVICE_ACCOUNT
}

function addImagePullSecret {
  echo Adding Image Pull Secret
  oc policy add-role-to-user \
    system:image-puller system:serviceaccount:$PROJECT:$SERVICE_ACCOUNT
}

function createWorkDir {
  echo Creating work directory...
  mkdir -p $WORK_DIR
}

function unpackAPIC {

  echo Unpacking API Connect...
  tar xzvf $INSTALL_DIR/$APIC
}

function defineRegistry {
  # Save endpoint
  export INTERNAL_REG_HOST=`oc get route $REGISTRY_NAME --template='{{ .spec.host }}' -n default`

  echo Docker Registry: $INTERNAL_REG_HOST
}

function dockerLogin {
  # Login
  docker login -u `oc whoami` -p `oc whoami -t` $INTERNAL_REG_HOST
}

function reTagImages {
  cd images
  for i in *
  do
    echo Retagging $i
    docker tag $i
  done
}

function loadImages {
  cd images
  for i in *
  do
    echo Loading $i
    docker load --input $i
  done
  cd ..
}

# Thjis function requires the defineRegistry function
function generateYAMLs {
  mkdir -p resources
  helm template $APIC_CHART --namespace $PROJECT --name apic \
    --output-dir resources \
    --set operator.registry=$REGISTRY_URL
}

function removeAPIC {
  oc delete --recursive --filename resources

}

function installAPIC {
  oc apply --recursive --filename resources
}


#createProject
#updateSCC
#addImagePullSecret

#unpackAPIC
#defineRegistry
#dockerLogin
#reTagImages
#loadImages

#cd charts
#generateYAMLs
#removeAPIC
#installAPIC
