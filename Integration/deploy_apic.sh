PROJECT=apic
SCC=add-scc-to-user ibm-anyuid-hostpath-scc

function createProject {
  oc create project $PROJECT
}

function associateSCC {
  oc adm policy add-scc-to-user $SCC \
    system:serviceaccount:$PROJECT:default
}

createProject
associateSCC
