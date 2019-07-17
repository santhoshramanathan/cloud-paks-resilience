INSTALL_DIR=/opt/ibm-cloud-private-rhos-3.2.0

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
  cd $INSTALL_DIR
}

function extract_cluster_directory {
   sudo docker run --rm -v $(pwd):/data:z -e LICENSE=accept --security-opt label:disable ibmcom/icp-inception-amd64:3.2.0-rhel-ee cp -r cluster /data
}

#install_docker
#extract_images
create_install_directory
extract_cluster_directory
