IMAGE_DIR=/images/Integration/3.1
IMAGE=ibm-cloud-pak-for-integration-x86_64-2019.3.1-for-OpenShift.tar
WORK_DIR=/root/work_cp4i
MONGO_PVC=mongodbdir-icp-mongodb-0
INSTALLER_FILES_DIR=installer_files/cluster

function unzipImage {
  echo Unzipping image...
  tar xvf $IMAGE_DIR/$IMAGE
}

function configureAccessToRegistry {
#  echo 127.0.0.1 docker-registry.default.svc localhost > /etc/hosts
  kubectl port-forward svc/docker-registry 5000 -n default &
}

function loadImages {
  echo Loading images...
  cd $INSTALLER_FILES_DIR/images
  tar xf ibm-cloud-private-rhos-3.2.0.1906.tar.gz -O | sudo docker load
}

function reconfigureDockerStorage {
  cat > /etc/sysconfig/docker-storage-setup << EOF
STORAGE_DRIVER=devicemapper
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
#loadImages

cd $WORK_DIR
unzipImage
copyConfig
defineKubeConfig

cd $INSTALLER_FILES_DIR
uninstallICP
installICP
