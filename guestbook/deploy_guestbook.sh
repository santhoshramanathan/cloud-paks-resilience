BASE_URL=https://raw.githubusercontent.com/patrocinio/guestbook/master/

function createProject {
  oc new-project guestbook
}

function deployRedisMaster {
  oc apply -f $BASE_URL/redis-master-deployment.yaml
}

function deployRedisMasterService {
  oc apply -f $BASE_URL/redis-master-service.yaml
}

function deployRedisSlave {
  oc apply -f $BASE_URL/redis-slave-deployment.yaml
}

function deployRedisSlaveService {
  oc apply -f $BASE_URL/redis-slave-service.yaml
}

function deployFrontend {
  oc apply -f $BASE_URL/frontend-deployment.yaml
}

function deployFrontendService {
  oc apply -f $BASE_URL/frontend-service.yaml
}

function deployBackend {
  oc apply -f $BASE_URL/backend-deployment.yaml
}

function deployBackendService {
  oc apply -f $BASE_URL/backend-service.yaml
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
deployBackend
deployBackendService
#deployFrontend
#deployFrontendService
#exposeGuestbook
ROUTE=$(obtainRoute)
echo Route: $ROUTE
