export TILLER_NAMESPACE=tiller
export HELM_VERSION=v2.16.1

oc new-project tiller
oc project tiller

oc delete deploy tiller

oc process -f https://github.com/openshift/origin/raw/master/examples/helm/tiller-template.yaml \
  -p TILLER_NAMESPACE="${TILLER_NAMESPACE}" -p HELM_VERSION="${HELM_VERSION}" \
  | oc create -f -

oc rollout status deployment tiller
