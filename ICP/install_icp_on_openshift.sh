echo Installing docker
yum install docker.io

echo Images directory: $IMAGES
tar xf $IMAGES/ibm-cloud-private-rhos-3.2.0.tar.gz -O | sudo docker load
