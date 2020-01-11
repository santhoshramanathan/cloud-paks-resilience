function prereq {
  cd /Users/edu/github/charts/stable/ibm-db2oltp-dev/ibm_cloud_pak/pak_extensions/prereqs/rhos
  ./createSCCandNS.sh --namespace automation
}

function addRepo {
  helm repo add ibm-charts https://raw.githubusercontent.com/IBM/charts/master/repo/stable/
  helm update
}

function deployDb2 {
  helm install --name my-db2 ibm-charts/ibm-db2oltp-dev --set dataVolume.storageClassName=ibmc-file-bronze --tls
}

#prereq
#addRepo
deployDb2
