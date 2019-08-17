PROJECT=apic
SCC=ibm-anyuid-hostpath-scc
IMAGE_SECRET=myregistrykey
CLUSTER_DOMAIN=docker-registry-default.patrocinio-fa9ee67c9ab6a7791435450358e564cc-0001.us-east.containers.appdomain.cloud
ICP_PASSWORD=passw0rd


function createProject {
  oc new-project $PROJECT
}

function associateSCC {
  oc adm policy add-scc-to-user $SCC system:serviceaccount:$PROJECT:default
}

function createImagePullSecret {
  oc delete secret $IMAGE_SECRET
  oc create secret docker-registry $IMAGE_SECRET \
    --docker-server=$CLUSTER_DOMAIN:8500 --docker-username=admin \
    --docker-password=$ICP_PASSWORD --docker-email=patro@patro.org

}

#createProject
#associateSCC
createImagePullSecret
