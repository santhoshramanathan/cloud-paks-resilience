function install_docker () {
  echo Installing docker
  yum install -y docker
  systemctl start docker
}

install_docker

echo Images directory: $IMAGES
tar xf $IMAGES/ibm-cloud-private-rhos-3.2.0.tar.gz -O | sudo docker load
