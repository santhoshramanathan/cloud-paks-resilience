INSTALL_DIR=/opt/ibm-cloud-private-rhos-3.2.0
CUR_DIR=`pwd`

function install_docker {
  echo Installing docker
  yum install -y docker
  systemctl start docker
}

function extract_images {
  echo Images directory: $IMAGES
  tar xf $IMAGES/ibm-cloud-private-rhos-3.2.0.tar.gz -O | sudo docker load
}

function create_install_directory {
  mkdir -p $INSTALL_DIR
}

function extract_cluster_directory {
   sudo docker run --rm -v $(pwd):/data:z -e LICENSE=accept --security-opt label:disable ibmcom/icp-inception-amd64:3.2.0-rhel-ee cp -r cluster /data
}

function copy_kubeconfig {
  cp ~/.kube/config cluster/kubeconfig
}

function copy_config {
  cp $CUR_DIR/config.yaml $INSTALL_DIR/cluster
}

function install_icp {
  sudo docker run -t --net=host -e LICENSE=accept -v $(pwd):/installer/cluster:z -v /var/run:/var/run:z --security-opt label:disable ibmcom/icp-inception-amd64:3.2.0-rhel-ee install-with-openshift
}

#install_docker
#extract_images
#create_install_directory

cd $INSTALL_DIR

#extract_cluster_directory
#copy_kubeconfig
#copy_config
install_icp
