function createProject {
  oc new-project guestbook
}

function deployRedisMaster {
  oc apply -f https://k8s.io/examples/application/guestbook/redis-master-deployment.yaml
}

function deployRedisMasterService {
  oc apply -f https://k8s.io/examples/application/guestbook/redis-master-service.yaml
}

function deployRedisSlave {
  oc apply -f https://k8s.io/examples/application/guestbook/redis-slave-deployment.yaml
}

function deployRedisSlaveService {
  oc apply -f https://k8s.io/examples/application/guestbook/redis-slave-service.yaml
}

function deployGuestbok {
  oc apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
}

function deployGuestbookService {
  oc apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml
}

function exposeGuestbook {
  oc expose svc frontend
}

function obtainRoute {
  oc get route frontend -o jsonpath='{@.status.ingress[0].host}'
}



#createProject

oc project guestbook
#deployRedisMaster
#deployRedisMasterService
#deployRedisSlave
#deployRedisSlaveService
#deployGuestbok
#deployGuestbookService
exposeGuestbook
ROUTE=$(obtainRoute)
echo Route: $ROUTE
