TILLER_NAMESPACE=tiller

function createProject {
    oc new-project $TILLER_NAMESPACE
}

function installHelm {
  curl -s https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz | tar xz
  cd linux-amd64
  ./helm init --client-only
}

#createProject
installHelm
