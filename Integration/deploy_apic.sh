PROJECT=apic
SCC=ibm-anyuid-hostpath-scc

function createProject {
  oc new-project $PROJECT
}

function associateSCC {
  oc adm policy add-scc-to-user $SCC \
    system:serviceaccount:$PROJECT:default
}

createProject
associateSCC
