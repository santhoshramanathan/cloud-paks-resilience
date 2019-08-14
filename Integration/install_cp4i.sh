IMAGE_DIR=/images/Integration/3.1
IMAGE=ibm-cloud-pak-for-integration-x86_64-2019.3.1-for-OpenShift.tar
WORK_DIR=/root/work_cp4i

function unzipImage {
  echo Unzipping image...
  tar xvf $IMAGE
}

function loadImages {
  echo Loading images...
  cd images
  tar xf ibm-cloud-private-rhos-3.2.0.1906.tar.gz -O | sudo docker load
  cd ..
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

function configureAccessToRegistry {
  echo 127.0.0.1 docker-registry.default.svc localhost > /etc/hosts
  kubectl port-forward svc/docker-registry 5000 -n default &
}

function defineKubeConfig {
  oc config view > kubeconfig
}

function installICP {
  docker run -t --net=host -e LICENSE=accept -v $(pwd):/installer/cluster:z \
    -v /var/run:/var/run:z --security-opt label:disable \
    ibmcom/icp-inception-amd64:3.2.0.1906-rhel-ee install-with-openshift 2>&1 |
    tee /tmp/install.log
}

CUR_DIR=`pwd`

#reconfigureDockerStorage

cd $IMAGE_DIR
#unzipImage

cd installer_files/cluster
#loadImages
#copyConfig
configureAccessToRegistry
defineKubeConfig
installICP
