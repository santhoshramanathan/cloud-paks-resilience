TILLER_NAMESPACE=tiller

function createProject {
    oc new-project $TILLER_NAMESPACE
}

function installHelmClient {
  curl -s https://storage.googleapis.com/kubernetes-helm/helm-v2.9.1-linux-amd64.tar.gz | tar xz
  cd linux-amd64
  ./helm init --client-only
}

function installHelmServer {
oc process -f https://github.com/openshift/origin/raw/master/examples/helm/tiller-template.yaml \
  -p TILLER_NAMESPACE="${TILLER_NAMESPACE}" -p HELM_VERSION=v2.9.0 | oc create -f -
}

#createProject
#installHelmClient
installHelmServer
