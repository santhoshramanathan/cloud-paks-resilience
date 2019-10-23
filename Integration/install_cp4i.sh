WORK_DIR=/root/work_cp4i
INSTALLER_FILES_DIR=$WORK_DIR/installer_files/cluster

function configureAccessToRegistry {
#  echo 127.0.0.1 docker-registry.default.svc localhost > /etc/hosts
  kubectl port-forward svc/docker-registry 5000 -n default &
}

function loginToDocker {
  docker login -u openshift -p $(oc whoami -t) docker-registry.default.svc:5000
}

function loadImages {
  echo Loading images...
  cd $INSTALLER_FILES_DIR/images
  tar xf ibm-cloud-private-rhos-3.2.0.1907.tar.gz -O | docker load 2>&1 | tee /tmp/images.log
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
    ibmcom/icp-inception-amd64:3.2.0.1906-rhel-ee uninstall-with-openshift -vvv
}


# Deprecated
function patchPVC {
  echo Patching Mongo PVC
  oc -n kube-system delete pvc $MONGO_PVC
  oc create -f $CUR_DIR/mongo-pvc.yaml
}

# Deprecated
function createRoute {
  oc create route reencrypt --service=docker-registry \
  --hostname=docker-registry.patrocinio3-fa9ee67c9ab6a7791435450358e564cc-0001.us-east.containers.appdomain.cloud
}

function installICP {
  echo Installing ICP from `pwd`...
  docker run -t --net=host -e LICENSE=accept \
    -v $(pwd):/installer/cluster:z -v /var/run:/var/run:z \
    --security-opt label:disable \
    ibmcom/icp-inception-amd64:3.2.0.1906-rhel-ee install-with-openshift -vvv \
    2>&1 | tee /tmp/install.log
}

CUR_DIR=`pwd`

#reconfigureDockerStorage

#configureAccessToRegistry

mkdir -p $WORK_DIR
cd $WORK_DIR
loadImages

cd $INSTALLER_FILES_DIR
#copyConfig
#defineKubeConfig
#uninstallICP
#createRoute
#installICP
