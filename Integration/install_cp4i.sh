IMAGE_DIR=/images/Integration/3.1
IMAGE=ibm-cloud-pak-for-integration-x86_64-2019.3.1-for-OpenShift.tar
WORK_DIR=/root/work_cp4i
MONGO_PVC=mongodbdir-icp-mongodb-0
INSTALLER_FILES_DIR=/root/work_cp4i/installer_files/cluster

function unzipImage {
  echo Unzipping image...
  tar xvf $IMAGE_DIR/$IMAGE
}

function configureAccessToRegistry {
#  echo 127.0.0.1 docker-registry.default.svc localhost > /etc/hosts
  kubectl port-forward svc/docker-registry 5000 -n default &
}

# Deprecated
function loginToDocker {
  docker login -u openshift -p $(oc whoami -t) docker-registry.default.svc:5000
}

function loadImages {
  echo Loading images...
  cd $INSTALLER_FILES_DIR/images
  tar xf ibm-cloud-private-rhos-3.2.0.1906.tar.gz -O | sudo docker load 2>&1 | tee /tmp/images.log
}

function reconfigureDockerStorage {
  cat > /etc/sysconfig/docker-storage-setup << EOF
STORAGE_DRIVER=overlay2
DEVS=/dev/xvdc
VG=docker_vg
EOF
  rm /etc/sysconfig/docker-storage


  systemctl restart docker-storage-setup
  systemctl restart docker
}

function copyConfig {
  cp config.yaml config.yaml.original
  cp $CUR_DIR/config.yaml .
}

function defineKubeConfig {
  oc config view > kubeconfig
}

# Deprecated
function createSymbolicLink {
  echo Creating symbolic link...
  ln -s $INSTALLER_FILES_DIR installer
}

function uninstallICP {
  echo Uninstalling ICP...
  docker run -t --net=host -e LICENSE=accept \
    -v $(pwd):/installer/cluster:z -v /var/run:/var/run:z \
    --security-opt label:disable \
    ibmcom/icp-inception-amd64:3.2.0.1906-rhel-ee uninstall-with-openshift
}


# Deprecated
function patchPVC {
  echo Patching Mongo PVC
  oc -n kube-system delete pvc $MONGO_PVC
  oc create -f $CUR_DIR/mongo-pvc.yaml
}

function createRoute {
  oc create route --service=docker-registry \
  --hostname=docker-registry.patrocinio-fa9ee67c9ab6a7791435450358e564cc-0001.us-east.containers.appdomain.cloud reencypt
}

function installICP {
  echo Installing ICP from `pwd`...
  docker run -t --net=host -e LICENSE=accept \
    -v $(pwd):/installer/cluster:z -v /var/run:/var/run:z \
    --security-opt label:disable \
    ibmcom/icp-inception-amd64:3.2.0.1906-rhel-ee install-with-openshift \
    2>&1 | tee /tmp/install.log
}

CUR_DIR=`pwd`

#reconfigureDockerStorage

configureAccessToRegistry

cd $WORK_DIR
#unzipImage
#loadImages

cd $INSTALLER_FILES_DIR
copyConfig
defineKubeConfig
#uninstallICP
createRoute
#installICP
