BASE_URL=https://raw.githubusercontent.com/patrocinio/guestbook/messaging

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

function deployConsumer {
  oc apply -f $BASE_URL/consumer-deployment.yaml
}

function exposeGuestbook {
  oc expose svc frontend
}

function exposeBackend {
  oc expose svc backend
}

function exposeRedisMaster {
  oc delete route redis-master
  oc expose svc redis-master --port 6379
}

function exposeRedisSlave {
  oc delete route redis-slave
  oc expose svc redis-slave --port 6379
}

function obtainRoute {
  oc get route $1 -o jsonpath='{@.status.ingress[0].host}'
}

function deployQueue {
  oc apply -f $BASE_URL/messaging-deployment.yaml
}

function deployQueueService {
  oc delete -f $BASE_URL/messaging-service.yaml
  oc apply -f $BASE_URL/messaging-service.yaml
}



#createProject

oc project guestbook
#deployRedisMaster
#deployRedisMasterService
#exposeRedisMaster

#deployRedisSlave
#deployRedisSlaveService
#exposeRedisSlave

#deployBackend
#deployBackendService
#exposeBackend

#deployFrontend
#deployFrontendService
#exposeGuestbook

deployQueue
deployQueueService

#deployConsumer

#ROUTE=$(obtainRoute frontend)
#echo Frontend route: $ROUTE

#ROUTE=$(obtainRoute redis-master)
#echo Redis master route: $ROUTE
