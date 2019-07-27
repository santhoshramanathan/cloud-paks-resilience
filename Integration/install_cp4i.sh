PROJECT=cp4i
SCC=ibm-privileged-scc
INSTALL_DIR=/root/Integration/install/installer_files/cluster/icipcontent
APIC=IBM-API-Connect-Enterprise-for-IBM-Cloud-Integration-Platform-1.0.0.tgz
APIC_CHART=ibm-apiconnect-cip-prod-1.0.0.tgz
WORK_DIR=/root/work_cp4i

function createProject {
  echo Creating project...
  oc new-project $PROJECT
}

function updateSCC {
  echo Updating Security Context...
  oc adm policy add-scc-to-user $SCC system:serviceaccounts:$PROJECT
}

function createWorkDir {
  echo Creating work directory...
  mkdir -p $WORK_DIR
}

function unpackAPIC {

  echo Unpacking API Connect...
  tar xzvf $INSTALL_DIR/$APIC
}

function dockerLogin {
  # Save endpoint
  export INTERNAL_REG_HOST=`oc get route docker-registry --template='{{ .spec.host }}' -n default`

  # Login
  docker login -u `oc whoami` -p `oc whoami -t` $INTERNAL_REG_HOST
}

function loadImages {
  cd images
  for i in *
  do
    echo Loading $i
    docker load $i
  done
  cd ..
}

function generateYAMLs {
  mkdir -p resources
  helm template $APIC_CHART --namespace $PROJECT --name apic --output-dir resources
}

function installAPIC {
  oc apply --recursive --filename resources
}



# createProject
# updateSCC

cd $WORK_DIR
#unpackAPIC
dockerLogin
loadImages

cd charts
#generateYAMLs
#installAPIC
