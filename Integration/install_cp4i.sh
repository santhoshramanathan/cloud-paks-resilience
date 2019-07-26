PROJECT=cp4i
SCC=ibm-privileged-scc
INSTALL_DIR=/root/Integration/install/installer_files/cluster/icipcontent
APIC=IBM-API-Connect-Enterprise-for-IBM-Cloud-Integration-Platform-1.0.0.tgz
WORK_DIR=/root/work

function createProject {
  echo Creating project...
  oc new-project $PROJECT
}

function updateSCC {
  echo Updating Security Context...
  oc adm policy add-scc-to-user $SCC system:serviceaccounts:$PROJECT
}

function unpackAPIC {
  echo Creating work directory...
  mkdir -p $WORK_DIR
  cd $WORK_DIR

  echo Unpacking API Connect...
  tar xzvf $INSTALL_DIR/$APIC
}



# createProject
# updateSCC
unpackAPIC
