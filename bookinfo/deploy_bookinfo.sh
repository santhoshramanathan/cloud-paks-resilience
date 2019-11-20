function createProject {
  oc new-project bookinfo
}

function deployBookInfo {
  oc apply -n bookinfo \
    -f https://raw.githubusercontent.com/Maistra/bookinfo/maistra-1.0/bookinfo.yaml
}

function exposeBookInfo {
  oc expose svc productpage
}

function obtainRoute {
  oc get route productpage -o jsonpath='{@.status.ingress[0].host}'
}

#createProject
oc project bookinfo
#deployBookInfo
#exposeBookInfo
ROUTE=$(obtainRoute)
echo Route: $ROUTE
