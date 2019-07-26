PROJECT=cp4i
SCC=ibm-privileged-scc
INSTALL_DIR=/root/Integration/install/installer_files/cluster/icipcontent
APIC=IBM-API-Connect-Enterprise-for-IBM-Cloud-Integration-Platform-1.0.0.tgz
APIC_CHART=ibm-apiconnect-cip-prod-1.0.0.tgz
WORK_DIR=/root/work

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

function unpackAPICChart {
  cd charts
  tar xzvf --warning=no-timestamp $APIC_CHART
}



# createProject
# updateSCC
cd $WORK_DIR
#unpackAPIC
unpackAPICChart
