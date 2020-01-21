export TILLER_NAMESPACE=tiller

function prereq {
  cd /Users/edu/github/charts/stable/ibm-db2oltp-dev/ibm_cloud_pak/pak_extensions/prereqs/rhos
  ./createSCCandNS.sh --namespace automation
}

function addRepo {
  helm repo add ibm-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable/
  helm update
}

function grantTillerPermission {
  oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
}

function grantHostPathPermission {
  oc adm policy add-scc-to-user privileged -z default
}

function deployDb2 {
  helm delete --purge my-db2

  helm install --name my-db2 ./ibm-db2oltp-dev \
    --set dataVolume.storageClassName=ontap \
    --set db2inst.password=password \
    --set image.repository=ibmcom/db2 \
    --set image.tag=latest
}

#prereq
#addRepo
#grantTillerPermission
#grantHostPathPermission
deployDb2
