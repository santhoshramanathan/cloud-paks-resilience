IMAGE_DIR=/images/Integration/3.2
IMAGE=ibm-cloud-pak-for-integration-x86_64-2019.3.2.1-for-OpenShift.tar.gz
WORK_DIR=/root/work_cp4i

function unzipImage {
  echo Unzipping image...
  tar xvf $IMAGE_DIR/$IMAGE
}

function listNodes {
  echo Listing nodes...
  oc get nodes
}

mkdir -p $WORK_DIR
cd $WORK_DIR
#unzipImage
listNodes

echo Now you are ready to configure config.yaml
