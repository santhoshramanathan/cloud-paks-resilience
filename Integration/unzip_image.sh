IMAGE_DIR=/images/Integration/3.2
IMAGE=ibm-cloud-pak-for-integration-x86_64-2019.3.2.1-for-OpenShift.tar.gz
WORK_DIR=/root/work_cp4i
OPENSHIFT_CLIENT=openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

function unzipImage {
  echo Unzipping image...
  tar xvf $IMAGE_DIR/$IMAGE
}

function downloadOC {
  wget https://github.com/openshift/origin/releases/download/v3.11.0/$OPENSHIFT_CLIENT
}

function installOC {
  tar xvzf $OPENSHIFT_CLIENT
  cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
  mv oc kubectl /usr/local/bin
}

function listNodes {
  echo Listing nodes...
  oc get nodes
}

mkdir -p $WORK_DIR
cd $WORK_DIR
#unzipImage
#downloadOC
installOC
listNodes

echo Now you are ready to configure config.yaml
