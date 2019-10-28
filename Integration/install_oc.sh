WORK_DIR=/root/work_cp4i
OPENSHIFT_CLIENT=openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

function downloadOC {
  wget https://github.com/openshift/origin/releases/download/v3.11.0/$OPENSHIFT_CLIENT
}

function installOC {
  tar xvzf $OPENSHIFT_CLIENT
  cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
  mv oc kubectl /usr/local/bin
}

mkdir -p $WORK_DIR
cd $WORK_DIR
#downloadOC
#installOC
