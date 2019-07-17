INSTALL_DIR=/opt/ibm-cloud-private-rhos-3.2.0

function install_docker () {
  echo Installing docker
  yum install -y docker
  systemctl start docker
}

function extract_images () {
  echo Images directory: $IMAGES
  tar xf $IMAGES/ibm-cloud-private-rhos-3.2.0.tar.gz -O | sudo docker load
}

function create_install_directory {
  mkdir $INSTALL_DIR
  cd $INSTALL_DIR
}

#install_docker
#extract_images
create_install_directory

pwd
