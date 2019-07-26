PROJECT=cp4i
SCC=ibm-privileged-scc
INSTALL_DIR=/root/Integration/install/installer_files/cluster/icipcontent
APIC=IBM-API-Connect-Enterprise-for-IBM-Cloud-Integration-Platform-1.0.0.tgz

function createProject {
  echo Creating project...
  oc new-project $PROJECT
}

function updateSCC {
  echo Updating Security Context...
  oc adm policy add-scc-to-user $SCC system:serviceaccounts:$PROJECT
}

function unpackAPIC {
  echo Unpacking API Connect...
  cd $INSTALL_DIR
  tar xzvf $APIC
}



# createProject
# updateSCC
unpackAPIC
