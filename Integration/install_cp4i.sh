WORK=~/work/ibm-cp-int
IMAGE=~/DownloadDirector/CP4Integration/ibm-cp-int-2020.1.1-online.tgz

function loadEntitlement {
  echo Loading entitlement key
  . ~/.entitlement
  echo Key: $ENTITLEMENT
}

function logToDocker {
  echo Logging in to Docker repository
  docker login cp.icr.io --username cp --password $ENTITLEMENT
}

function extractPackge {
  echo Extracting Package
  mkdir -p $WORK
  cd $WORK
  tar xvf $IMAGE
}

function loadToDocker {
  echo Loading to Docker
  docker load -i installer_files/cluster/images/icp-inception-3.2.4.tgz
}

function createKubeConfig {
  echo Creating kubeconfig
  oc config view --minify=true --flatten=true > kubeconfig
}

function copyConfig {
  ECHO Copying config file to `pwd`
  cp $CURDIR/config.yaml .
}

function uninstall {
sudo docker run -t --net=host -e LICENSE=accept -v $(pwd):/installer/cluster:z -v /var/run:/var/run:z -v /etc/docker:/etc/docker:z --security-opt label:disable \
  ibmcom/icp-inception-amd64:3.2.4 uninstall-addon -vvv | tee output.txt
}

function install {
  sudo docker run -t --net=host -e LICENSE=accept -v $(pwd):/installer/cluster:z -v /var/run:/var/run:z -v /etc/docker:/etc/docker:z --security-opt label:disable \
    ibmcom/icp-inception-amd64:3.2.4 addon -vvv | tee output.txt
}

CURDIR=`pwd`

loadEntitlement
logToDocker
#extractPackge

cd $WORK
#loadToDocker

cd installer_files/cluster

# Notice you always need to create the kubeconfig file
createKubeConfig

#copyConfig

uninstall
install
