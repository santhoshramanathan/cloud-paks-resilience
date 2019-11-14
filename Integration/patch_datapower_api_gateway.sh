function configureAccessToRegistry {
  echo Setting port forward
  kubectl port-forward svc/docker-registry 5000 -n default &
  sleep 2
}

function loginToDocker {
  docker login -p M1383K6UdWvEOPH3LAMpIwTZ8XDNl__MWlwZH3XT0yc -u unused docker-registry.default.svc:5000
}

function pullImage {
  docker pull docker-registry.default.svc:5000/apic/datapower-api-gateway:2018.4.1.7-312001-release-prod
}

#configureAccessToRegistry
#loginToDocker
pullImage
